extends TurnState

signal snow_countdown() 

var snowmans

func _ready():
	snowmans = $"../../SnowmanManager".get_children()

# Called when the node enters the scene tree for the first time.
func enter():
	print('Start Processes')
	snow_countdown.emit()
	if Global.TurnCount > 0:
		for snowman in snowmans:
			snowman._on_snow_countdown()
	Global.TurnCount += 1
	await get_tree().create_timer(2).timeout
	print('Start Processes Ended')
	transition_requested.emit(self, TurnState.State.PLAYER)
	pass # Replace with function body.

