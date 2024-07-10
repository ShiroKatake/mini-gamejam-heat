extends TurnState


# Called when the node enters the scene tree for the first time.
func enter():
	print("Enemy's Turn")
	await get_tree().create_timer(2).timeout
	print("Enemy's Turn Ended")
	transition_requested.emit(self, TurnState.State.PROCESSES)
	pass # Replace with function body.
