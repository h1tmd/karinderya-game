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
var plate_weight = 30

func _process(_delta):
	direction = Input.get_vector("left","right","up","down")
	interact_reach.look_at(interact_reach.global_position + direction)
	if direction.x > 0:
		sprite_2d.flip_h = true
	elif direction.x < 0:
		sprite_2d.flip_h = false


func _physics_process(delta):
	if direction.length() > 0:
		velocity = velocity.lerp(direction.normalized() * current_speed, delta * acceleration)
	else:
		velocity = velocity.lerp(Vector2.ZERO, delta * friction)
	move_and_slide()


func _on_plate_holder_child_entered_tree(node: Node) -> void:
	current_speed = max(speed - (plate_holder.get_child_count() * plate_weight), 160)


func _on_plate_holder_child_exiting_tree(node: Node) -> void:
	current_speed = speed
