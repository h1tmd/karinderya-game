extends StaticBody2D

@export var flipped = false

@onready var sprite_2d = $Sprite2D
@onready var chair_area: Area2D = $"Chair Area"
@onready var food_on_table: Node2D = $"Food On Table"
@onready var click_area: Area2D = $"Click Area"
@onready var player_pickup_area: Area2D = $"Player Pickup Area"
@onready var sfx_get: AudioStreamPlayer = $"SFX Get"

const DIRTY_PLATE = preload("res://scenes/dirty_plate.tscn")

signal highlight_signal(value: bool)

var seat_location
var can_interact = false
var pickup_plates = false

func _ready():
	if flipped:
		sprite_2d.flip_h = true
		food_on_table.position.x = -(food_on_table.position.x)
		click_area.position.x = -click_area.position.x
		player_pickup_area.position.x = -player_pickup_area.position.x
	if food_on_table.get_child_count() != 0:
		pickup_plates = true
		var seat_point = Global.customer_astar.get_point_position(Global.customer_astar.get_closest_point(global_position))
		GameState.available_seats.erase(seat_point)
		seat_location = seat_point

func _on_chair_area_body_entered(body: Node2D) -> void:
	if body is Customer:
		body.seat_and_eat()
		body.connect("done_signal", on_customer_done)
		for dish : Node2D in body.food_holder.get_children():
			dish.call_deferred("reparent", food_on_table, false)

func on_customer_done(seat):
	pickup_plates = true
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
		#dirty_plate.connect("plate_taken", on_plate_taken)
		connect("highlight_signal", dirty_plate.highlight)
		node.queue_free()
		food_on_table.add_child(dirty_plate)

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("click") and \
	pickup_plates and can_interact:
		Global.player.go_to(player_pickup_area.global_position)

func on_plate_taken():
	if food_on_table.get_child_count() == 0 and seat_location not in GameState.available_seats:
		GameState.available_seats.push_front(seat_location)


func _on_click_area_mouse_entered() -> void:
	can_interact = true
	highlight_signal.emit(can_interact)


func _on_click_area_mouse_exited() -> void:
	can_interact = false
	highlight_signal.emit(can_interact)


func _on_player_pickup_area_body_entered(body: Node2D) -> void:
	if body is Player and pickup_plates:
		for dirty_plate: DirtyPlate in food_on_table.get_children():
			dirty_plate.position = Vector2.ZERO
			if body.plate_holder.get_child_count() != 0:
				dirty_plate.position.y = body.plate_holder.get_child(-1).position.y - 40
			dirty_plate.plate_taken.emit()
			dirty_plate.call_deferred("reparent", body.plate_holder, false)
			dirty_plate.collision_shape_2d.set_deferred("disabled", true)
			sfx_get.play()
			GameState.available_seats.push_front(seat_location)
