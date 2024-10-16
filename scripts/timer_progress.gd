extends TextureProgressBar

@onready var game_timer: Timer = $"../Game Timer"

func _process(delta: float) -> void:
	value = (game_timer.wait_time - game_timer.time_left) / game_timer.wait_time * 100
