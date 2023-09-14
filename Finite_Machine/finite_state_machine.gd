extends Node
class_name FiniteStateMachine

@export var state : State
# Called when the node enters the scene tree for the first time.
func _ready():
	change_state(state)

func change_state(new_state : State):
	if state is State:
		state.exit_state()
	new_state.enter_state()
	state = new_state

