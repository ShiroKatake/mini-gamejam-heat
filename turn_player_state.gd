extends TurnState

var snowmans

func _ready():
	snowmans = $"../../SnowmanManager".get_children()
	for snowman in snowmans:
		snowman.end_turn.connect(_on_turn_end)

# Called when the node enters the scene tree for the first time.
func enter():
	Global.playerTurn = true
	print("Player's Turn")
	pass # Replace with function body.
		
func _process(delta):
	if Input.is_action_just_pressed("pass"):
		transition_requested.emit(self, TurnState.State.ENEMY)

func _on_turn_end():
	Global.playerTurn = false
	print("Player's Turn Ended")
	transition_requested.emit(self, TurnState.State.ENEMY)
	pass
