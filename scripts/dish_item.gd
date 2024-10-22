extends TextureRect
class_name DishItem

@onready var texture_rect: TextureRect = $MarginContainer/VBoxContainer/TextureRect
@onready var label: Label = $MarginContainer/VBoxContainer/Label


var dishes_node: Node2D
var mouse_over = false
var dish_data: Dish


func set_data(data: Dish, dish_node: Node2D):
	dish_data = data
	dishes_node = dish_node

func _ready():
	label.text = dish_data.name
	texture_rect.texture = dish_data.image

func _on_mouse_entered():
	mouse_over = true

func _on_mouse_exited():
	mouse_over = false

func _input(event):
	if event.is_action_pressed("click") and mouse_over:
		print(dish_data.name, "created")
		var dish_serving: DishServing
		dish_serving = load("res://scenes/dish_serving.tscn").instantiate()
		dish_serving.set_data(dish_data)
		dishes_node.add_child(dish_serving)
		dish_serving.global_position = get_global_mouse_position()
