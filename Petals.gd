tool
extends MeshInstance

export (Material) var material setget set_material, get_material
export var generator_seed := -1 setget set_generator_seed
export var trunk_width := 1.0 setget set_trunk_width
export var segment_length := 1.0 setget set_segment_length

var cursor_position := Vector3.ZERO
var petal_color := Color(170, 35, 35)

func set_material(mat: Material):
	material = mat
	generate()
func get_material() -> Material:
	return material
func set_generator_seed(new_s: int):
	generator_seed = new_s
	generate()
func set_trunk_width(new_tw: float):
	trunk_width = new_tw
	generate()
func set_segment_length(new_sl: float):
	segment_length = new_sl
	generate()

func _ready() -> void:
#	if generator_seed == -1:
	generator_seed = randi()
	generate()

func generate() -> void:
	cursor_position = Vector3.ZERO
	var surface_tool = SurfaceTool.new()
	surface_tool.begin(Mesh.PRIMITIVE_TRIANGLES)
	surface_tool.add_color(petal_color)
	draw_flower(surface_tool)
	surface_tool.index()
	surface_tool.generate_normals()
	mesh = surface_tool.commit()
	set_surface_material(0, material)

func fourier_transform(x: float) -> float:
	return 2 * sin(x) + cos(2 * x + PI / 4.2)

func get_transform_points() -> PoolVector3Array:
	var points = []
	for i in range(0, 1080):
		var rad = i * PI / 180
		var x = lerp(-5, 5, rad / (2 * PI))
		points.append(Vector3(x, fourier_transform(x), 0))
	return points

func draw_flower(st: SurfaceTool) -> void:
	randomize()
	var k = rand_range(0.5, 2)
	var points = get_transform_points()
	var size = 1080
	for i in range(points.size()):
		st.add_vertex(cursor_position)
		st.add_vertex(points[i].y * Vector3(
			cos(2 * PI / size * k * i),
			-1 * sin(2 * PI / size * k * i),
			0
		))
		st.add_vertex(points[i].y * Vector3(
			cos(2 * PI / size * k * (i + 1)),
			-1 * sin(2 * PI / size * k * (i + 1)),
			0
		))



#func draw_branch(st: SurfaceTool, v: Vector3, width: float) -> void:
#	# this solution only works for 2d right now
#	# need to make it 3d
#	var bottom = v.cross(Vector3.FORWARD).normalized()
#	var pos = cursor_position
#	st.add_color(branch_color)
#	st.add_vertex(pos)
#	st.add_vertex(pos + (bottom * width))
#	st.add_vertex(pos + (bottom * width) + v)
#	st.add_vertex(pos)
#	st.add_vertex(pos + (bottom * width) + v)
#	st.add_vertex(pos + v)
#
#func draw_leaf(st: SurfaceTool, v: Vector3) -> void:
#	var pos = cursor_position
#	st.add_color(leaf_color)
#	st.add_vertex(pos)
#	st.add_vertex(pos + v)
#	st.add_vertex(pos + Vector3(v.y, v.x, v.z))
#
#func draw_branches(st: SurfaceTool, pattern, sentence: String) -> void:
#	var rot = 0
#	var stack = []
#	branch_width = 10
#	for c in sentence:
#		if c == 'F':
#			var vertex = Vector3(sin(rot), cos(rot), 0).normalized() * branch_length
#			draw_branch(st, vertex, branch_width)
#			cursor_position += vertex
#		elif c == '[':
#			stack.append({ 'pos': cursor_position, 'rot': rot, 'width': branch_width })
#			branch_width *= branch_width_dropoff
#		elif c == ']':
#			var vertex = Vector3(sin(rot), cos(rot), 0).normalized() * leaf_length
#			draw_leaf(st, vertex)
#			var state = stack.pop_back()
#			cursor_position = state.pos
#			rot = state.rot
#			branch_width = state.width
#		elif c == '+':
#			rot -= pattern.angle
#		elif c == '-':
#			rot += pattern.angle
#		elif c == 'X':
#			pass
#		elif c == 'B':
#			branch_length *= branch_length_dropoff
##			pass
#		elif c == 'W':
#			branch_width *= branch_width_dropoff
##			pass
#		else:
#			push_error('Invalid L-System command: ' + c)
