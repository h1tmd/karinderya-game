extends Control

@onready var grid_container: GridContainer = $NinePatchRect/HSplitContainer/ScrollContainer/GridContainer
@onready var dishes_node: Node2D = $NinePatchRect/HSplitContainer/MarginContainer/Panel/DishesNode
@onready var custom_button: TextureButton = $CustomButton

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
	for dish_served: Sprite2D in dishes_served:
		# if plate, skip
		if dish_served is not DishServing:
			continue
		var dish = dish_served.dish_data
		if dish not in order:
			order[dish] = 1
		else:
			order[dish] += 1
	
	# Pass to customer
	var cust: Customer = Global.current_customer
	if cust:
		GameState.total_plates -= plate_counter()
		cust.receive_order(order)
		Global.current_customer = null
		for child: Node2D in dishes_node.get_children():
			if child is DishServing:
				child.selected = false
				child.hide_highlight()
			child.scale = Vector2(0.8, 0.8)
			child.reparent(cust.food_holder, false)
		add_plate()


func _on_dishes_node_child_order_changed() -> void:
	if dishes_node.get_child_count() <= 1:
		custom_button.disabled = true
	elif plate_counter() > GameState.total_plates:
		custom_button.disabled = true
	else:
		custom_button.disabled = false


func plate_counter() -> int:
	var plates = 0
	for dish_served in dishes_node.get_children():
		# if plate, skip
		if dish_served is not DishServing:
			plates += 1
			continue
		elif dish_served.dish_data.name != "Rice":
			plates += 1
	return plates
