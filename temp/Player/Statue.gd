extends KinematicBody2D

var gravity
var velocity = Vector2()
var flip
func _ready():
	$Sprite.flip_h = flip

func _physics_process(delta):
	velocity.y += gravity * delta
	velocity = move_and_slide(velocity)
