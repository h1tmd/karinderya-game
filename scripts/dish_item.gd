extends PanelContainer
class_name DishItem

@onready var texture_rect = $MarginContainer/VBoxContainer/TextureRect
@onready var label = $MarginContainer/VBoxContainer/Label
@onready var ggparent : Node = $"../../.."

var label_text : String = ""
var sprite_image : Texture
var mouse_over = false

func set_data(dish_name : String, dish_image : Texture):
	self.label_text = dish_name
	self.sprite_image = dish_image

func _ready():
	label.text = label_text
	texture_rect.texture = sprite_image

func _on_mouse_entered():
	mouse_over = true

func _on_mouse_exited():
	mouse_over = false

func _input(event):
	if event.is_action_pressed("click") and mouse_over:
		var dish_serving = load("res://scenes/dish_serving.tscn").instantiate()
		#var dish_serving = dish_serving_scn.instantiate()
		ggparent.add_child(dish_serving)
		dish_serving.global_position = get_global_mouse_position()
