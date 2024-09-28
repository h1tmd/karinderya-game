extends CharacterBody2D
@export var speed = 400
@export var friction = 10
@export var acceleration = 5
var direction = Vector2.ZERO
@onready var shape_cast_2d: ShapeCast2D = $ShapeCast2D

func _process(delta):
	direction = Input.get_vector("left","right","up","down")
	shape_cast_2d.look_at(global_position + direction)

func _physics_process(delta):
	if direction.length() > 0:
		velocity = velocity.lerp(direction.normalized() * speed, delta * acceleration)
	else:
		velocity = velocity.lerp(Vector2.ZERO, delta * friction)
	move_and_slide()
	#look_at(get_global_mouse_position())
