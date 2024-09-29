extends CharacterBody2D
@export var speed = 400
@export var friction = 10
@export var acceleration = 5
var direction = Vector2.ZERO
@onready var interact_reach: Area2D = $InteractReach

func _process(delta):
	direction = Input.get_vector("left","right","up","down")
	interact_reach.look_at(global_position + direction)

func _physics_process(delta):
	if direction.length() > 0:
		velocity = velocity.lerp(direction.normalized() * speed, delta * acceleration)
	else:
		velocity = velocity.lerp(Vector2.ZERO, delta * friction)
	move_and_slide()
