extends StaticBody2D

@export var flipped = false

@onready var sprite_2d = $Sprite2D
@onready var chair_area: Area2D = $"Chair Area"
@onready var food_on_table: Node2D = $"Food On Table"

const DIRTY_PLATE = preload("res://scenes/dirty_plate.tscn")
var seat_location

func _ready():
	if flipped:
		sprite_2d.flip_h = true
		food_on_table.position.x = -(food_on_table.position.x)

func _on_chair_area_body_entered(body: Node2D) -> void:
	if body is Customer:
		body.seat_and_eat()
		body.connect("done_signal", on_customer_done)
		for dish : Node2D in body.food_holder.get_children():
			dish.call_deferred("reparent", food_on_table, false)

func on_customer_done(seat):
	seat_location = seat
	for node in food_on_table.get_children():
		node.queue_free()
	var dirty_plate = DIRTY_PLATE.instantiate()
	dirty_plate.connect("plate_taken", on_plate_taken)
	food_on_table.add_child(dirty_plate)

func on_plate_taken():
	Global.available_seats.push_front(seat_location)
