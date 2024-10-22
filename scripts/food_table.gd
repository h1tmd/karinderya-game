extends StaticBody2D

@onready var serve_ui = $"CanvasLayer/Serve UI"
@onready var sprite_2d = $Sprite2D
@onready var sfx_open_menu: AudioStreamPlayer = $"SFX Open Menu"

signal ui_visible(is_visible: bool)
signal interacted

const SERVE_LOCATION = Vector2(848, 253) 
var can_interact = false

func _on_area_2d_area_entered(area):
	if area.name == "InteractReach":
		sprite_2d.material.set_shader_parameter("line_thickness", 15)
		can_interact = true

func _on_area_2d_area_exited(area: Area2D):
	if area.name == "InteractReach":
		sprite_2d.material.set_shader_parameter("line_thickness", 0)
		can_interact = false
		serve_ui.hide()
		ui_visible.emit(false)

func _unhandled_input(event):
	if Input.is_action_just_pressed("interact") and can_interact:
		serve_ui.visible = not serve_ui.visible
		interacted.emit()
		ui_visible.emit(serve_ui.visible)
		sfx_open_menu.play()
		serve_ui._on_dishes_node_child_order_changed()
	if Input.is_action_just_pressed("click") and can_interact:
		Global.player.go_to(SERVE_LOCATION)
		await Global.player.arrived
		if Global.player.position == SERVE_LOCATION:
			serve_ui.show()
			interacted.emit()
			ui_visible.emit(serve_ui.visible)
			sfx_open_menu.play()
			serve_ui._on_dishes_node_child_order_changed()

func _on_area_2d_mouse_entered() -> void:
	can_interact = true
	sprite_2d.material.set_shader_parameter("line_thickness", 15)


func _on_area_2d_mouse_exited() -> void:
	can_interact = false
	sprite_2d.material.set_shader_parameter("line_thickness", 0)
