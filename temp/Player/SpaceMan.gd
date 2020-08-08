extends KinematicBody2D

export(int) var speed
export(int) var jumpForce
export(int) var maxHP
export(float) var invinciblity
export(Array, AudioStream) var sfx
export(PackedScene) var statue

const UP = Vector2(0, -1)

onready var animPlayer = $Body/AnimatedSprite
onready var textLabel = $Label
onready var speedTimer = $SpeedTimer
onready var sfxManager = get_node("/root/AudioHandler")

var rewindCount
var moveDir = 0
var HP

var isAlive = true
var isRewinding = false
var canRecord = false
var sigEmiited = false

var levelGravity
var levelAcceleration
var velocity = Vector2()

var statueDropped = false
var isRecording = false

var dirList = []
var posList = []
var animList = []

var currentAnim = "default"

signal dropStatue
signal explode
signal rewindStarted
signal rewindStopped
signal pauseOthers
signal resumeOthers
signal anchorPlaced
signal anchorHide

func updateHPBar(value):
	if value > 0:
		var HPBAR2 = $Control/Over
		var HPBAR = $Control/Under
		$Control/Tween.interpolate_property(HPBAR2, "value", HPBAR2.value, value, 0.4, Tween.TRANS_SINE)
		$Control/Tween.start()
	else:
		$Control.hide()

func _handleMovement():
	moveDir = -int(Input.is_action_pressed("ui_left")) + int(Input.is_action_pressed("ui_right"))
	velocity.x = lerp(velocity.x, speed * moveDir, levelAcceleration)
	if moveDir != 0:
		$Body.scale.x = moveDir

func _rewind():
	if posList.size() > 0:
		if !statueDropped:
			emit_signal("dropStatue", statue, global_position, $Body.scale.x)
			emit_signal("rewindStarted", rewindCount)
			emit_signal("pauseOthers")
			statueDropped = true
		position = posList[0]
		posList.remove(0)
		if dirList.size() > 0:
			if int(dirList[0]) != 0:
				$Body.scale.x = dirList[0]
			dirList.remove(0)
		$Body/AnimatedSprite.play(animList[0], true)
		animList.remove(0)
	else:
		speedTimer.stop()
		canRecord = false
		emit_signal("anchorHide")
		emit_signal("rewindStopped")
		emit_signal("resumeOthers")
		statueDropped = false
		isRewinding = false
		isRecording = false

func _onWin():
	$SpeedTimer.stop()

func _onDeath():
	isAlive = false
	sfxManager.playSFX(sfx[3], global_position)
	emit_signal("explode", position)
	queue_free()


func _applyMovement():
	velocity = move_and_slide(velocity, Vector2.UP)

func _applyGravity(delta):
	velocity.y += delta * levelGravity

func _jump():
	sfxManager.playSFX(sfx[0], global_position)
	velocity.y -= jumpForce
	_applyMovement()

func _record():
	posList.insert(0, position)
	dirList.insert(0, moveDir)
	animList.insert(0, currentAnim)
	canRecord = false

func takeDamage(damage):
	if $Invincibility.is_stopped():
		HP -= damage
		updateHPBar(HP)
		sfxManager.playSFX(sfx[1], global_position)
		$Invincibility.start(invinciblity)
		if HP <= 0:
			_onDeath()

func connectToEnemies():
	var list = get_parent().get_children()
	for child in list:
		if "Attack" in child.name:
			connect("pauseOthers", child, "pause")
			connect("resumeOthers", child, "resume")

func _ready():
	levelGravity = get_parent().Gravity
	levelAcceleration = get_parent().acceleration
	rewindCount = get_parent().rewindCounter
	connectToEnemies()
	connect("dropStatue", get_parent(), "onDrop")
	connect("explode", get_parent(), "onParticles")
	connect("rewindStarted", get_parent(), "_stopAndResetTimers")
	connect("rewindStopped", get_parent(), "_startUpTimers")
	connect("anchorPlaced", get_parent(), "onAnchorPlaced")
	connect("anchorHide", get_parent(), "onAnchorHide")
	HP = maxHP
	updateHPBar(HP)
	
func _on_SpeedTimer_timeout():
	canRecord = true

