extends Node2D

export(int) var Gravity
export(float, 0, 1) var friction
export(float, 0, 1) var acceleration
export(int) var rewindCounter
export(int) var levelNumber

onready var endgameHUD = $Control
onready var countdownHUD = $Control2
onready var player = $Spaceman
onready var deathFX = $Particles2D
onready var savingScript = get_node("/root/SavePlayerData")

var sceneName = "Level"
var initialRewind
var seconds = 0
var fastestTime = 0
var levelComplete = false

signal timeStart
signal won

func loadNextLevel():
	get_tree().change_scene("res://Levels/"+sceneName+str(levelNumber+1)+".tscn")

func reloadLevel():
	get_tree().reload_current_scene()

func onReload():
	reloadLevel()

func onNextLevel():
	loadNextLevel()

func onShoot(bullet, _position, _dir):
	var b = bullet.instance()
	b.start(_position, _dir)
	add_child(b)

func onParticles(position):
	deathFX.position = position
	deathFX.emitting = true
	$Seconds.stop()
	endgameHUD.displayEndScreen("Game Over!", seconds)

func _ready():
	$Start.start()
	$Position2D/TeleParticles.emitting = true
	countdownHUD.updateTime(seconds)
	endgameHUD.showRewindCounter(rewindCounter)
	connect("timeStart", player, "_onLevelTimeStart")
	connect("won", player, "_onWin")
	if savingScript.fileExists():
		if levelNumber < savingScript.loadSave().size():
			endgameHUD.levelComplete = true
		fastestTime = savingScript.loadHighScore(levelNumber)
		print("Level", levelNumber, fastestTime)
	else:
		fastestTime = 0

func onDrop(corpse, _position, flip):
	var c = corpse.instance()
	c.flip = flip
	c.position = _position
	c.gravity = Gravity
	call_deferred("add_child", c)

func onAnchorPlaced(currentPos):
	$Anchor.position = currentPos
	$Anchor.emitting = true

func onAnchorHide():
	$Anchor.emitting = false

func _stopAndResetTimers(rewindCount):
	if rewindCount > 0:
		$Seconds.stop()
	endgameHUD.showRewindCounter(rewindCount)

func _resetTimer(rewindCount):
	$Seconds.stop()
	$Seconds.start()
	countdownHUD.updateTime(seconds)
	endgameHUD.showRewindCounter(rewindCount)


func onTriggerTriggered():
	if !levelComplete:
		print("Won")
		emit_signal("won")
		$Trigger/Position2D2/TeleParticles.emitting = true
		player.queue_free()
		$LevelTransitionDelay.start(3)
		$Seconds.queue_free()
		endgameHUD.displayStats("Level Complete", seconds)
		if seconds < fastestTime:
			savingScript.save(levelNumber, seconds)
		else:
			savingScript.save(levelNumber, fastestTime)
		levelComplete = true

func _startUpTimers():
	$Seconds.start()

func _physics_process(delta):
	if is_instance_valid(player):
		$Camera2D2.position = player.position


func _on_Seconds_timeout():
	countdownHUD.updateTime(seconds)
	seconds += 0.1


func _on_Start_timeout():
	$Seconds.start()


func _on_LevelTransitionDelay_timeout():
	loadNextLevel()
