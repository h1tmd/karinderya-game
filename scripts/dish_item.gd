extends TextureRect
class_name DishItem

@onready var texture_rect: TextureRect = $MarginContainer/VBoxContainer/TextureRect
@onready var label: Label = $MarginContainer/VBoxContainer/Label


var dishes_node: Node
var mouse_over = false
var dish_data: Dish
const dish_draggable_scene = preload("res://scenes/dish_draggable.tscn")

func set_data(data: Dish, dish_node: Node):
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
		var dish_draggable: DishDraggable
		dish_draggable = dish_draggable_scene.instantiate()
		dish_draggable.set_data(dish_data)
		dishes_node.add_child(dish_draggable)
