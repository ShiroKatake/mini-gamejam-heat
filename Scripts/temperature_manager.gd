extends Node
class_name TempControl

@export var grid: Grid2D
var _temperature_grid: Dictionary
var _tile_scene = load("res://Tile.tscn")
var snowmans
var position = "position"
@onready var rng := RandomNumberGenerator.new()
@export var _action_count = 3

# Called when the node enters the scene tree for the first time.
func _ready():
	snowmans = $"../SnowmanManager".get_children()
	for snowman in snowmans:
		snowman.crack_value.connect(_on_snowman_crack_value)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_grid_2d_grid_reset(new_grid):
	_temperature_grid = new_grid.duplicate()
	var count = 0
	var total = _temperature_grid.size()
	for cell in _temperature_grid.keys():
		if (count >= total - _action_count):
			break
		var tile = _tile_scene.instantiate()
		_temperature_grid[cell] = tile
		if not is_value_null(cell):
			tile.new_temp(rng.randi_range(-1, 1))
		$".".add_child(tile)
		count += 1
		tile.position = cell * 64
	pass # Replace with function body.


func has_cell(cell: Vector2i) -> bool:
	return _temperature_grid.keys().has(cell)
	
## Returns [code]true[/code] if the ([param x], [param y]) cell exists in the grid.
func has_cellxy(x: int, y: int) -> bool:
	return has_cell(Vector2i(x, y))


func get_value(cell: Vector2i):
	if not has_cell(cell):
		## push_error("Attempted to get value at %s in %s, but the cell doesn't exist" % [cell, name])
		return null
	return _temperature_grid[cell]

func is_value_null(cell: Vector2i) -> bool:
	return get_value(cell) == null
	
func are_values_null(cells: Array[Vector2i]) -> bool:
	for cell in cells:
		if not is_value_null(cell):
			return false
	return true

func _on_snowman_crack_value(aoe: Array[Vector2i]):
	for hit in aoe:
		if(not is_value_null(hit)) and not has_cell(hit) or not is_value_null(hit):
			_temperature_grid[hit].temp_plus(1)
	pass # Replace with function body.
