extends Node

# List of Dishes available
var dishes = []
# A* for pathfinding
var customer_astar: AStar2D
var player_astar: AStar2D
# End screen replay or main menu
var start_immediately = false
var player: Player = null
var seats = []

const order_loc = Vector2(672, 481)
const exit_loc = Vector2(-296, 483)
const diff = [
	{
		# Comfy
		"game_time": 360,
		"cust_interval": [20, 10, 10, 10, 10],
		"cust_timer": 0,
		"speed": 400,
		"plate_weight": 15,
		"wash_time": 0.6
	},
	{
		# Normal
		"game_time": 180,
		"cust_interval": [15, 9, 9, 8, 7],
		"cust_timer": 30,
		"speed": 450,
		"plate_weight": 20,
		"wash_time": 1.0
	},
	{
		# Challenge
		"game_time": 180,
		"cust_interval": [10, 9, 8, 7, 7],
		"cust_timer": 20,
		"speed": 650,
		"plate_weight": 35,
		"wash_time": 1.2
	}
]
const player_astar_points = preload("res://scenes/player_astar_points.tscn")
const customer_astar_points = preload("res://scenes/customer_astar_points.tscn")

func _ready() -> void:
	read_dishes()
	player_astar = generate_astar(player_astar_points.instantiate())
	customer_astar = generate_astar(customer_astar_points.instantiate())
	customer_astar.disconnect_points(1, 36, false)
	GameState.available_seats.assign(seats.duplicate(true))


func read_dishes():
	dishes.append(load("res://rice.tres"))
	var files = DirAccess.get_files_at("res://dishes/")
	for file in files:
		var dish_data : Dish = load("res://dishes/" + file)
		dishes.append(dish_data)

func generate_astar(astar_points_container: Node2D) -> AStar2D:
	#var astar_points_container : Node2D = load("res://scenes/customer_astar_points.tscn").instantiate()
	var all_points = astar_points_container.get_children()
	var astar: AStar2D = AStar2D.new()
	
	# Add points to AStar2D
	for point:AstarPoint in all_points:
		astar.add_point(point.get_index(), point.position)
		if point.is_chair:
			seats.append(point.position)
	
	# Connect all the AStar points to each other
	for point:AstarPoint in all_points:
		for connection in point.connections:
			astar.connect_points(point.get_index(), connection.get_index())
	return astar

# Return number 1-3 using weighted randomness 
func weighted_random() -> int:
	const weight1 = 0.7
	const weight2 = 0.9
	var rng = randf_range(0, 1)
	if rng < weight1:
		return 1
	elif rng < weight2:
		return 2
	else:
		return 3
