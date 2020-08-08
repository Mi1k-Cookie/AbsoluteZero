extends "res://StateMachine.gd"


func _input(event):
	if Input.is_action_pressed("reload"):
		parent.get_parent().reloadLevel()
	if [states.idle, states.run, states.jump, states.fall].has(state):
		if event.is_action_pressed("restart") and !parent.isRecording and parent.rewindCount > 0:
			parent.emit_signal("anchorPlaced", parent.position)
			parent.sfxManager.playSFX(parent.sfx[2], parent.global_position)
			parent.isRecording = true
			parent.speedTimer.start(0.032)
		elif event.is_action_pressed("restart") and !parent.isRewinding and parent.isRecording:
			print(parent.rewindCount)
			if parent.rewindCount > 0:
				parent.isRewinding = true
				parent.rewindCount -= 1
			else:
				parent.isRewinding = false
				parent.canRecord = false
	if [states.idle, states.run].has(state):
		if event.is_action_pressed("ui_up") and parent.is_on_floor() and !parent.isRewinding:
			parent._jump()
			
func _stateLogic(delta):
	if parent.isAlive:
		if !parent.isRewinding:
			if parent.canRecord:
				parent._record()
			parent._handleMovement()
		else:
			parent._rewind()
	parent._applyGravity(delta)
	parent._applyMovement()

func _getTransition(delta):
	match state:
		states.idle:
			if parent.isAlive:
				if !parent.isRewinding:
					if !parent.is_on_floor():
						if parent.velocity.y < 0:
							return states.jump
						elif parent.velocity.y > 0:
							return states.fall
					elif parent.velocity.x != 0:
						return states.run
				else:
					return states.rewind
			else:
				return states.dead
		states.run:
			if parent.isAlive:
				if !parent.isRewinding:
					if !parent.is_on_floor():
						if parent.velocity.y < 0:
							return states.jump
						elif parent.velocity.y > 0:
							return states.fall
					elif parent.velocity.x == 0:
						return states.idle
				else:
					return states.rewind
			else:
				return states.dead
		states.jump:
			if parent.isAlive:
				if !parent.isRewinding:
					if parent.is_on_floor():
						return states.idle
					elif parent.velocity.y >= 0:
						return states.fall
				else:
					return states.rewind
			else:
				return states.dead
		states.fall:
			if parent.isAlive:
				if !parent.isRewinding:
					if parent.is_on_floor():
						return states.idle
					elif parent.velocity.y < 0:
						return states.jump
				else:
					return states.rewind
			else:
				return states.dead
		states.rewind:
			if parent.isAlive:
				if parent.posList.size() <= 0:
					return states.idle
			else:
				return states.dead
	
	return null

func _enterState(newState, oldState):
	match newState:
		states.idle:
			parent.textLabel.text = "IDLE"
			parent.animPlayer.play("default")
			parent.currentAnim = "default"
		states.run:
			parent.textLabel.text = "RUN"
			parent.animPlayer.play("run")
			parent.currentAnim = "run"
		states.fall:
			parent.textLabel.text = "FALL"
			parent.animPlayer.play("fall")
			parent.currentAnim = "fall"
		states.jump:
			parent.textLabel.text = "JUMP"
			parent.animPlayer.play("jump")
			parent.currentAnim = "jump"
		states.rewind:
			parent.textLabel.text = "REWINDING"
		states.dead:
			parent.textLabel.text = "DEAD"

func _exitState(oldState, newState):
	pass

func _ready():
	addState("jump")
	addState("run")
	addState("rewind")
	addState("fall")
	addState("idle")
	addState("rewind")
	addState("dead")
	call_deferred("setState", states.idle)
