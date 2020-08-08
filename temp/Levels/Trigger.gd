extends Area2D

var sigEmitted

signal triggered

func _ready():
	connect("triggered", get_parent(), "onTriggerTriggered")

func _on_Trigger_body_entered(body):
	if "Spaceman" in body.name:
		emit_signal("triggered")
