extends Area2D

func _on_body_entered(body):
	if body is Customer:
		if not body.order_done:
			Global.current_customer = body
