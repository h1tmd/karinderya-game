extends Control

@onready var star_container: HBoxContainer = %"Star Container"
@onready var profit = $MarginContainer/NinePatchRect/VBoxContainer/HBoxContainer/Profit
@onready var customers = $MarginContainer/NinePatchRect/VBoxContainer/HBoxContainer2/Customers
@onready var plates = $MarginContainer/NinePatchRect/VBoxContainer/HBoxContainer3/Plates
const STAR = preload("res://scenes/star.tscn")

func show_stats():
	var stars
	if GameState.profit == GameState.ideal_profit:
		stars = 5
	elif GameState.profit >= GameState.ideal_profit * 0.95:
		stars = 4
	elif GameState.profit >= GameState.ideal_profit * 0.80:
		stars = 3
	elif GameState.profit >= GameState.ideal_profit * 0.70:
		stars = 2
	else:
		stars = 1
	for i in range(stars):
		star_container.add_child(STAR.instantiate())
	
	profit.text = "₱ %01.2f" % GameState.profit
	customers.text = str(GameState.total_customers)
	plates.text = str(GameState.total_plates)

func _on_custom_button_pressed():
	# insert transition
	get_tree().reload_current_scene()
	Global.start_immediately = true
	GameState.reset()


func _on_main_menu_pressed() -> void:
	get_tree().reload_current_scene()
	Global.start_immediately = false
	GameState.reset()
