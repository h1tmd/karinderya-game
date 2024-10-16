extends Node2D

@export var customer: PackedScene
@onready var timer: Timer = $CanvasLayer/Timer
@onready var end_screen = $"CanvasLayer/End Screen"


func _ready() -> void:
	while timer.time_left != 0:
		var game_time = (timer.wait_time - timer.time_left) / timer.wait_time
		var customer_interval
		if game_time < 0.20:
			customer_interval = 15
		elif game_time < 0.40:
			customer_interval = 10
		elif game_time < 0.60:
			customer_interval = 9
		elif game_time < 0.80:
			customer_interval = 8
		else:
			customer_interval = 7
		await get_tree().create_timer(customer_interval).timeout
		GameState.total_customers += 1
		var cust := customer.instantiate()
		add_child(cust)
	get_tree().paused = true
	end_screen.show_stats()
	end_screen.show()
