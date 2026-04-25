extends MultiMeshInstance2D

func _ready() -> void:
	SignalManager.rebuild_player_grid.connect(generate_outlines)
	
	await get_tree().create_timer(0.2).timeout
	generate_outlines()

func create_single_edge_mesh(thickness: float) -> ArrayMesh:
	var mesh = ArrayMesh.new()
	var s = 68.0
	var t = thickness
	# Erstellt ein Rechteck, das flach auf der X-Achse liegt
	var vertices = PackedVector2Array([
		Vector2(0, 0), Vector2(s, 0), Vector2(s, -t),
		Vector2(0, 0), Vector2(s, -t), Vector2(0, -t)
	])
	var arrays = []
	arrays.resize(Mesh.ARRAY_MAX)
	arrays[Mesh.ARRAY_VERTEX] = vertices
	mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)
	return mesh

func generate_outlines(thickness: float = 4.0) -> void:
	var m_mesh = MultiMesh.new()
	m_mesh.mesh = create_single_edge_mesh(thickness)
	m_mesh.use_colors = true
	m_mesh.transform_format = MultiMesh.TRANSFORM_2D
	
	var edge_data = []
	var s = 68.0 # Feldgröße
	
	for grid_pos in GameData.player_grid:
		if not GameData.player_grid[grid_pos]:
			continue
			
		# JUSTIERE DIESE WERTE:
		# "rot" ist die Drehung, "off" schiebt die Linie an die Panel-Kante
		var checks = {
			Vector2i.UP: {
				"rot": 0.0, 
				"off": Vector2(-thickness, s) 
			},
			Vector2i.DOWN: {
				"rot": 0.0, 
				"off": Vector2(-thickness, 0) #x must be longer not offset
			},
			Vector2i.RIGHT: {
				"rot": -PI/2, 
				"off": Vector2(s, s- thickness) 
			},
			Vector2i.LEFT: {
				"rot": -PI/2, 
				"off": Vector2(0, s) 
			}
		}
		
		for dir in checks:
			if not GameData.player_grid.get(grid_pos + dir, false):
				var setup = checks[dir]
				edge_data.append({
					"pos": Vector2(grid_pos.x * s, -grid_pos.y * s + 68* 8) + setup["off"],
					"rot": setup["rot"]
				})
	
	m_mesh.instance_count = edge_data.size()
	
	for i in range(edge_data.size()):
		var data = edge_data[i]
		var tr = Transform2D(data.rot, data.pos)
		m_mesh.set_instance_transform_2d(i, tr)
		m_mesh.set_instance_color(i, Color.RED)
		
	self.multimesh = m_mesh
