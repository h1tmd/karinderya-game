extends CharacterBody2D
class_name Customer

var speed = 300
var order = {}
var order_done = false

var astar = AStar2D.new()
var path = []

func _ready() -> void:
	generate_order()

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

#func _physics_process(delta):
# path
#func find_seat():
	
# timer
