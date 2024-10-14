extends Node2D

@export var customer: PackedScene
@onready var timer: Timer = $CanvasLayer/Timer

func _ready() -> void:
	while timer.time_left != 0:
		var game_time = (timer.wait_time - timer.time_left) / timer.wait_time
		var customer_interval
		if game_time < 0.30:
			customer_interval = 8
		elif game_time < 0.60:
			customer_interval = 10
		elif game_time < 0.80:
			customer_interval = 12
		else:
			customer_interval = 16
		await get_tree().create_timer(customer_interval).timeout
		var cust := customer.instantiate()
		add_child(cust)
