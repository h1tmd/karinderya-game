extends Node2D

@export var customer: PackedScene
@onready var game_timer: Timer = $"CanvasLayer/Game Timer"
@onready var end_screen = $"CanvasLayer/End Screen"
@onready var serve_canvas: CanvasLayer = $"Layout/FoodTable/CanvasLayer"


func _ready() -> void:
	get_tree().paused = false
	if GameState.profit != 0:
		GameState.reset()

	while game_timer.time_left > 15:
		var current_time = (game_timer.wait_time - game_timer.time_left) / game_timer.wait_time
		var customer_interval
		if current_time < 0.20:
			customer_interval = 15
		elif current_time < 0.40:
			customer_interval = 10
		elif current_time < 0.60:
			customer_interval = 9
		elif current_time < 0.80:
			customer_interval = 8
		else:
			customer_interval = 7
		await get_tree().create_timer(customer_interval).timeout
		GameState.total_customers += 1
		var cust := customer.instantiate()
		add_child(cust)
	get_tree().paused = true
	if serve_canvas:
		serve_canvas.hide()
	end_screen.show_stats()
	end_screen.show()
