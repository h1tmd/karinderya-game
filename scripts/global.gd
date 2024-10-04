extends Node

# List of Dishes available
var dishes = []
# Current customer being served
var current_customer
# A* for pathfinding
var astar = AStar2D.new()


func _ready() -> void:
	read_dishes()
	generate_astar()

func read_dishes():
	var dir = DirAccess.open("res://dishes/")
	if dir:
		dir.list_dir_begin()
		var file = dir.get_next()
		while file != "":
			var dish_data : Dish = load("res://dishes/" + file)
			dishes.append(dish_data)
			file = dir.get_next()
	else:
		print("Error in opening path")

func generate_astar():
	var astar_points_container : Node2D = load("res://scenes/astar_points.tscn").instantiate()
	var all_points = astar_points_container.get_children()
	
	# Add points to AStar2D
	for point:AstarPoint in all_points:
		astar.add_point(point.get_index(), point.position)
	
	# Connect all the AStar points to each other
	for point:AstarPoint in all_points:
		for connection in point.connections:
			astar.connect_points(point.get_index(), connection.get_index())
