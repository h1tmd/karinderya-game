extends StaticBody2D

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

func _ready() -> void:
	print(to_local(WASH_LOCATION))

func _unhandled_input(event):
	if Input.is_action_just_pressed("click"):
		for i in range(2): await get_tree().physics_frame
		if can_interact:
			Global.player.go_to(WASH_LOCATION)
			await Global.player.arrived
			if Global.player.position == WASH_LOCATION:
				interacted.emit()
				timer.start(plates * GameState.current_difficulty["wash_time"])
				timer_circle.show()
				while Global.player.position == WASH_LOCATION and plates != 0:
					await get_tree().create_timer(GameState.current_difficulty["wash_time"]).timeout
					plates -= 1
					GameState.available_plates += 1
					sfx_wash.play()
				timer_circle.hide()
				if plates == 0:
					sprite_2d.texture = sink_sprite


func _on_area_2d_mouse_entered() -> void:
	sprite_2d.material.set_shader_parameter("line_thickness", 15)
	can_interact = true

func _on_area_2d_mouse_exited() -> void:
	sprite_2d.material.set_shader_parameter("line_thickness", 0)
	can_interact = false


func _on_wash_area_body_entered(body: Node2D) -> void:
	if body is Player:
		if body.get_child_count() != 0:
			var plates_recieved = body.plate_holder.get_child_count()
			for child in body.plate_holder.get_children():
				child.queue_free()
			plates += plates_recieved
			sfx_receive_plates.play()
			sprite_2d.texture = sink_dishes_sprite
