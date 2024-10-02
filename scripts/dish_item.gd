extends PanelContainer
class_name DishItem

@onready var texture_rect = $MarginContainer/VBoxContainer/TextureRect
@onready var label = $MarginContainer/VBoxContainer/Label

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
	print("exit")

#func _input(event):
	#if event.is_action_pressed("click") and event.is_pressed():
		#print("clicksfded")
	#if Input.is_action_just_pressed("click") and not event.is_echo(): 
		#if mouse_over:
