extends CharacterBody2D
class_name Player

@onready var interact_reach: Area2D = $InteractReach
@onready var sprite_2d = $Sprite2D
@onready var plate_holder: Node2D = $PlateHolder
@onready var current_speed = speed

var speed = 500
var friction = 10
var acceleration = 10
var direction = Vector2.ZERO
var path = []

func _process(delta):
	direction = Input.get_vector("left","right","up","down")
	interact_reach.look_at(interact_reach.global_position + direction)
	if direction.x > 0:
		sprite_2d.flip_h = true
	elif direction.x < 0:
		sprite_2d.flip_h = false
	if path.size() > 0:
		var move_velocity = position.direction_to(path[0]) * speed * delta
		position += move_velocity
		if position.distance_to(path[0]) < speed * delta:
			position = path[0]
			path.remove_at(0)



func _physics_process(delta):
	if direction.length() > 0:
		velocity = velocity.lerp(direction.normalized() * current_speed, delta * acceleration)
	else:
		velocity = velocity.lerp(Vector2.ZERO, delta * friction)
	move_and_slide()


func _on_plate_holder_child_entered_tree(node: Node) -> void:
	current_speed = max(
		speed - (plate_holder.get_child_count() * GameState.current_difficulty["plate_weight"]), 
		160
	)


func _on_plate_holder_child_exiting_tree(node: Node) -> void:
	current_speed = speed


func go_to(target_position: Vector2):
	# wait until player reaches a point before changing path
	path.clear()
	path = Global.player_astar.get_point_path(
		Global.player_astar.get_closest_point(position), 
		Global.player_astar.get_closest_point(target_position)
	)

func _unhandled_input(event):
	if Input.is_action_just_pressed("click"):
		go_to(get_global_mouse_position())
