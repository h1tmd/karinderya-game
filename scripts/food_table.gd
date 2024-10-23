extends StaticBody2D

@onready var serve_ui = $"CanvasLayer/Serve UI"
@onready var sprite_2d = $Sprite2D
@onready var sfx_open_menu: AudioStreamPlayer = $"SFX Open Menu"

signal ui_visible(is_visible: bool)
signal interacted

const SERVE_LOCATION = Vector2(848, 253) 
var can_interact = false


func _unhandled_input(event):
	if Input.is_action_just_pressed("click"):
		for i in range(2): await get_tree().physics_frame
		if can_interact:
			Global.player.go_to(SERVE_LOCATION)
			await Global.player.arrived
			if Global.player.position == SERVE_LOCATION:
				open_serve_ui()

func _on_area_2d_mouse_entered() -> void:
	can_interact = true
	sprite_2d.material.set_shader_parameter("line_thickness", 15)


func _on_area_2d_mouse_exited() -> void:
	can_interact = false
	sprite_2d.material.set_shader_parameter("line_thickness", 0)


func _on_order_area_body_entered(body: Node2D) -> void:
	if body is Customer:
		if not body.order_done:
			body.generate_order()
			Customer.current_customer = body
			connect("ui_visible", body.show_order)
			body.show_order(serve_ui.visible)


func _on_serve_ui_hidden() -> void:
	ui_visible.emit(false)


func open_serve_ui():
	serve_ui.show()
	interacted.emit()
	ui_visible.emit(serve_ui.visible)
	sfx_open_menu.play()
	serve_ui._on_dishes_node_child_order_changed()


func _on_serve_area_body_exited(body: Node2D) -> void:
	serve_ui.hide()
