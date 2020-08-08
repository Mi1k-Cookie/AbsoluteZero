extends StaticBody2D

export(float) var cooldown
export(PackedScene) var bullet
export(bool) var flip
export(AudioStream) var sfx

onready var sfxManager = get_node("/root/AudioHandler")

var canShoot = true
var notPaused = true
signal shoot

func shoot():
	sfxManager.playTSFX(sfx, $Position2D.global_position)
	var dir = Vector2(1, 0).rotated($Position2D.global_rotation)
	emit_signal("shoot", bullet, $Position2D.global_position, -dir)
	canShoot = false
	$Cooldown.start(cooldown)

func pause():
	notPaused = false

func resume():
	notPaused = true

func _ready():
	connect("shoot", get_parent(), "onShoot")
	if flip:
		scale.x *= -1

func _physics_process(delta):
	if notPaused:
		if canShoot:
			shoot()

func _on_Cooldown_timeout():
	canShoot = true
