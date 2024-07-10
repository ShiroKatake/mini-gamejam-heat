extends Node
class_name TurnState

signal transition_requested(from: TurnState, to: State)
enum State {PROCESSES, PLAYER, ENEMY}
@export var state : State
# Called when the node enters the scene tree for the first time.
func enter():
	pass
	
func _process(_delta):
	pass

func on_input(_event: InputEvent):
	pass
	
func on_gui_input(_event: InputEvent):
	pass

func exit():
	pass
