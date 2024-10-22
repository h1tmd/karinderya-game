extends StaticBody2D

@onready var area_2d = $Area2D
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var timer: Timer = $Timer
@onready var timer_circle: TextureProgressBar = $"Timer Circle"
@onready var sfx_receive_plates: AudioStreamPlayer = $"SFX Receive Plates"
@onready var sfx_wash: AudioStreamPlayer = $"SFX Wash"

@export var sink_sprite: Texture2D
@export var sink_dishes_sprite: Texture2D

signal interacted

var can_interact = false
var plates: int = 0
var washing = false

const WASH_LOCATION = Vector2(1788, 320)

func _unhandled_input(event):
	if Input.is_action_just_pressed("click") and can_interact:
		Global.player.go_to(WASH_LOCATION)
		await Global.player.arrived
		print(Global.player.position, WASH_LOCATION, Global.player.position == WASH_LOCATION)
		if Global.player.position == WASH_LOCATION:
			if Global.player.plate_holder.get_child_count() != 0:
				var plates_recieved = Global.player.plate_holder.get_child_count()
				for child in Global.player.plate_holder.get_children():
					child.queue_free()
				print("Put plates: ", plates_recieved)
				plates += plates_recieved
				sfx_receive_plates.play()
				sprite_2d.texture = sink_dishes_sprite
				interacted.emit()
			
			timer.start(plates * GameState.current_difficulty["wash_time"])
			timer_circle.show()
			while Global.player.position == WASH_LOCATION and plates != 0:
				await get_tree().create_timer(GameState.current_difficulty["wash_time"]).timeout
				plates -= 1
				GameState.available_plates += 1
				sfx_wash.play()
				print("Washed a plate.")
			timer_circle.hide()
			if plates == 0:
				sprite_2d.texture = sink_sprite
			print("Total plates: " + str(GameState.available_plates))

func _on_area_2d_mouse_entered() -> void:
	sprite_2d.material.set_shader_parameter("line_thickness", 15)
	can_interact = true

func _on_area_2d_mouse_exited() -> void:
	sprite_2d.material.set_shader_parameter("line_thickness", 0)
	can_interact = false
