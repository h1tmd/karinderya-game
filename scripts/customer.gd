extends CharacterBody2D
class_name Customer

@export var standing_sprite: Texture
@export var sitting_sprite: Texture

@onready var person_radar: Area2D = $"Person Radar"
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var food_holder: Node2D = $FoodHolder
@onready var order_bubble: PanelContainer = $"Order Bubble"

signal done_signal(chair_location)

var speed = 250
var order_price = 0
var time_eating = 0
var order = {}
var path = []
var seat = Vector2.ZERO
var order_done = false
var done_eating = false
var person_in_front = false

func _ready() -> void:
	position = Global.exit_loc
	go_to(Global.order_loc)
	order_bubble.hide()

# place/generate order
func generate_order():
	# Generate randomly
	randomize()
	var meal : Dish = Global.dishes.slice(1).pick_random()
	var rice = randi_range(1, 3)
	order = {Global.dishes[0]: rice, meal: 1}
	
	# Convert to a string
	var order_str = ""
	for i in order:
		order_str += "%sx %s\n" % [order[i], i.name]
	order_bubble.set_order(order_str)
	order_bubble.show()
	
	for dish: Dish in order:
		order_price += dish.price * order[dish]
	print("Order price: ", order_price)


# receive order
func receive_order(order_received: Dictionary):
	var mistakes = 0
	var payment = 0.0
	order_bubble.hide()
	
	if order == order_received:
		print(":))")
		payment = order_price * 1.3
	else:
		for dish in order:
			if dish in order_received:
				# incorrect amount
				if not order_received[dish] >= order[dish]:
					mistakes += 1
			else:
				# ordered dish is missing
				mistakes += 1
		for dish in order_received:
			if dish not in order:
				# extra dish not ordered
				mistakes += 1
		
		match mistakes:
			1:
				print(":)")
				payment = order_price * 1.1
			2:
				print(":(")
				payment = order_price * 1
			_:
				print(">:(")
				payment = order_price * 0.5
	order_done = true
	GameState.profit += payment
	print("Paid: ", payment)
	print("Total Profit :", GameState.profit)
	
	# wait for seats
	while GameState.available_seats.is_empty():
		await get_tree().process_frame
	

	for dish in order_received:
		time_eating += dish.price
	print("Time to eat: ", time_eating)
	print()
	if GameState.available_seats[0]:
		seat = GameState.available_seats.pop_at(0)
		go_to(seat)


# Called when customer reaches a chair
func seat_and_eat():
	sprite_2d.texture = sitting_sprite
	await get_tree().create_timer(time_eating).timeout
	
	done_eating = true
	done_signal.emit(seat)
	sprite_2d.texture = standing_sprite
	go_to(Global.exit_loc)


func go_to(target_position: Vector2):
	path.clear()
	if done_eating:
		Global.astar.set_point_disabled(1, true)
	else:
		Global.astar.set_point_disabled(1, false)
	path = Global.astar.get_point_path(
		Global.astar.get_closest_point(position), 
		Global.astar.get_closest_point(target_position)
	)

func _process(delta: float) -> void:
	if path.size() > 0 and not person_in_front:
		var move_velocity = position.direction_to(path[0]) * speed * delta
		person_radar.look_at(path[0])
		position += move_velocity
		if position.distance_to(path[0]) < speed * delta:
			position = path[0]
			path.remove_at(0)
		if move_velocity.x > 0:
			sprite_2d.flip_h = false
		elif move_velocity.x < 0:
			sprite_2d.flip_h = true


func _on_person_radar_body_entered(body: Node2D) -> void:
	person_in_front = check_front()

func _on_person_radar_body_exited(body: Node2D) -> void:
	person_in_front = check_front()


func check_front() -> bool:
	var bodies = person_radar.get_overlapping_bodies()
	
	for body in bodies:
		# Stop if person in front is a customer that has not yet ordered
		if not done_eating and body is Customer and body != self:
			if not body.order_done:
				return true
		if body is Player:
			return true
	return false
