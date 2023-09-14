extends Label

@onready var finite_state_machine = $"../FiniteStateMachine"

func _process(_delta):
	text = finite_state_machine.state.name
