extends MultiMeshInstance2D


func _ready() -> void:
	await get_tree().create_timer(0.2).timeout
	generate_outlines()


# Ein Mesh, das nur EINE horizontale Linie (oben) darstellt
func create_single_edge_mesh(thickness: float) -> ArrayMesh:
	var mesh = ArrayMesh.new()
	var s = 68.0
	var t = thickness
	# Ein Rechteck von (0,0) bis (64, thickness)
	var vertices = PackedVector2Array([
		Vector2(0, 0), Vector2(s, 0), Vector2(s, t),
		Vector2(0, 0), Vector2(s, t), Vector2(0, t)
	])
	var arrays = []
	arrays.resize(Mesh.ARRAY_MAX)
	arrays[Mesh.ARRAY_VERTEX] = vertices
	mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)
	return mesh


func generate_outlines(thickness: float = 4.0):
	var multimesh = MultiMesh.new()
	multimesh.mesh = create_single_edge_mesh(thickness)
	multimesh.use_colors = true
	multimesh.transform_format = MultiMesh.TRANSFORM_2D
	
	var edge_data = [] # Speichert Position und Rotation pro Kante
	
	for grid_pos in GameData.player_grid:
		if not GameData.player_grid[grid_pos]:
			continue
			
		# Prüfe jede Seite einzeln
		var checks = {
			Vector2i.UP: 0.0,            # 0 Grad Drehung
			Vector2i.RIGHT: PI/2,        # 90 Grad
			Vector2i.DOWN: PI,           # 180 Grad
			Vector2i.LEFT: -PI/2         # -90 Grad
		}
		
		for dir in checks:
			if not GameData.player_grid.get(grid_pos + dir, false):
				# Hier ist ein Übergang von 1 auf 0 -> Kante zeichnen
				edge_data.append({
					"pos": Vector2(grid_pos.x * 68, grid_pos.y * 68 + 68),
					"rot": checks[dir]
				})
	
	multimesh.instance_count = edge_data.size()
	
	for i in range(edge_data.size()):
		var data = edge_data[i]
		# Transform mit Rotation erstellen, um die Linie an die richtige Seite zu legen
		# Wir verschieben den Pivot-Punkt je nach Rotation, damit die Linie bündig sitzt
		var offset = Vector2(0, 0)
		if data.rot == PI/2: offset = Vector2(68, 0)   # Rechts
		elif data.rot == PI: offset = Vector2(68, 68)  # Unten
		elif data.rot == -PI/2: offset = Vector2(0, 68)# Links
		
		var t = Transform2D(data.rot, data.pos + offset)
		multimesh.set_instance_transform_2d(i, t)
		multimesh.set_instance_color(i, Color.RED)
		
	self.multimesh = multimesh
