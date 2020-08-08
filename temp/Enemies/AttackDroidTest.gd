extends KinematicBody2D

export(int) var speed
export(int) var atk
export(float) var acceleration

var dir = -1
var gravity
var velocity = Vector2()
var initPos
var canMove = true

func _ready():
	initPos = position
	gravity = get_parent().Gravity

func applyGravity(delta):
	velocity.y += gravity

func movement():
	velocity.x = lerp(velocity.x, speed * dir, acceleration)

func pause():
	canMove = false
	$HitBox/CollisionShape2D.disabled = true

func resume():
	position = initPos
	$Position2D/TeleParticles.emitting = true
	$HitBox/CollisionShape2D.disabled = false
	$MotionTimer.start($Position2D/TeleParticles.lifetime)

func checkIfGrounded():
	if $Node2D/RayCast2D.is_colliding() == false:
		dir *= -1
		$Node2D/RayCast2D.position.x *= -1

func _physics_process(delta):
	if canMove:
		movement()
		applyGravity(delta)
		checkIfGrounded()
		velocity = move_and_slide(velocity, Vector2.UP)
	
	if is_on_wall():
		dir *= -1
		$Node2D/RayCast2D.position.x *= -1
	
	if dir == 1:
		$AnimatedSprite.flip_h = true
	else:
		$AnimatedSprite.flip_h = false

func _on_MotionTimer_timeout():
	canMove = true

func _on_HitBox_body_entered(body):
	if body.has_method("takeDamage"):
		body.takeDamage(atk)
