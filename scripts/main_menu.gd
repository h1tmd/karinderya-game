extends Control

func _on_custom_button_pressed() -> void:
	get_tree().paused = false
	hide()
