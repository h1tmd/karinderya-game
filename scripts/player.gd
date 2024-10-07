extends CharacterBody2D
class_name Player

@export var speed = 400
@export var friction = 10
@export var acceleration = 5

@onready var interact_reach: Area2D = $InteractReach
@onready var sprite_2d = $Sprite2D
@onready var plate_holder: Node2D = $PlateHolder

var direction = Vector2.ZERO

func _process(_delta):
	direction = Input.get_vector("left","right","up","down")
	interact_reach.look_at(interact_reach.global_position + direction)
	if direction.x > 0:
		sprite_2d.flip_h = true
	elif direction.x < 0:
		sprite_2d.flip_h = false

func _physics_process(delta):
	if direction.length() > 0:
		velocity = velocity.lerp(direction.normalized() * speed, delta * acceleration)
	else:
		velocity = velocity.lerp(Vector2.ZERO, delta * friction)
	move_and_slide()
