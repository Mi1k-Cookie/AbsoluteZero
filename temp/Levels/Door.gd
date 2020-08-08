extends StaticBody2D

var reversal = false
var collideState = true

func onButtonPush():
	$AnimatedSprite.play("openDoor", reversal)
	$CollisionShape2D.set_deferred("disabled", collideState)
	collideState = not collideState

func onButtonOff():
	$AnimatedSprite.play("openDoor", not reversal)
	$CollisionShape2D.set_deferred("disabled", collideState)
	collideState = not collideState

