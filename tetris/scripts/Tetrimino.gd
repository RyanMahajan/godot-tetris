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
	var new_shape = []
	
	# Transpose the shape (swap rows and columns)
	for y in range(shape[0].size()):
		var new_row = []
		for x in range(shape.size()):
			new_row.append(shape[x][y])  # Copy values by transposing
		new_shape.append(new_row)

	# Reverse each row to complete the 90-degree rotation
	for i in range(new_shape.size()):
		new_shape[i] = new_shape[i].reversed()

	shape = new_shape  # Update the shape to the new rotated shape
