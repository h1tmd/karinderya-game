extends Control

@onready var star_container: HBoxContainer = %"Star Container"
@onready var profit: Label = %Profit
@onready var highscore: Label = %Highscore
@onready var customers: Label = %Customers
@onready var plates: Label = %Plates
const STAR = preload("res://scenes/star.tscn")
var highscores: HighScore

func _ready() -> void:
	highscores = HighScore.load()

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
	var current_highscore = 0.0
	if GameState.current_difficulty == Global.diff[0]:
		highscore.get_parent().hide()
	elif GameState.current_difficulty == Global.diff[1]:
		if GameState.profit > highscores.normal_highscore:
			highscores.normal_highscore = GameState.profit
		current_highscore = highscores.normal_highscore
	elif GameState.current_difficulty == Global.diff[2]:
		if GameState.profit > highscores.normal_highscore:
			highscores.hard_highscore = GameState.profit
		current_highscore = highscores.hard_highscore
	highscores.save()
	if current_highscore == GameState.profit:
		highscore.label_settings.font_color = Color.WEB_GREEN
	highscore.text = "₱ %01.2f" % current_highscore
	
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
