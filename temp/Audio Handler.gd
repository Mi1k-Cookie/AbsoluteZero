extends Node2D

onready var bgm = $AudioStreamPlayer
onready var sfx = $PlayerSFX
onready var tsfx = $TurretSFX
onready var bsfx = $BulletSFX

func _ready():
	bgm.play()

func _on_AudioStreamPlayer_finished():
	bgm.play()

func pauseBGM():
	bgm.playing = false

func resumeBGM():
	bgm.playing = true

func setBGM(newVol):
	bgm.volume_db = newVol

func playSFX(_sfx, _position):
	sfx.position = _position
	sfx.stream = _sfx
	sfx.play()

func playTSFX(_sfx, _position):
	tsfx.position = _position
	tsfx.stream = sfx
	tsfx.play()

func playBSFX(_sfx, _position):
	bsfx.position = _position
	bsfx.stream = sfx
	bsfx.play()

func setSFX(newVol):
	sfx.volume_db = newVol
	tsfx.volume_db = newVol
	bsfx.volume_db = newVol

