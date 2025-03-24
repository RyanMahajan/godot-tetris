extends Resource
class_name Tetrimino

# Define the shapes of the tetriminos in a 4x4 grid format
const SHAPES = [
	[[1, 1, 1, 1]],  # I
	[[1, 1], [1, 1]],  # O
	[[0, 1, 0], [1, 1, 1]],  # T
	[[1, 1, 0], [0, 1, 1]],  # S
	[[0, 1, 1], [1, 1, 0]],  # Z
	[[1, 0, 0], [1, 1, 1]],  # L
	[[0, 0, 1], [1, 1, 1]]   # J
]

@export var shape: Array
var position: Vector2

func _init():
	shape = SHAPES[randi() % SHAPES.size()]  # Randomly select a shape
	position = Vector2(4, 0)  # Start position at top-center of the grid

# Method to rotate the shape 90 degrees
func rotate():
	var old_shape = shape.duplicate(true)
	var old_width = shape[0].size()
	var old_height = shape.size()

	# Compute center offset
	var center_x = floor(old_width / 2.0)
	var center_y = floor(old_height / 2.0)

	# Create an empty 2D array with swapped dimensions
	var new_width = old_height
	var new_height = old_width
	var new_shape = []
	for _i in range(new_height):
		new_shape.append([])

	# Rotate 90 degrees clockwise
	for y in range(old_height):
		for x in range(old_width):
			new_shape[x].insert(0, shape[y][x])

	# Compute new center after rotation
	var new_center_x = floor(new_width / 2.0)
	var new_center_y = floor(new_height / 2.0)

	# Adjust position to keep the center aligned
	position.x += center_x - new_center_x
	position.y += center_y - new_center_y

	# Apply the new shape
	shape = new_shape


func move(direction: Vector2):
	position += direction
