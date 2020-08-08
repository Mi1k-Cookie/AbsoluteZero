extends Node2D

export(float) var onScreenTime

var hideMessages = false
var i = 0
var messagesRead = false

var messages = [
	"Welcome aboard the absolute zero space vessel",
	"I understand that you may be a bit disorriented at the moment.",
	"Take a second to move about.",
	"Use WASD to move.",
	"Got moving aboard the vessel, down? Good...",
	"Here on the Absolute Zero, we have been experimenting with time travel...",
	"and wish for you to test this technology.",
	"Press R to place an anchor in time to which you will rewind to.",
	"Press R again to rewind to that point.",
	"You can press CTRL + Z to completely rewind time if you get stuck.",
	"Press Z to repeat these messages."
]

func restartMessages():
	i = 0
	messagesRead = false
	hideMessages = false

func _input(event):
	if Input.is_action_pressed("Z") and messagesRead:
		restartMessages()
	
func showText(index):
	if index != messages.size():
		$Label.text = messages[index]
		$Label.show()
	else:
		hideMessages = true
		messagesRead = true
		


func _on_Timer_timeout():
	if !hideMessages:
		showText(i)
		i += 1
	else:
		$Label.hide()

func _ready():
	$Timer.wait_time = onScreenTime
	$Timer.start()
