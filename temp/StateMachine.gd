extends Node2D
class_name StateMachine

var state = null setget setState
var prevState = null
var states = {}

onready var parent = get_parent()

func _physics_process(delta):
	if state != null:
		_stateLogic(delta)
		var transition = _getTransition(delta)
		if transition != null:
			setState(transition)
			
func _stateLogic(delta):
	pass

func _getTransition(delta):
	return null

func _enterState(newState, oldState):
	pass

func _exitState(oldState, newState):
	pass

func setState(newState):
	prevState = state
	state = newState
	
	if prevState != null:
		_exitState(prevState, newState)
	if newState != null:
		_enterState(newState, prevState)

func addState(stateName):
	states[stateName] = states.size()
