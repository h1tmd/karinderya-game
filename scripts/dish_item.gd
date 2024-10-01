extends PanelContainer
class_name DishItem

@onready var sprite_2d: Sprite2D = $VBoxContainer/Sprite2D
@onready var label: Label = $VBoxContainer/Label

func set_data(name : String, image : Texture):
	label.set_text("hello")
	sprite_2d.texture = image
