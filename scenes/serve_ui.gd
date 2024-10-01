extends Control
@onready var grid_container: GridContainer = $ColorRect/HSplitContainer/ScrollContainer/GridContainer


func _ready() -> void:
	hide()
	load_dishes()

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("serve"):
		visible = not visible

func load_dishes():
	var dir = DirAccess.open("res://dishes/")
	if dir:
		dir.list_dir_begin()
		var file = dir.get_next()
		while file != "":
			var dish_item : Node = TextureRect.new()
			var dish_data : Dish = load("res://dishes/" + file)
			dish_item.texture = dish_data.image
			grid_container.add_child(dish_item)
			file = dir.get_next()
	else:
		print("Error in opening path")
