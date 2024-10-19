extends PanelContainer

@onready var label: Label = $MarginContainer/Label
@export_multiline var hint_string: String = "" 

func _ready() -> void:
	if hint_string:
		label.text = hint_string

func set_hint(hint):
	hint_string = hint
