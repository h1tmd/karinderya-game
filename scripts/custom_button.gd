extends TextureButton

@onready var center_container: CenterContainer = $CenterContainer
@onready var label: Label = $CenterContainer/HBoxContainer/Label
@onready var texture_rect: TextureRect = $CenterContainer/HBoxContainer/TextureRect
@onready var sfx_click: AudioStreamPlayer = $"SFX Click"

@export var label_text: String = "Serve"
@export var icon: Texture2D
@export var use_default_sfx: bool = false

var is_toggled = false

func _ready() -> void:
	label.text = label_text
	if icon:
		texture_rect.texture = icon
	if button_pressed:
		move_down()


func _pressed() -> void:
	if use_default_sfx:
		sfx_click.play()


func _on_button_down() -> void:
	if is_toggled:
		move_up()
	else:
		move_down()

func _on_button_up() -> void:
	if is_toggled:
		move_down()
	else:
		move_up()

func _toggled(toggled_on: bool) -> void:
	is_toggled = toggled_on
	if not is_toggled:
		move_up()

func move_down():
	center_container.position.y = 20

func move_up():
	center_container.position.y = 0
