extends Object
class_name MeshFactory

static func curved_leaf(length: float, width: float) -> ArrayMesh:
	var verts = PoolVector3Array()
	var uvs = PoolVector2Array()
	var normals = PoolVector3Array()
	
	verts.push_back(Vector3(0.0, 0.0, 0.0))
	uvs.push_back(Vector2(0.0, 0.0))
	normals.push_back(Vector3(0.0, -0.33, -0.66))
	
	verts.push_back(Vector3(width * -0.5, length * 0.3, length * 0.25))
	uvs.push_back(Vector2(0.3, 0.3))
	normals.push_back(Vector3(0.0, -0.15, -0.85))
	
	verts.push_back(Vector3(width * 0.5, length * 0.3, length * 0.25))
	uvs.push_back(Vector2(0.3, 0.3))
	normals.push_back(Vector3(0.0, -0.15, -0.85))
	
	verts.push_back(Vector3(width * -0.5, length * 0.7, length * 0.25))
	uvs.push_back(Vector2(0.7, 0.7))
	normals.push_back(Vector3(0.0, 0.15, -0.85))
	
	verts.push_back(Vector3(width * 0.5, length * 0.7, length * 0.25))
	uvs.push_back(Vector2(0.7, 0.7))
	normals.push_back(Vector3(0.0, 0.15, -0.85))
	
	verts.push_back(Vector3(0.0, length, 0.0))
	uvs.push_back(Vector2(1.0, 1.0))
	normals.push_back(Vector3(0.0, 0.33, -0.66))
	
	var arrays = []
	arrays.resize(Mesh.ARRAY_MAX)
	arrays[Mesh.ARRAY_VERTEX] = verts
	arrays[Mesh.ARRAY_TEX_UV2] = uvs
	arrays[Mesh.ARRAY_NORMAL] = normals	
	
	var mesh = ArrayMesh.new()
	mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLE_STRIP, arrays)
	mesh.custom_aabb = AABB(Vector3(-0.5, 0.0, -0.5), Vector3(0.5, 1.0, 0.5))
	
	return mesh
	
static func add_simple_petal(
	verts: Array,
	uvs: Array,
	normals: Array,
	length: float,
	width: float,
	phi: float
) -> void:
	verts.push_back(Vector3(0.0, 0.0, 0.0).rotated(Vector3.BACK, phi))
	uvs.push_back(Vector2(0.0, 0.0))
	normals.push_back(Vector3(0.0, 0.0, 1.0))
	
	verts.push_back(Vector3(width * 0.5, length * 0.5, 0.0).rotated(Vector3.BACK, phi))
	uvs.push_back(Vector2(0.5, 0.5))
	normals.push_back(Vector3(0.0, 0.0, 1.0))
	
	verts.push_back(Vector3(-width * 0.5, length * 0.5, 0.0).rotated(Vector3.BACK, phi))
	uvs.push_back(Vector2(0.5, 0.5))
	normals.push_back(Vector3(0.0, 0.0, 1.0))
	
	verts.push_back(Vector3(-width * 0.5, length * 0.5, 0.0).rotated(Vector3.BACK, phi))
	uvs.push_back(Vector2(0.5, 0.5))
	normals.push_back(Vector3(0.0, 0.0, 1.0))
	
	verts.push_back(Vector3(width * 0.5, length * 0.5, 0.0).rotated(Vector3.BACK, phi))
	uvs.push_back(Vector2(0.5, 0.5))
	normals.push_back(Vector3(0.0, 0.0, 1.0))
	
	verts.push_back(Vector3(0.0, length, 0.0).rotated(Vector3.BACK, phi))
	uvs.push_back(Vector2(1.0, 1.0))
	normals.push_back(Vector3(0.0, 0.0, 1.0))
	
static func simple_flower(
	petal_length: float, 
	petal_width: float, 
	num_petals: int
) -> ArrayMesh:
	var verts = []
	var uvs = []
	var normals = []
	
	for i in num_petals:
		print("Adding petal ", i)
		add_simple_petal(
			verts, 
			uvs, 
			normals, 
			petal_length, 
			petal_width,
			(PI * 2.0 / float(num_petals)) * float(i) 
		)
	
	var arrays = []
	arrays.resize(Mesh.ARRAY_MAX)
	arrays[Mesh.ARRAY_VERTEX] = PoolVector3Array(verts)
	arrays[Mesh.ARRAY_TEX_UV2] = PoolVector2Array(uvs)
	arrays[Mesh.ARRAY_NORMAL] = PoolVector3Array(normals)
	
	var mesh = ArrayMesh.new()
	mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)
	mesh.custom_aabb = AABB(Vector3(-0.5, 0.0, -0.5), Vector3(0.5, 1.0, 0.5))
	
	return mesh
	
