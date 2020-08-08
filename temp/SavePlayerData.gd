extends Node2D

var saveData = File.new()
var savePath = "user://spaceman.json"
var saveState = []
var saveDict = {"levels": []}

func _ready():
	if not saveData.file_exists(savePath):
		createSave()

func createSave():
	saveData.open(savePath, File.WRITE)
	saveData.store_var(saveState)
	saveData.close()

func loadSave():
	saveData.open(savePath, File.READ)
	var tmpData = saveData.get_as_text()
	saveData.close()
	if tmpData != null:
		print("TEMP DATA", tmpData)
		saveDict = parse_json(tmpData)
		if saveDict != null:
			saveState = saveDict["levels"]
			return saveState
		else:
			return []
	else:
		return []

func loadHighScore(level):
	saveData.open(savePath, File.READ)
	var tmpData = saveData.get_as_text()
	saveData.close()
	saveDict = parse_json(tmpData)
	if saveDict != null:
		saveState = saveDict["levels"]
		if saveState.size() > level:
			return saveState[level]
		else:
			return 999
	else:
		return 999

func save(level, fastestTime):
	if saveState.size() <= level:
		saveState.insert(level, fastestTime)
	else:
		saveState[level] = fastestTime
	saveDict = {"levels": saveState}
	saveData.open(savePath, File.WRITE)
	saveData.store_line(to_json(saveDict))
	saveData.close()

func fileExists():
	if saveData.file_exists(savePath):
		return true
	else:
		return false
