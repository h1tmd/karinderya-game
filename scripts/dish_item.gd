extends PanelContainer
class_name DishItem

@onready var texture_rect = $MarginContainer/VBoxContainer/TextureRect
@onready var label = $MarginContainer/VBoxContainer/Label
@onready var ggparent : Node = $"../../.."

var dish_name : String = ""
var dish_image : Texture
var mouse_over = false

func set_data(dishname : String, dishimage : Texture):
	self.dish_name = dishname
	self.dish_image = dishimage

func _ready():
	label.text = dish_name
	texture_rect.texture = dish_image

func _on_mouse_entered():
	mouse_over = true

func _on_mouse_exited():
	mouse_over = false

func _input(event):
	if event.is_action_pressed("click") and mouse_over:
		var dish_serving : DishServing = load("res://scenes/dish_serving.tscn").instantiate()
		dish_serving.set_area_group(dish_name)
		ggparent.add_child(dish_serving)
		dish_serving.global_position = get_global_mouse_position()
