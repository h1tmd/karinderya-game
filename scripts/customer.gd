extends CharacterBody2D
class_name Customer

@export var head_sprites: Array[Texture]
@export var body_sprites: Array[Texture]

@onready var head: Sprite2D = $Head
@onready var body: Sprite2D = $Body

@onready var person_radar: Area2D = $"Person Radar"
@onready var food_holder: Node2D = $FoodHolder
@onready var order_bubble: PanelContainer = $"Order Bubble"
@onready var timer: Timer = $Timer
@onready var timer_circle: TextureProgressBar = $"Timer Circle"
@onready var wait_timer: TextureProgressBar = $"Wait Timer"

signal done_signal(chair_location)

var speed = 250
var order_price = 0
var time_eating = 0
var order = {}
var path = []
var seat = Vector2.ZERO
var order_done = false
var done_eating = false
var walking_out = false
var person_in_front = false

static var current_customer: Customer = null

const DEFAULT = 0
const HAPPY = 1
const SATISFIED = 2
const SAD = 3
const ANGRY = 4
const FUMING = 5
const EAT = 6
const COLORS = [
	Color(0.928, 0.375, 0.341), Color(0.998, 0.661, 0.365), Color(0.891, 0.853, 0.292), 
	Color(0.563, 0.957, 0.546), Color(0.497, 0.562, 0.949), Color(0.924, 0.582, 0.926) 
]

func _ready() -> void:
	position = Global.exit_loc
	go_to(Global.order_loc)
	order_bubble.hide()
	body.modulate = COLORS.pick_random()

# place/generate order
func generate_order():
	# Generate randomly
	var meal : Dish = Global.dishes.slice(1).pick_random()
	var rice = Global.weighted_random()
	var meal_quantity = Global.weighted_random()
	if meal_quantity == 3:
		# 2 Dishes
		var new_meal = meal
		while new_meal == meal:
			new_meal = Global.dishes.slice(1).pick_random()
		order = {Global.dishes[0]: rice, meal: 1, new_meal: 1}
	else:
		# 1 Dish
		order = {Global.dishes[0]: rice, meal: meal_quantity}
	
	# Convert to a string
	var order_str = ""
	for i in order:
		order_str += "%sx %s\n" % [order[i], i.name]
	
	for dish: Dish in order:
		order_price += dish.price * order[dish]
	print("Order price: ", order_price)
	order_str += "[ ₱ %01.2f ]" % order_price
	order_bubble.set_order(order_str)
	order_bubble.show()
	
	# Waiting
	var wait_time = GameState.current_difficulty["cust_timer"]
	if wait_time == 0:
		return
	timer.start(wait_time)
	wait_timer.show()
	
	await get_tree().create_timer(wait_time / 2.0).timeout
	if order_done: return
	head.texture = head_sprites[ANGRY] 
	await get_tree().create_timer(wait_time / 4.0).timeout
	if order_done: return
	head.texture = head_sprites[FUMING]
	await timer.timeout
	if not order_done:
		current_customer = null
		GameState.ideal_profit += order_price * 1.3
		wait_timer.hide()
		order_bubble.hide()
		order_done = true
		done_eating = true
		go_to(Global.exit_loc)


# receive order
func receive_order(order_received: Dictionary):
	var mistakes = 0
	var payment = 0.0
	order_bubble.hide()
	GameState.ideal_profit += order_price * 1.3
	
	if not timer.is_stopped():
		timer.stop()
		wait_timer.hide()
	
	if order == order_received:
		print(":))")
		head.texture = head_sprites[HAPPY]
		payment = order_price * 1.3
	else:
		for dish in order:
			if dish in order_received:
				# incorrect amount
				if not order_received[dish] >= order[dish]:
					mistakes += 1
			else:
				# ordered dish is missing
				mistakes += 2
		for dish in order_received:
			if dish not in order:
				# extra dish not ordered
				mistakes += 1
		
		match mistakes:
			1:
				print(":)")
				head.texture = head_sprites[SATISFIED]
				payment = order_price * 1.0
			2:
				print(":(")
				head.texture = head_sprites[SAD]
				payment = order_price * 0.8
			_:
				print(">:(")
				head.texture = head_sprites[ANGRY]
				payment = order_price * 0.0
	order_done = true
	GameState.profit += payment
	print("Paid: ", payment)
	print("Total Profit :", GameState.profit)
	
	# wait for seats
	while GameState.available_seats.is_empty():
		await get_tree().process_frame
	
	for dish in order_received:
		time_eating += dish.price * order_received[dish]
	print("Time to eat: ", time_eating)
	print()
	if GameState.available_seats[0]:
		seat = GameState.available_seats.pop_at(0)
		go_to(seat)


# Called when customer reaches a chair
func seat_and_eat():
	
	head.texture = head_sprites[EAT]
	body.texture = body_sprites[1]
	timer.start(time_eating)
	timer_circle.show()
	await timer.timeout
	timer_circle.hide()
	
	done_eating = true
	done_signal.emit(seat)
	head.texture = head_sprites[DEFAULT]
	body.texture = body_sprites[0]
	go_to(Global.exit_loc)


func go_to(target_position: Vector2):
	path.clear()
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
			pass
			head.flip_h = false
			body.flip_h = false
		elif move_velocity.x < 0:
			head.flip_h = true
			body.flip_h = true
	if position == Global.exit_loc and order_done and done_eating:
		queue_free()


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

func show_order(show: bool):
	order_bubble.show_full(show)
