extends StaticBody2D
@export var flipped = false
@onready var sprite_2d = $Sprite2D
@onready var chair_area: Area2D = $"Chair Area"
@onready var food_on_table: Node2D = $"Food On Table"

func _ready():
	if flipped:
		sprite_2d.flip_h = true
		food_on_table.position.x = -(food_on_table.position.x)


func _on_chair_area_body_entered(body: Node2D) -> void:
	if body is Customer:
		body.seat_and_eat()
		for dish : DishServing in body.food_holder.get_children():
			dish.call_deferred("reparent", food_on_table, false)
