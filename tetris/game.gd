extends Node2D

@export var tetris_grid: TetrisGrid
@export var tetrimino_scene: PackedScene  # Reference to the Tetrimino scene

var current_tetrimino: Tetrimino

func _ready():
	if not tetris_grid:
		tetris_grid = TetrisGrid.new()
	queue_redraw()  # Trigger redraw
	spawn_new_tetrimino()  # Spawn the first Tetrimino

func _physics_process(delta: float):
	if current_tetrimino:
		if not check_collision(current_tetrimino, Vector2(0, 1)):  # Check if it can move down
			lock_tetrimino(current_tetrimino)  # Lock the Tetrimino if it can't move down
			#spawn_new_tetrimino()  # Spawn a new Tetrimino
		else:
			current_tetrimino.position.y += 1  # Move the Tetrimino down

		queue_redraw()  # Redraw the grid with the new position

func _draw():
	if not tetris_grid:
		return

	# Draw the already placed Tetriminos (from the grid)
	for y in range(tetris_grid.GRID_HEIGHT):
		for x in range(tetris_grid.GRID_WIDTH):
			if tetris_grid.grid[y][x] == null:  # Only draw if the grid cell is not null (occupied)
				draw_rect(
					Rect2(x * tetris_grid.GRID_SIZE, y * tetris_grid.GRID_SIZE, 
						  tetris_grid.GRID_SIZE, tetris_grid.GRID_SIZE),
					Color(1, 0, 0),  # Color for placed blocks (red)
					false
				)
			else:
				draw_rect(
					Rect2(x * tetris_grid.GRID_SIZE, y * tetris_grid.GRID_SIZE, 
						  tetris_grid.GRID_SIZE, tetris_grid.GRID_SIZE),
					Color(0, 0, 1),  # Color for placed blocks (red)
					false
				)

	# Draw the current Tetrimino
	if current_tetrimino:
		for x in range(current_tetrimino.shape.size()):
			for y in range(current_tetrimino.shape[x].size()):
				if current_tetrimino.shape[x][y] == 1:
					draw_rect(
						Rect2((current_tetrimino.position.x + x) * tetris_grid.GRID_SIZE, 
							  (current_tetrimino.position.y + y) * tetris_grid.GRID_SIZE, 
							  tetris_grid.GRID_SIZE, tetris_grid.GRID_SIZE),
						Color(0, 1, 0),  # Color for the current Tetrimino (green)
						false
					)


# Spawn a new Tetrimino
func spawn_new_tetrimino():
	current_tetrimino = Tetrimino.new()

# Check if the Tetrimino would collide with the grid if it moves
func check_collision(tetrimino: Tetrimino, movement: Vector2) -> bool:
	# Check only the bottommost row of the shape
	for x in range(tetrimino.shape.size()):
		for y in range(tetrimino.shape[x].size()):
			if tetrimino.shape[x][y] == 1:
				var new_x = tetrimino.position.x + x + movement.x
				var new_y = tetrimino.position.y + y + movement.y

				# Check if the new position is within grid bounds first
				if new_x < 0 or new_x >= tetris_grid.GRID_WIDTH or new_y < 0 or new_y >= tetris_grid.GRID_HEIGHT:
					return false  # Out of bounds, collision

				# If moving down, only check the bottommost row
				if movement.y > 0:
					# Ensure we only check the bottom row of the Tetrimino's shape
					if y == tetrimino.shape[x].size() - 1:  # Bottom row
						# Check for collision with an existing block
						if tetris_grid.grid[new_y][new_x] != null:
							return false  # Collision detected
				else:
					# If not moving down, check all rows (for left/right movement)
					if tetris_grid.grid[new_y][new_x] != null:
						return false  # Collision detected

	return true  # No collision


# Lock the Tetrimino in place
func lock_tetrimino(tetrimino: Tetrimino):
	for x in range(tetrimino.shape.size()):
		for y in range(tetrimino.shape[x].size()):
			if tetrimino.shape[x][y] == 1:
				var grid_x = tetrimino.position.x
				var grid_y = tetrimino.position.y
				tetris_grid.grid[grid_y][grid_x] = 1  # Mark the grid position as occupied
