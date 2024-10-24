extends Node2D
class_name DishDraggable

@onready var sfx_place: AudioStreamPlayer = $"SFX Place"
@onready var sfx_rice: AudioStreamPlayer = $"SFX Rice"
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var area_2d: Area2D = $Area2D

signal dropped

static var currently_selected: DishDraggable = null
var mouse_offset = Vector2.ZERO
var area_name = "Serving Area"
var selectable = false
var selected = false
var on_area = false
var dish_data: Dish

const RED = Color(0.93, 0.32, 0.32, 0.918)
const YELLOW = Color(1, 0.982, 0.555, 0.918)


func set_data(data: Dish):
	dish_data = data


func _ready():
	if dish_data:
		sprite_2d.texture = dish_data.image
		if dish_data.name == "Rice":
			area_name = "Plate Area"
	selected = true
	currently_selected = self
	global_position = get_global_mouse_position()
	shrink_effect(true)
	show_highlight()


func _process(delta):
	if sprite_2d.is_pixel_opaque(sprite_2d.get_local_mouse_position()):
		if currently_selected == null:
			show_highlight()
			selectable = true
			currently_selected = self
	elif currently_selected == self and not selected:
		currently_selected = null
		hide_highlight()
		selectable = false
	if selected:
		global_position = lerp(
			global_position,
			get_global_mouse_position() + mouse_offset,
			delta / 0.05
		)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("click"):
		for i in range(2): await get_tree().physics_frame
		if selectable:
			selected = true
			get_parent().move_child(self, -1)
			mouse_offset = global_position - get_global_mouse_position()
	elif event.is_action_released("click"): 
		for i in range(2): await get_tree().physics_frame
		if selected:
			selected = false
			#selectable = false
			#hide_highlight()
			#currently_selected = null
			if on_area:
				if dish_data.name == "Rice":
					sfx_rice.play()
				else:
					sfx_place.play()
				return
			dropped.emit()
			queue_free()


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.name == area_name and selected:
		on_area = true
		shrink_effect(false)


func _on_area_2d_area_exited(area: Area2D) -> void:
	if area.name == area_name and selected:
		on_area = false
		shrink_effect(true)


func show_highlight():
	sprite_2d.material.set_shader_parameter("line_thickness", 15)


func hide_highlight():
	sprite_2d.material.set_shader_parameter("line_thickness", 0)


func shrink_effect(value: bool):
	if value:
		sprite_2d.scale = Vector2(0.5, 0.5)
		sprite_2d.material.set_shader_parameter("line_color", RED)
	else:
		sprite_2d.scale = Vector2(0.6, 0.6)
		sprite_2d.material.set_shader_parameter("line_color", YELLOW)
