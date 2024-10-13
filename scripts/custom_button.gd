extends TextureButton

@onready var center_container: CenterContainer = $CenterContainer
@onready var label: Label = $CenterContainer/Label

@export var label_text: String = "Serve"

func _ready() -> void:
	label.text = label_text

func _on_button_down() -> void:
	center_container.position.y = 20

func _on_button_up() -> void:
	center_container.position.y = 0
