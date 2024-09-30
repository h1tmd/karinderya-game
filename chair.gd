extends StaticBody2D
@export var flipped = false
@onready var sprite_2d = $Sprite2D

func _ready():
	if flipped:
		sprite_2d.flip_h = true
