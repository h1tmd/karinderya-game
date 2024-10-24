extends Control

@onready var grid_container: GridContainer = $NinePatchRect/HSplitContainer/ScrollContainer/GridContainer
@onready var dishes_node: Node = %DishesNode
@onready var serve_button: TextureButton = $"HBoxContainer/Serve Button"
@onready var sfx_bell: AudioStreamPlayer = $"SFX Bell"
@onready var sfx_drop: AudioStreamPlayer = $"SFX Drop"
@onready var sfx_close: AudioStreamPlayer = $"SFX Close"


func _ready() -> void:
	hide()
	add_plate()
	load_dishes()


func load_dishes():
	var dish_scn: PackedScene = load(("res://scenes/dish_item.tscn"))
	for dish_data: Dish in Global.dishes:
		var dish_item: DishItem = dish_scn.instantiate()
		dish_item.set_data(dish_data, dishes_node)
		grid_container.add_child(dish_item)


func add_plate():
	var plate = load("res://scenes/plate.tscn").instantiate()
	dishes_node.add_child(plate)


func _on_button_pressed():
	# Make order dictionary
	var order = {}
	var dishes_served = dishes_node.get_children()
	for dish_served: Node in dishes_served:
		# if plate, skip
		if dish_served is not DishDraggable:
			continue
		var dish = dish_served.dish_data
		if dish not in order:
			order[dish] = 1
		else:
			order[dish] += 1
	
	# Pass to customer
	var cust: Customer = Customer.current_customer
	if cust:
		GameState.available_plates -= plate_counter()
		cust.receive_order(order)
		Customer.current_customer = null
		for child: Node in dishes_node.get_children():
			if child is DishDraggable:
				child.set_process(false)
				child.selected = false
				child.hide_highlight()
				DishDraggable.currently_selected = null
			child.reparent(cust.food_holder, false)
		sfx_bell.play()
		add_plate()


func _on_dishes_node_child_order_changed() -> void:
	GameState.plates_placed = plate_counter()
	if is_instance_valid(serve_button):
		if dishes_node.get_child_count() <= 1:
			serve_button.disabled = true
		elif plate_counter() > GameState.available_plates:
			serve_button.disabled = true
		else:
			serve_button.disabled = false

func plate_counter() -> int:
	var plates = 0
	for dish_served in dishes_node.get_children():
		# if plate, skip
		if dish_served is not DishDraggable:
			plates += 1
			continue
		elif dish_served.dish_data.name != "Rice":
			plates += 1
	return plates


func dish_dropped():
	sfx_drop.play()


func _on_dishes_node_child_entered_tree(node: Node) -> void:
	if node is DishDraggable:
		node.connect("dropped", dish_dropped)


func _on_cancel_button_pressed() -> void:
	sfx_close.play()
	hide()
