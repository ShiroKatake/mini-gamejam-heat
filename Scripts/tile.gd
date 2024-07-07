extends Node2D

@export var _temperature:= 0
var path1: String = "res://tileGrass_slope.png"
var path2: String = "res://tileSand_slope.png"
var path3: String = "res://tileSnow_slope.png"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func new_temp(temp: int):
	_temperature = temp
	update_sprite()

func temp_plus(temp: int):
	if _temperature > -1 or _temperature < 1:
		_temperature += temp
	update_sprite()

func update_sprite():
	if _temperature > 0:
		$Sprite2D.texture = load(path3)
	elif _temperature < 0:
		$Sprite2D.texture = load(path2)
	else:
		$Sprite2D.texture = load(path1)
