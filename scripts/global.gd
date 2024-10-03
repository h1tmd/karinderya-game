extends Node

# List of Dishes available
var dishes = []
# Current customer being served
var current_customer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var dir = DirAccess.open("res://dishes/")
	if dir:
		dir.list_dir_begin()
		var file = dir.get_next()
		while file != "":
			var dish_data : Dish = load("res://dishes/" + file)
			dishes.append(dish_data)
			file = dir.get_next()
	else:
		print("Error in opening path")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
