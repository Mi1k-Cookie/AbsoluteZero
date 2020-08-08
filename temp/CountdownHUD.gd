extends Control

func _ready():
	$CanvasLayer/CountdownTimer.text = str(0)

func updateTime(time):
	$CanvasLayer/CountdownTimer.text = str(time)
