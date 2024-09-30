extends StaticBody2D

var can_interact = false

func _on_area_2d_area_entered(area):
	can_interact = true

func _on_area_2d_area_exited(area: Area2D):
	can_interact = false

func _unhandled_input(event):
	if Input.is_action_just_pressed("interact") and can_interact:
		pass
