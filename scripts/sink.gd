extends StaticBody2D

@onready var area_2d = $Area2D
@onready var sprite_2d: Sprite2D = $Sprite2D

var can_interact = false

func _on_area_2d_area_entered(area):
	if area.name == "InteractReach":
		sprite_2d.material.set_shader_parameter("line_thickness", 15)
		can_interact = true

func _on_area_2d_area_exited(area):
	if area.name == "InteractReach":
		sprite_2d.material.set_shader_parameter("line_thickness", 0)
		can_interact = false

func _unhandled_input(event):
	if Input.is_action_just_pressed("interact") and can_interact:
		var player : Player = area_2d.get_overlapping_areas()[0].get_parent()
		if player.plate_holder.get_child_count() != 0:
			var plates_recieved = player.plate_holder.get_child_count()
			for child in player.plate_holder.get_children():
				child.queue_free()
			GameState.total_plates += plates_recieved
			print("Total plates: " + str(GameState.total_plates) + " (+" + str(plates_recieved) + ")")
