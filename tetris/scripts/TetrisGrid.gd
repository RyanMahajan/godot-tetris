extends Resource
class_name TetrisGrid

@export var GRID_WIDTH = 10
@export var GRID_HEIGHT = 20
@export var GRID_SIZE = 20

@export var grid: Array = []

func _init():
	initialize_grid()

func initialize_grid():
	grid.clear()
	for y in range(GRID_HEIGHT):
		var row = []
		for x in range(GRID_WIDTH):
			row.append(null)  # Null represents an empty cell
		grid.append(row)

func is_cell_empty(x: int, y: int) -> bool:
	return grid[y][x] == null if (0 <= x < GRID_WIDTH and 0 <= y < GRID_HEIGHT) else false

func set_cell(x: int, y: int, value):
	if 0 <= x < GRID_WIDTH and 0 <= y < GRID_HEIGHT:
		grid[y][x] = value

func clear_row(y: int):
	grid.remove_at(y)  # Remove the completed row
	grid.insert(0, [])  # Insert a new empty row

	# Refill the new row with unique `null` values
	for i in range(GRID_WIDTH):
		grid[0].append(null)
