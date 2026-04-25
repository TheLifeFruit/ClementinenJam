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
	var multimesh = MultiMesh.new()
	multimesh.mesh = create_single_edge_mesh(thickness)
	multimesh.use_colors = true
	multimesh.transform_format = MultiMesh.TRANSFORM_2D
	
	var edge_data = []
	var s = 68.0 # Feldgröße
	var t = thickness
	
	for grid_pos in GameData.player_grid:
		if not GameData.player_grid[grid_pos]:
			continue
			
		# JUSTIERE DIESE WERTE:
		# "rot" ist die Drehung, "off" schiebt die Linie an die Panel-Kante
		var checks = {
			Vector2i.UP: {
				"rot": 0.0, 
				"off": Vector2(0, s) 
			},
			Vector2i.DOWN: {
				"rot": 0.0, 
				"off": Vector2(0, t) 
			},
			Vector2i.RIGHT: {
				"rot": -PI/2, 
				"off": Vector2(s, s) 
			},
			Vector2i.LEFT: {
				"rot": -PI/2, 
				"off": Vector2(t, s) 
			}
		}
		
		for dir in checks:
			if not GameData.player_grid.get(grid_pos + dir, false):
				var setup = checks[dir]
				edge_data.append({
					"pos": Vector2(grid_pos.x * s, -grid_pos.y * s + 68* 8) + setup["off"],
					"rot": setup["rot"]
				})
	
	multimesh.instance_count = edge_data.size()
	
	for i in range(edge_data.size()):
		var data = edge_data[i]
		var tr = Transform2D(data.rot, data.pos)
		multimesh.set_instance_transform_2d(i, tr)
		multimesh.set_instance_color(i, Color.RED)
		
	self.multimesh = multimesh
