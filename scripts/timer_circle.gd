extends TextureProgressBar

@onready var timer: Timer = $"../Timer"

func _process(delta: float) -> void:
	if visible == true:
		value = (timer.wait_time - timer.time_left) / timer.wait_time * 100
