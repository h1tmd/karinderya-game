extends Sprite2D
class_name DishServing

@onready var area_2d: Area2D = $Area2D
var selected = true
var mouse_offset = Vector2.ZERO
var group_name = ""
var mouse_over = false

func set_area_group(name):
	self.group_name = name

func _ready():
	selected = true
	if not group_name.is_empty():
		area_2d.add_to_group(group_name)

func _process(delta):
	if selected:
		global_position = get_global_mouse_position() + mouse_offset 


func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("click") and mouse_over:
		if Global.currently_selected == null:
			Global.currently_selected = self
			mouse_offset = global_position - get_global_mouse_position()
			selected = true
			get_parent().move_child(self, -1)

func _input(event: InputEvent) -> void:
	if Input.is_action_just_released("click") and selected:
		Global.currently_selected = null
		selected = false
		var areas = area_2d.get_overlapping_areas()
		for area in areas:
			if area.name == "Serving Area":
				return
		queue_free()

func _on_area_2d_mouse_entered() -> void:
	mouse_over = true

func _on_area_2d_mouse_exited() -> void:
	mouse_over = false


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.name == "Serving Area" and selected:
		modulate.a = 1
		scale = Vector2(0.6, 0.6)

func _on_area_2d_area_exited(area: Area2D) -> void:
	if area.name == "Serving Area" and selected:
		modulate.a = 0.5
		scale = Vector2(0.5, 0.5)
