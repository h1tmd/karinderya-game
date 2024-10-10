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
	for node: Sprite2D in food_on_table.get_children():
		var dirty_plate = DIRTY_PLATE.instantiate()
		if node is DishServing:
			if node.dish_data.name == "Rice":
				node.queue_free()
				continue
			else:
				dirty_plate.is_bowl = node.dish_data.is_bowl
		elif node.name != "Plate":
			print("Error identifiying food on table child")
			return
		dirty_plate.position = node.position
		dirty_plate.connect("plate_taken", on_plate_taken)
		node.queue_free()
		food_on_table.add_child(dirty_plate)

func on_plate_taken():
	if food_on_table.get_child_count() == 0 and seat_location not in GameState.available_seats:
		GameState.available_seats.push_front(seat_location)
