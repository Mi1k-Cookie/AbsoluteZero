extends Area2D

export(String) var doorName
var door
var pushSent = false
var standingOn
var standingOnGotten = false

signal push
signal off

func _ready():
	door = get_parent().get_node(doorName)
	$AnimatedSprite.play("default")
	connect("push", door, "onButtonPush")
	connect("off", door, "onButtonOff")

func _on_Button_body_entered(body):
	if body.name == "Spaceman" or "Statue" in body.name:
		if standingOnGotten == false:
			standingOn = body.name
			standingOnGotten = true
		emit_signal("push")
		$AnimatedSprite.play("push")
		pushSent = true

func _on_Button_body_exited(body):
	if standingOnGotten:
		if standingOn == body.name:
			standingOnGotten = false
			emit_signal("off")
			$AnimatedSprite.play("unpush")
			pushSent = false
