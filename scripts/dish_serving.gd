extends Sprite2D
class_name DishServing

@onready var area_2d: Area2D = $Area2D
var selected = true
var mouse_offset = Vector2.ZERO
var group_name

func _ready():
	var selected = true
	area_2d.add_to_group(group_name)

func _process(delta):
	if selected:
		global_position = get_global_mouse_position() + mouse_offset 

func set_area_group(name):
	self.group_name = name

func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.is_action_pressed("click"):
			mouse_offset = global_position - get_global_mouse_position()
			selected = true

func _input(event: InputEvent) -> void:
	if Input.is_action_just_released("click") and selected:
		selected = false
		var areas = area_2d.get_overlapping_areas()
		for area in areas:
			if area.name == "Serving Area":
				return
		queue_free()
