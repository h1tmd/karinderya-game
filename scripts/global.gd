extends Node

# List of Dishes available
var dishes = []
# A* for pathfinding
var astar = AStar2D.new()

const order_loc = Vector2(672, 481)
const exit_loc = Vector2(-89, 483)


func _ready() -> void:
	read_dishes()
	generate_astar()
	randomize()

func read_dishes():
	dishes.append(load("res://rice.tres"))
	var files = DirAccess.get_files_at("res://dishes/")
	for file in files:
		var dish_data : Dish = load("res://dishes/" + file)
		dishes.append(dish_data)

func generate_astar():
	var astar_points_container : Node2D = load("res://scenes/astar_points.tscn").instantiate()
	var all_points = astar_points_container.get_children()
	
	# Add points to AStar2D
	for point:AstarPoint in all_points:
		astar.add_point(point.get_index(), point.position)
		if point.is_chair:
			GameState.available_seats.append(point.position)
	
	# Connect all the AStar points to each other
	for point:AstarPoint in all_points:
		for connection in point.connections:
			astar.connect_points(point.get_index(), connection.get_index())
	
	astar.disconnect_points(1, 36, false)

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
