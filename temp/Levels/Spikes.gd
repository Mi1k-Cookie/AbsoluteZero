extends StaticBody2D

var player

func _on_Area2D_body_entered(body):
	print(body)
	if body.has_method("takeDamage"):
		player = body
		player.takeDamage(1)

func _on_Area2D_body_exited(body):
	if body.has_method("takeDamage"):
		player = null
