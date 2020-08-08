extends KinematicBody2D

export(int) var speed
export(bool) var canFall
export(int) var atk

const FLOOR = Vector2(0, -1)
var velocity = Vector2()

var dir = -1

var canMove = true
var canRecord = true
var isRewinding = false
var shapesSet = false

var posList = []
var dirList = []

func _ready():
	$SpeedTimer.start(0.032)

func movement():
	velocity = Vector2(speed, 0) * dir

func _on_HitBox_body_entered(body):
	if body.name == "Spaceman":
		print(body.name, " took 1 dmg")
		body.takeDamage(atk)

func applyGravity(delta):
	velocity.y += get_parent().Gravity

func checkIfGrounded():
	if $Node2D/RayCast2D.is_colliding() == false:
		dir *= -1
		$Node2D/RayCast2D.position.x *= -1

func record():
	posList.insert(0, position)
	dirList.insert(0, dir)
	canRecord = false

func rewind():
	if posList.size() > 0:
		isRewinding = true
		canMove = false
		position = posList[0]
		dir = dirList[0]
		posList.remove(0)
		dirList.remove(0)
		$AnimatedSprite.play("default", true)
	else:
		$CollisionShape2D.disabled = false
		$HitBox/CollisionShape2D.disabled = false
		shapesSet = false
		isRewinding = false
		canRecord = true
		canMove = true
		$AnimatedSprite.play("default")
		
func _physics_process(delta):
	if canMove:
		movement()
		applyGravity(delta)
		if !canFall:
			checkIfGrounded()
		velocity = move_and_slide(velocity, Vector2.UP)
		if is_on_wall():
			dir *= -1
			$Node2D/RayCast2D.position.x *= -1
	
	if canRecord:
		record()
	if dir == 1:
		$AnimatedSprite.flip_h = true
	else:
		$AnimatedSprite.flip_h = false
	
	if isRewinding:
		if !shapesSet:
			canRecord = false
			$CollisionShape2D.disabled = true
			$HitBox/CollisionShape2D.disabled = true
			shapesSet = true
		rewind()
	
func _on_SpeedTimer_timeout():
	canRecord = true
