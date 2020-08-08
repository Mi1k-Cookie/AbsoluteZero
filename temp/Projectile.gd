extends Area2D

export(int) var speed
export(int) var damage
export(float) var timer
export(AudioStream) var sfx

onready var sfxManager = get_node("/root/AudioHandler")


var velocity = Vector2()

func start(_position, _direction):
	position = _position
	rotation = _direction.angle()
	velocity = _direction * speed

func _process(delta):
	position += velocity * delta

func _ready():
	pass

func explode():
	sfxManager.playSFX(sfx, global_position)
	queue_free()

func _on_Lifetime_timeout():
	explode()


func _on_Bullet_body_entered(body):
	if body.name == "Spaceman":
		body.takeDamage(damage)
		
	if not "Attack" in body.name:
		explode()
