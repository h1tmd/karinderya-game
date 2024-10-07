extends Sprite2D

var can_interact = false
signal plate_taken

@onready var area_2d: Area2D = $Area2D
@onready var collision_shape_2d: CollisionShape2D = $Area2D/CollisionShape2D

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.name == "InteractReach":
		can_interact = true

func _on_area_2d_area_exited(area: Area2D) -> void:
	if area.name == "InteractReach":
		can_interact = false

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("interact") and can_interact:
		var player : Player = area_2d.get_overlapping_areas()[0].get_parent()
		if player.plate_holder.get_child_count() != 0:
			position.y = player.plate_holder.get_child(-1).position.y - 30
		reparent(player.plate_holder, false)
		collision_shape_2d.disabled = true
		plate_taken.emit()