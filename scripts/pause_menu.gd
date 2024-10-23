extends Control

func _on_resume_pressed() -> void:
	get_tree().paused = false
	hide()


func _on_main_menu_pressed() -> void:
	get_tree().reload_current_scene()
	Global.start_immediately = false
