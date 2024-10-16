extends Node

# Total money earned
var _profit: float = 0.0
var profit: float:
	get:
		return _profit
	set(value):
		_profit = value
		update_ui()

# Number of plates available
var _available_plates: int = 36
var available_plates: int:
	get:
		return _available_plates
	set(value):
		if value < _available_plates:
			total_plates += _available_plates - value
		_available_plates = value
		update_ui()

# Seats that customers can go
var available_seats: Array[Vector2] = []

# Stat vars
var total_plates: int = 0
var total_customers: int = 0
var ideal_profit: float = 0.0

var ui_node: Control = null

func update_ui():
	if ui_node:
		ui_node.update()

func reset():
	profit = 0.0
	available_plates = 36
	total_plates = 0
	total_customers = 0
	ideal_profit = 0.0
	available_seats = []
	Global.generate_astar()
