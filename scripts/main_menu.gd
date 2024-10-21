extends Control

@export var diff_buttons: ButtonGroup


func _on_custom_button_pressed() -> void:
	var selected = diff_buttons.get_pressed_button().name
	match selected:
		"Comfy":
			GameState.current_difficulty = Global.diff[0]
		"Normal":
			GameState.current_difficulty = Global.diff[1]
		"Hard":
			GameState.current_difficulty = Global.diff[2]
		_:
			print("Error button name does not match difficulty")
	get_tree().paused = false
	hide()
