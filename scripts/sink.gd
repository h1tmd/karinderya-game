extends StaticBody2D

@onready var area_2d = $Area2D
@onready var sprite_2d: Sprite2D = $Sprite2D

var can_interact = false
var plates = 0

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
			print("Put plates: ", plates_recieved)
			plates += plates_recieved
		else:
			while can_interact and plates != 0:
				await get_tree().create_timer(1).timeout
				plates -= 1
				GameState.total_plates += 1
				print("Washed a plate.")
			print("Total plates: " + str(GameState.total_plates))
