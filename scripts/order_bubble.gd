extends PanelContainer

@onready var label: Label = $MarginContainer/Label
var order_string: String = "" 
const full_size = Vector2(500,185)
const mini_size = Vector2(423, 217)

func set_order(order):
	order_string = order
	if not order_string.is_empty():
		label.text = order_string

func show_full(show):
	if show:
		scale = Vector2.ONE
		custom_minimum_size = full_size
		label.text = order_string
	else:
		scale = Vector2(0.7, 0.7)
		custom_minimum_size = mini_size
		label.text = "      ..."
