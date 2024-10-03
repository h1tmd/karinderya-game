extends CharacterBody2D

var order = {}

# place/generate order
func generate_order():
	var choices = []
	var dir = DirAccess.open("res://dishes/")
	if dir:
		dir.list_dir_begin()
		var file = dir.get_next()
		while file != "":
			var dish_data : Dish = load("res://dishes/" + file)
			choices.append(dish_data.name)
			file = dir.get_next()
	else:
		print("Error in opening path")
	
	randomize()
	var meal = choices.pick_random()
	var rice = randi_range(1, 3)
	order = {meal: 1, "Rice": rice}
	# random meal and random number of rice


# receive order
# path
# timer
