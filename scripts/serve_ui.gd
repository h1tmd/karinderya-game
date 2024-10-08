extends Control

@onready var grid_container: GridContainer = $ColorRect/HSplitContainer/ScrollContainer/GridContainer
@onready var serving_area: Area2D = $"ColorRect/HSplitContainer/MarginContainer/Panel/Serving Area"
@onready var dishes_node: Node2D = $ColorRect/HSplitContainer/MarginContainer/Panel/DishesNode


func _ready() -> void:
	hide()
	load_dishes()

func load_dishes():
	var dish_scn : PackedScene = load(("res://scenes/dish_item.tscn"))
	#plate
	var plate:DishItem = dish_scn.instantiate()
	plate.set_data("Plate", load("res://assets/plate.png"), dishes_node)
	grid_container.add_child(plate)
	for dish:Dish in Global.dishes:
		var dish_item : DishItem = dish_scn.instantiate()
		dish_item.set_data(dish.name, dish.image, dishes_node)
		grid_container.add_child(dish_item)

func _on_button_pressed():
	var dishes_served = serving_area.get_overlapping_areas()
	if dishes_served.is_empty():
		return
	var order = {}
	for dish_served : Area2D in dishes_served:
		if not dish_served.get_groups().is_empty():
			var dish = dish_served.get_groups()[0]
			if dish not in order:
				order[dish] = 1
			else:
				order[dish] += 1
	print(order)
	var cust : Customer = Global.current_customer
	if cust:
		cust.receive_order(order)
		Global.current_customer = null
		for child: DishServing in dishes_node.get_children():
			child.scale = Vector2(0.8, 0.8)
			child.reparent(cust.food_holder, false)
			
