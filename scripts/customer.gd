extends CharacterBody2D
class_name Customer

@onready var person_radar: Area2D = $"Person Radar"

var speed = 250
var order = {}
var path = []
var seat = Vector2.ZERO
var order_done = false
var done_eating = false
var person_in_front = false

func _ready() -> void:
	generate_order()
	position = Global.exit_loc
	go_to(Global.order_loc)

# place/generate order
func generate_order():
	# Generate randomly
	randomize()
	var meal : Dish = Global.dishes.pick_random()
	var rice = randi_range(1, 3)
	order = {meal.name: 1, "Rice": rice}
	
	# Convert to a string
	var order_str = ""
	for i in order:
		order_str += "%s: %s\n" % [i, order[i]]
	print(order_str)


# receive order
func receive_order(order_received: Dictionary):
	var mistakes = 0
	
	if order == order_received:
		print(":))")
		return
	else:
		for key in order:
			if key in order_received:
				# incorrect amount
				if not order_received[key] >= order[key]:
					mistakes += 1
			else:
				# ordered dish is missing
				mistakes += 1
		for key in order_received:
			if key not in order:
				# extra dish not ordered
				mistakes += 1

	match mistakes:
		1:
			print(":)")
		2:
			print(":(")
		_:
			print(">:(")
	order_done = true
	
	if Global.available_seats[0]:
		seat = Global.available_seats.pop_at(0)
		go_to(seat)
	
	# *eating*
	await get_tree().create_timer(10).timeout
	done_eating = true
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


func _on_person_radar_body_entered(body: Node2D) -> void:
	person_in_front = check_front()

func _on_person_radar_body_exited(body: Node2D) -> void:
	person_in_front = check_front()

func check_front():
	var bodies = person_radar.get_overlapping_bodies()
	for body in bodies:
		# Stop if person in front is a customer that has not yet ordered
		if not done_eating and body is Customer:
			if not body.order_done:
				return true
		if body is Player:
			return true
	return false
