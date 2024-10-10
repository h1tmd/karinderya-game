extends Control

@onready var grid_container: GridContainer = $ColorRect/HSplitContainer/ScrollContainer/GridContainer
@onready var dishes_node: Node2D = $ColorRect/HSplitContainer/MarginContainer/Panel/DishesNode


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
	var plates_used = 1
	var dishes_served = dishes_node.get_children()
	if dishes_served.is_empty():
		return
	for dish_served: Sprite2D in dishes_served:
		# if plate, skip
		if dish_served is not DishServing:
			continue
		
		var dish = dish_served.dish_data.name
		if dish != "Rice":
			plates_used += 1
		if dish not in order:
			order[dish] = 1
		else:
			order[dish] += 1
	
	GameState.total_plates -= plates_used
	print(order)
	print("Total plates: " + str(GameState.total_plates) + " (-" + str(plates_used) + ")")

	# Pass to customer
	var cust: Customer = Global.current_customer
	if cust:
		cust.receive_order(order)
		Global.current_customer = null
		for child: Node2D in dishes_node.get_children():
			child.scale = Vector2(0.8, 0.8)
			child.reparent(cust.food_holder, false)
		add_plate()
