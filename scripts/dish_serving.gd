extends Sprite2D
class_name DishServing

@onready var area_2d: Area2D = $Area2D
var mouse_offset = Vector2.ZERO
var area_name = "Serving Area"
var mouse_over = false
var selected = true
var dish_data: Dish


func set_data(data: Dish):
	dish_data = data


func _ready():
	selected = true
	if dish_data:
		texture = dish_data.image
		if dish_data.name == "Rice":
			area_name = "Plate Area"


func _process(_delta):
	if selected:
		global_position = get_global_mouse_position() + mouse_offset


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
	mouse_over = true


func _on_area_2d_mouse_exited() -> void:
	mouse_over = false


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.name == area_name and selected:
		modulate.a = 1
		scale = Vector2(0.6, 0.6)


func _on_area_2d_area_exited(area: Area2D) -> void:
	if area.name == area_name and selected:
		modulate.a = 0.5
		scale = Vector2(0.5, 0.5)
