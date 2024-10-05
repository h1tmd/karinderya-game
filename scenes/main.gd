extends Node2D

@export var customer: PackedScene

func _ready() -> void:
	for i in range(5):
		await get_tree().create_timer(10).timeout
		var cust := customer.instantiate()
		add_child(cust)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
