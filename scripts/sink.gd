extends StaticBody2D

@onready var area_2d = $Area2D
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var timer: Timer = $Timer
@onready var timer_circle: TextureProgressBar = $"Timer Circle"

@export var sink_sprite: Texture2D
@export var sink_dishes_sprite: Texture2D

var can_interact = false
var plates: int = 0
var washing = false

func _on_area_2d_area_entered(area):
	if area.name == "InteractReach":
		sprite_2d.material.set_shader_parameter("line_thickness", 15)
		can_interact = true

func _on_area_2d_area_exited(area):
	if area.name == "InteractReach":
		sprite_2d.material.set_shader_parameter("line_thickness", 0)
		can_interact = false
		timer_circle.hide()

func _unhandled_input(event):
	if Input.is_action_just_pressed("interact") and can_interact:
		var player : Player = area_2d.get_overlapping_areas()[0].get_parent()
		if player.plate_holder.get_child_count() != 0:
			var plates_recieved = player.plate_holder.get_child_count()
			for child in player.plate_holder.get_children():
				child.queue_free()
			print("Put plates: ", plates_recieved)
			plates += plates_recieved
			sprite_2d.texture = sink_dishes_sprite
		elif not washing:
			washing = true
			timer.start(plates * 0.8)
			timer_circle.show()
			while can_interact and plates != 0:
				await get_tree().create_timer(0.8).timeout
				plates -= 1
				GameState.available_plates += 1
				print("Washed a plate.")
			timer_circle.hide()
			washing = false
			if plates == 0:
				sprite_2d.texture = sink_sprite
			print("Total plates: " + str(GameState.available_plates))
