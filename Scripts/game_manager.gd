class_name CardStateMachine
extends Node2D

@export var initial_state: TurnState
var current_state : TurnState
var states := {}

# Called when the node enters the scene tree for the first time.
func _ready():
	for child in get_children():
		if child is TurnState:
			states[child.state] = child
			child.transition_requested.connect(_on_transition_requested)
	
	if initial_state:
		initial_state.enter()
		current_state = initial_state
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_transition_requested(from: TurnState, to: TurnState.State) -> void:
	if from != current_state:
		return
	var new_state: TurnState = states[to]
	if not new_state:
		return
	
	if current_state:
		current_state.exit()
	
	new_state.enter()
	current_state = new_state
	pass
	
