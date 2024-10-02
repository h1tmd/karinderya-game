extends PanelContainer
class_name DishItem

@onready var texture_rect = $MarginContainer/VBoxContainer/TextureRect
@onready var label = $MarginContainer/VBoxContainer/Label

var label_text : String = ""
var sprite_image : Texture

func set_data(dish_name : String, dish_image : Texture):
	self.label_text = dish_name
	self.sprite_image = dish_image
	print(dish_name, dish_image)

func _ready():
	label.text = label_text
	texture_rect.texture = sprite_image
