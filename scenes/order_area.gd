extends Area2D

func _on_body_entered(body):
	if body is Customer:
		Global.current_customer = body
