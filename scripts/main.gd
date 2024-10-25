extends Node2D

@export var customer: PackedScene
@onready var game_timer: Timer = $"CanvasLayer/Game Timer"
@onready var end_screen = $"CanvasLayer/End Screen"
@onready var serve_canvas: CanvasLayer = $"Layout/FoodTable/CanvasLayer"
@onready var main_menu: Control = $"CanvasLayer/Main Menu"
@onready var pause_menu: Control = $"CanvasLayer/Pause Menu"
@onready var sfx_pause: AudioStreamPlayer = $"SFX Pause"

signal timeout_or_customer_served

func _ready() -> void:
	ServeUi.current_instance.connect("customer_served", on_timeout_or_customer_served.bind(true))
	if not Global.start_immediately:
		# Show menu
		get_tree().paused = true
		main_menu.show()
		await main_menu.hidden
	else:
		get_tree().paused = false
		Global.start_immediately = false
	Global.player.current_speed = GameState.current_difficulty["speed"]
	start()

func start():
	game_timer.start(GameState.current_difficulty["game_time"])
	while game_timer.time_left > 15:
		var current_time = (game_timer.wait_time - game_timer.time_left) / game_timer.wait_time
		var interval_arr = GameState.current_difficulty["cust_interval"]
		var customer_interval
		if current_time < 0.20:
			customer_interval = interval_arr[0]
		elif current_time < 0.40:
			customer_interval = interval_arr[1]
		elif current_time < 0.60:
			customer_interval = interval_arr[2]
		elif current_time < 0.80:
			customer_interval = interval_arr[3]
		else:
			customer_interval = interval_arr[4]
		var next_cutomer = get_tree().create_timer(customer_interval, false)
		next_cutomer.connect("timeout", on_timeout_or_customer_served.bind(false))
		await timeout_or_customer_served
		next_cutomer.disconnect("timeout", on_timeout_or_customer_served)
		GameState.total_customers += 1
		var cust := customer.instantiate()
		add_child(cust)
	await game_timer.timeout
	get_tree().paused = true
	if serve_canvas:
		serve_canvas.hide()
	end_screen.show_stats()
	end_screen.show()

func on_timeout_or_customer_served(is_customer_served: bool):
	if is_customer_served:
		if Customer.num_lined_up == 0:
			timeout_or_customer_served.emit()
	else:
		timeout_or_customer_served.emit()

func _on_pause_button_pressed() -> void:
	get_tree().paused = true
	sfx_pause.play()
	pause_menu.show()
