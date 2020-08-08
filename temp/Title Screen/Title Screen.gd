extends Node2D

onready var persistence = get_node("/root/SavePlayerData")
var levelsCompleted = 0

func loadSaves():
	if persistence.fileExists():
		levelsCompleted = persistence.loadSave().size()
		print(levelsCompleted)

func _ready():
	loadSaves()

func _on_TextureButton_pressed():
	if levelsCompleted <= 0:
		get_tree().change_scene("res://Levels/Level0.tscn")
	else:
		get_tree().change_scene("res://LevelSelectScreen/LevelSelect.tscn")
