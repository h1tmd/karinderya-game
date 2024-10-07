extends StaticBody2D

@onready var area_2d = $Area2D

var can_interact = false

func _on_area_2d_area_entered(area):
	if area.name == "InteractReach":
		can_interact = true

func _on_area_2d_area_exited(area):
	if area.name == "InteractReach":
		can_interact = false

func _unhandled_input(event):
	if Input.is_action_just_pressed("interact") and can_interact:
		var player : Player = area_2d.get_overlapping_areas()[0].get_parent()
		if player.plate_holder.get_child_count() != 0:
			for child in player.plate_holder.get_children():
				child.queue_free()
