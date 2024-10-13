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
var _total_plates: int = 36
var total_plates: int:
	get:
		return _total_plates
	set(value):
		_total_plates = value
		update_ui()

# Seats that customers can go
var available_seats: Array[Vector2] = []

var ui_node: Control = null

func update_ui():
	if ui_node:
		ui_node.update()
