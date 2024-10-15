extends MarginContainer

@onready var plate_number: Label = $"HBoxContainer/Plate Number"
@onready var total_money: Label = $"HBoxContainer/Total Money"

func _ready() -> void:
	update()
	GameState.ui_node = self


func update():
	total_money.text = "%01.2f" % GameState.profit
	plate_number.text = str(GameState.total_plates)


func change_plates_text_color(change: bool):
	if change:
		plate_number.label_settings.font_color = Color(0.959, 0.361, 0.361)
	else:
		plate_number.label_settings.font_color = Color(1, 1, 1)
