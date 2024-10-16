extends Control

@onready var rating = $MarginContainer/NinePatchRect/VBoxContainer/Rating
@onready var profit = $MarginContainer/NinePatchRect/VBoxContainer/HBoxContainer/Profit
@onready var customers = $MarginContainer/NinePatchRect/VBoxContainer/HBoxContainer2/Customers
@onready var plates = $MarginContainer/NinePatchRect/VBoxContainer/HBoxContainer3/Plates


func show_stats():
	var recieved_rating
	if GameState.profit >= GameState.ideal_profit * 0.9:
		recieved_rating = "3 STARS!"
	elif GameState.profit >= GameState.ideal_profit * 0.5:
		recieved_rating = "2 stars!"
	else:
		recieved_rating = "1 star..."
	rating.text = recieved_rating
	profit.text = "₱ %01.2f" % GameState.profit
	customers.text = str(GameState.total_customers)
	plates.text = str(GameState.total_plates)

func _on_custom_button_pressed():
	pass # Scene change to new instance main
