extends Area2D

@onready var food_table: StaticBody2D = $"../FoodTable"

func _on_body_entered(body):
	if body is Customer:
		if not body.order_done:
			body.generate_order()
			Customer.current_customer = body
			food_table.connect("ui_visible", body.show_order)
			body.show_order(food_table.serve_ui.visible)
