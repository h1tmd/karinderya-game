extends Control

@onready var grid_container: GridContainer = $ColorRect/HSplitContainer/ScrollContainer/GridContainer
@onready var serving_area: Area2D = $"ColorRect/HSplitContainer/MarginContainer/Panel/Serving Area"
@onready var dishes_node: Node2D = $ColorRect/HSplitContainer/MarginContainer/Panel/DishesNode


func _ready() -> void:
	hide()
	load_dishes()

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("serve"):
		visible = not visible

func load_dishes():
	var dish_scn = load(("res://scenes/dish_item.tscn"))
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
			child.reparent(cust.food_holder, false)
			
