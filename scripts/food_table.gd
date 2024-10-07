extends StaticBody2D

@onready var serve_ui = $"CanvasLayer/Serve UI"
@onready var sprite_2d = $Sprite2D
var can_interact = false

func _on_area_2d_area_entered(area):
	if area.name == "InteractReach":
		sprite_2d.material.set_shader_parameter("line_thickness", 8)
		can_interact = true

func _on_area_2d_area_exited(area: Area2D):
	if area.name == "InteractReach":
		sprite_2d.material.set_shader_parameter("line_thickness", 0)
		can_interact = false
		serve_ui.hide()

func _unhandled_input(event):
	if Input.is_action_just_pressed("interact") and can_interact:
		serve_ui.visible = not serve_ui.visible
