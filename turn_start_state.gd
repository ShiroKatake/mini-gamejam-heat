extends TurnState

# Called when the node enters the scene tree for the first time.
func enter():
	print('Start Processes')
	await get_tree().create_timer(5).timeout
	print('Start Processes Ended')
	transition_requested.emit(self, TurnState.State.PLAYER)
	pass # Replace with function body.

