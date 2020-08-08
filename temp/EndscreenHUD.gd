extends Control

export(float, 0, 5) var onScreenTime = 3

signal reload
signal nextLevel

var levelComplete

func hideAllText():
	$CanvasLayer/GameOver.hide()
	$CanvasLayer/RewindCounter.hide()
	$CanvasLayer/TimeElapsed.hide()

func hideAllButtons():
	$CanvasLayer/Restart.hide()
	$CanvasLayer/NextLevel.hide()

func showAllText():
	$CanvasLayer/GameOver.show()
	$CanvasLayer/RewindCounter.show()
	$CanvasLayer/TimeElapsed.show()

func showRewindCounter(rewindCounts):
	$CanvasLayer/RewindCounter.text = str(rewindCounts)
	$CanvasLayer/RewindCounter.show()

func showAllButtons():
	$CanvasLayer/GameOver.hide()
	$CanvasLayer/Restart.show()
	if not levelComplete:
		$CanvasLayer/NextLevel.disabled = true
	$CanvasLayer/NextLevel.show()
	
func displayStats(text, timeElapsed):
	$CanvasLayer/GameOver.text = text
	$CanvasLayer/TimeElapsed.text = str(timeElapsed)
	showAllText()

func displayEndScreen(text, timeElapsed):
	$CanvasLayer/GameOver.text = text
	$CanvasLayer/TimeElapsed.text = str(timeElapsed)
	showAllText()
	$onScreenTime.start()

func _ready():
	$onScreenTime.wait_time = onScreenTime
	connect("reload", get_parent(), "onReload")
	connect("nextLevel", get_parent(), "onNextLevel")
	hideAllText()
	hideAllButtons()

func _on_Restart_pressed():
	emit_signal("reload")

func _on_NextLevel_pressed():
	if levelComplete:
		emit_signal("nextLevel")

func _on_onScreenTime_timeout():
	showAllButtons()
