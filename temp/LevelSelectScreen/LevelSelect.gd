extends Control

export(PackedScene) var levelIcon
export(Array, String) var levelScenes

onready var persistence = get_node("/root/SavePlayerData")
onready var music = get_node("/root/AudioHandler")

var completedLevels = []

func _createButton(level, _position, text, path, levelsDone):
	level.levelPath = path
	level.rect_global_position = _position
	level.buttonText = str(text)
	if text >= levelsDone +1:
		level.disabled = true
	return level

func _getAvailableLevels():
	completedLevels = persistence.loadSave()
	
func _ready():
	var currentPos = Vector2(32, 32)
	var index = 0
	var size
	_getAvailableLevels()
	for i in levelScenes:
		var level = levelIcon.instance()
		if completedLevels != null:
			size = completedLevels.size()
		else:
			size = 0
		level = _createButton(level, currentPos, index, i, size)
		if (level.rect_position.x + level.rect_size.x) < (1024 - level.rect_size.x):
			currentPos  = Vector2(currentPos.x + 64, currentPos.y)
		elif level.rect_position.x + level.rect_size.x >= (1024 - level.rect_size.x):
			currentPos = Vector2(32, currentPos.y + 96)
		index += 1
		add_child(level)


func _on_HSlider_value_changed(value):
	music.setBGM(value)

func _on_HSlider2_value_changed(value):
	music.setSFX(value)
