extends Control

@onready var rating = $MarginContainer/NinePatchRect/VBoxContainer/Rating
@onready var profit = $MarginContainer/NinePatchRect/VBoxContainer/HBoxContainer/Profit
@onready var customers = $MarginContainer/NinePatchRect/VBoxContainer/HBoxContainer2/Customers
@onready var plates = $MarginContainer/NinePatchRect/VBoxContainer/HBoxContainer3/Plates


func show_stats():
	profit.text = "₱ %01.2f" % GameState.profit
	customers.text = str(GameState.total_customers)
	plates.text = str(GameState.total_plates)

func _on_custom_button_pressed():
	pass # Scene change to new instance main
