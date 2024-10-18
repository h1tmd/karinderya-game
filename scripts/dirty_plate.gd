extends Sprite2D

var is_bowl = false
var can_interact = false
signal plate_taken

@onready var area_2d: Area2D = $Area2D
@onready var collision_shape_2d: CollisionShape2D = $Area2D/CollisionShape2D
@onready var sfx_get: AudioStreamPlayer = $"SFX Get"

func _ready() -> void:
	if is_bowl:
		texture = load("res://assets/dirtybowl.png")

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.name == "InteractReach":
		material.set_shader_parameter("line_thickness", 30)
		can_interact = true

func _on_area_2d_area_exited(area: Area2D) -> void:
	if area.name == "InteractReach":
		material.set_shader_parameter("line_thickness", 0)
		can_interact = false

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("interact") and can_interact:
		var player : Player 
		for area in area_2d.get_overlapping_areas():
			if area.get_parent() is Player:
				player = area.get_parent()
		position = Vector2.ZERO
		if player.plate_holder.get_child_count() != 0:
			position.y = player.plate_holder.get_child(-1).position.y - 40
		reparent(player.plate_holder, false)
		collision_shape_2d.disabled = true
		sfx_get.play()
		plate_taken.emit()
