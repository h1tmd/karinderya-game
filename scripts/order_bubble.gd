extends PanelContainer

@onready var label: Label = $MarginContainer/Label
var order_string: String = "" 

func set_order(order):
	order_string = order
	if not order_string.is_empty():
		label.text = order_string
	else:
		label.text = "..."
