extends Sprite2D
class_name DishServing

@onready var area_2d: Area2D = $Area2D
@onready var collision_shape_2d: CollisionShape2D = $Area2D/CollisionShape2D
@onready var rice_collision: CollisionShape2D = $"Area2D/Rice Collision"

var mouse_offset = Vector2.ZERO
var area_name = "Serving Area"
var mouse_over = false
var selected = true
var dish_data: Dish

const red_color = Color(0.93, 0.32, 0.32, 0.918)
const yellow_color = Color(1, 0.982, 0.555, 0.918)


func set_data(data: Dish):
	dish_data = data


func _ready():
	if dish_data:
		texture = dish_data.image
		if dish_data.name == "Rice":
			area_name = "Plate Area"
			collision_shape_2d.disabled = true
			rice_collision.disabled = false
	selected = true
	Global.currently_selected = self
	scale = Vector2(0.5, 0.5)
	material.set_shader_parameter("line_color", red_color)
	material.set_shader_parameter("line_thickness", 15)


func _process(delta):
	if selected:
		global_position = lerp(
			global_position, 
			get_global_mouse_position() + mouse_offset, 
			delta / 0.1
		)

func _unhandled_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("click") and mouse_over:
		if Global.currently_selected == null:
			Global.currently_selected = self
			mouse_offset = global_position - get_global_mouse_position()
			selected = true
			get_parent().move_child(self, -1)


func _input(_event: InputEvent) -> void:
	if Input.is_action_just_released("click") and selected:
		Global.currently_selected = null
		selected = false
		var areas = area_2d.get_overlapping_areas()
		for area in areas:
			if area.name == area_name:
				return
		queue_free()


func _on_area_2d_mouse_entered() -> void:
	if Global.currently_selected == null:
		mouse_over = true
		material.set_shader_parameter("line_thickness", 15)


func _on_area_2d_mouse_exited() -> void:
	mouse_over = false
	if not selected:
		material.set_shader_parameter("line_thickness", 0)


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.name == area_name and selected:
		scale = Vector2(0.6, 0.6)
		material.set_shader_parameter("line_color", yellow_color)


func _on_area_2d_area_exited(area: Area2D) -> void:
	if area.name == area_name and selected:
		scale = Vector2(0.5, 0.5)
		material.set_shader_parameter("line_color", red_color)
