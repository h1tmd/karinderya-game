extends CharacterBody2D
class_name Player

@onready var interact_reach: Area2D = $InteractReach
@onready var sprite_2d = $Sprite2D
@onready var plate_holder: Node2D = $PlateHolder
@onready var current_speed = speed

var speed = 450
var friction = 10
var acceleration = 10
var direction = Vector2.ZERO
var current_path = []
var queued_path = []
var move_velocity = Vector2.ZERO

func _process(delta):
	direction = Input.get_vector("left","right","up","down")
	interact_reach.look_at(interact_reach.global_position + direction)
	if direction.x > 0:
		sprite_2d.flip_h = true
	elif direction.x < 0:
		sprite_2d.flip_h = false
	
	if current_path.size() > 0:
		move_velocity = position.direction_to(current_path[0]) * speed * delta
		position += move_velocity
		if position.distance_to(current_path[0]) < speed * delta:
			position = current_path[0]
			current_path.remove_at(0)
	elif not queued_path.is_empty():
		current_path = queued_path
		queued_path = []


func _on_plate_holder_child_entered_tree(node: Node) -> void:
	current_speed = max(
		speed - (plate_holder.get_child_count() * GameState.current_difficulty["plate_weight"]), 
		160
	)


func _on_plate_holder_child_exiting_tree(node: Node) -> void:
	current_speed = speed


func go_to(target_position: Vector2):
	queued_path.clear()
	var current_destination
	if not current_path.is_empty():
		current_destination = current_path[-1]
	else:
		current_destination = position
	queued_path = Global.player_astar.get_point_path(
		Global.player_astar.get_closest_point(current_destination), 
		Global.player_astar.get_closest_point(target_position)
	)

func _unhandled_input(event):
	if Input.is_action_just_pressed("click"):
		go_to(get_global_mouse_position())
