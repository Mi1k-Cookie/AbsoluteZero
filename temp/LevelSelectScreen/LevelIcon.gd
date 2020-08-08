extends Button

export(String) var levelPath
var buttonText


func _on_level_pressed():
	get_tree().change_scene(levelPath)

func _ready():
	text  = buttonText
