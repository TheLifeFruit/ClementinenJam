extends TileMapLayer

@export var grid_width: int = 32
@export var grid_height: int = 18
@export var obstacle_density: float = 0.3 # 30% chance to generate a black tile

@export var terrain_set_id: int = 0
@export var terrain_white_id: int = 0
@export var source_id: int = 0

# Set this to the location of your isolated black tile
@export var black_tile_atlas_coord: Vector2i = Vector2i(0, 0) 

func _ready():
	randomize() 
	generate_random_field()

func generate_random_field():
	clear() 
	var white_cells: Array[Vector2i] = []

	for x in range(grid_width):
		for y in range(grid_height):
			var cell_pos = Vector2i(x, y)
			
			if randf() < obstacle_density:
				set_cell(cell_pos, source_id, black_tile_atlas_coord)
			else:
				white_cells.append(cell_pos)

	if not white_cells.is_empty():
		# This function looks at the terrain set (0) and the specific terrain (0)
		# and figures out which tile from the atlas to use based on neighboring tiles.
		set_cells_terrain_connect(white_cells, terrain_set_id, terrain_white_id)
