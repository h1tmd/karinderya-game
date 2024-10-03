extends Control
@onready var grid_container: GridContainer = $ColorRect/HSplitContainer/ScrollContainer/GridContainer
@onready var serving_area = $"ColorRect/HSplitContainer/Panel/Serving Area"


func _ready() -> void:
	hide()
	load_dishes()

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("serve"):
		visible = not visible

func load_dishes():
	var dish_scene = load(("res://scenes/dish_item.tscn"))
	var dir = DirAccess.open("res://dishes/")
	if dir:
		dir.list_dir_begin()
		var file = dir.get_next()
		while file != "":
			var dish_item : Node = dish_scene.instantiate()
			var dish_data : Dish = load("res://dishes/" + file)
			dish_item.set_data(dish_data.name, dish_data.image)
			grid_container.add_child(dish_item)
			file = dir.get_next()
	else:
		print("Error in opening path")


func _on_button_pressed():
	var dishes_served = serving_area.get_overlapping_areas()
	var order = {}
	for dish_served : Area2D in dishes_served:
		var dish = dish_served.get_groups()[0]
		if dish not in order:
			order[dish] = 1
		else:
			order[dish] += 1
	print(order)
