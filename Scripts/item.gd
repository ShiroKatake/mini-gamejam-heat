extends Area2D
class_name Snowman_P

@export var grid: Grid2D
@export var size: Vector2i = Vector2i.ONE
@export var combo: Vector2i = Vector2i.ZERO
@export var aoe_offset: Vector2i = Vector2i.ZERO
@export var cooldown: int = 3

var dragging := false
var _drag_start_pos: Vector2i
var _start_positions: Array[Vector2i]
var occupied_cells: Array[Vector2i]
var occupied_aoes: Array[Vector2i]
var tween: Tween
@export var countdown: int = 0
signal crack_value(aoe: Array[Vector2i])
signal snow_value(aoe: Array[Vector2i], snow: Snowman_P)
signal end_turn()


@onready var top_left_cell = Vector2i(0, 0) :
	set(value):
		var prev_cell = top_left_cell

		if grid.has_cells(_get_cells(value)):
			top_left_cell = value

		var world_pos := grid.map_to_world(top_left_cell)
		tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUINT)
		tween.tween_property(self, "global_position", world_pos, 0.3)


func _ready() -> void:
	input_event.connect(_on_input_event)
	for x in size.x:
		for y in size.y:
			occupied_cells.append(Vector2i(x, y))
	for x in combo.x:
		for y in combo.y:
			occupied_aoes.append(Vector2i(x, y))
	_move_to(grid.world_to_map(global_position))
	_start_positions = [Vector2(10, 16), Vector2(11, 16), Vector2(12,16)]


func enter():
	$StartTurn.snow_countdown.connect(_on_snow_countdown)
	

func _process(_delta: float) -> void:
	if dragging:
		global_position = get_global_mouse_position() - _get_centered_offset()
		queue_redraw()


func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int):
	if event is InputEventMouseButton and Global.playerTurn and countdown <= 0:
		if event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
			_start_dragging()


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and Global.playerTurn and countdown <= 0:
		if event.button_index == MOUSE_BUTTON_LEFT and event.is_released():
			if dragging:
				_stop_dragging()


func _start_dragging() -> void:
	tween.stop()
	z_index = 1
	dragging = true
	_drag_start_pos = top_left_cell

	grid.set_values(_get_cells(top_left_cell), null)
	grid.queue_redraw()
	

func _stop_dragging() -> void:
	z_index = 0
	dragging = false

	var target_cell := _get_mouse_top_left_cell()
	var aoe_cell := _get_snomwan_area()
	
	var target_cells := _get_cells(target_cell)
	var aoe_cells := _get_aoe(aoe_cell)
	
	if not grid.has_cells(target_cells) or not grid.are_values_null(target_cells):
		target_cell = _drag_start_pos
	if(target_cell != _drag_start_pos) and not $"../../TemperatureManager".is_value_null(target_cell):
		crack_value.emit(aoe_cells)
		snow_value.emit(aoe_cells, self)
		end_turn.emit()
	
	print(aoe_cells)
	for hit in aoe_cells:
		if not grid.is_value_null(hit) and not $"../../TemperatureManager".is_value_null(target_cell):
			print(grid._grid[hit])
			grid.get_value(hit)._on_snow_countdown()
	
	_move_to(target_cell)
	queue_redraw()

func _move_to(cell: Vector2i) -> void:
	var target_cells := _get_cells(cell)
	if not grid.has_cells(target_cells) or not grid.are_values_null(target_cells):
		cell = _get_next_empty_cell_in_grid()
	top_left_cell = cell
	grid.set_values(_get_cells(top_left_cell), self)
	if not $"../../TemperatureManager".is_value_null(cell):
		countdown = cooldown
	grid.queue_redraw()


func _get_centered_offset() -> Vector2:
	return (Vector2(size) * 0.5) * Vector2(grid.cell_size)

func _get_mouse_top_left_cell() -> Vector2i:
	return grid.world_to_map(get_global_mouse_position() + Vector2(grid.cell_size)/2.0 - _get_centered_offset())
	
func _get_snowman_offeset() -> Vector2:
	return ((Vector2(combo) * 0.5) + Vector2(aoe_offset)) * Vector2(grid.cell_size)

func _get_snomwan_area() -> Vector2i:
	return grid.world_to_map(get_global_mouse_position() + Vector2(grid.cell_size)/2.0 - _get_snowman_offeset())

# Get all cells the item will occupy based on its size.
func _get_cells(origin: Vector2i) -> Array[Vector2i]:
	var cells: Array[Vector2i]
	for occupied_cell in occupied_cells:
		cells.append(occupied_cell + origin)
	return cells

func _get_aoe(origin: Vector2i) -> Array[Vector2i]:
	var cells: Array[Vector2i]
	for occupied_aoe in occupied_aoes:
		cells.append(occupied_aoe + origin)
	return cells

func _get_next_empty_cell_in_grid() -> Vector2i:
	for cell in grid.get_cells():
		if grid.is_value_null(cell):
			return cell

	return Vector2i(NAN, NAN)


func _draw() -> void:
	# Highlight cells the item will occupy.
	if dragging:
		var current_cell := _get_mouse_top_left_cell()
		var shadow_call := _get_snomwan_area()
		if not grid.has_cells(_get_cells(current_cell)):
			return


		var rect_position := to_local(grid.map_to_world(current_cell))
		var rect_size := size * grid.cell_size
		draw_rect(Rect2(rect_position, rect_size), Color(1, 1, 1, 0.38823530077934))
		
		var rect_position2 := to_local(Vector2(shadow_call * 64))
		var rect_size2 := combo * grid.cell_size
		draw_rect(Rect2(rect_position2, rect_size2), Color(1, 0, 0, 0.38823530077934))

func _on_snow_countdown():
	countdown -= 1
	_drag_start_pos = top_left_cell
	if countdown <= 0 and not $"../../TemperatureManager".is_value_null(_drag_start_pos):
		for pos in _start_positions:
			if (grid.is_value_null(pos)):
				_move_to(pos)
				break
		pass
