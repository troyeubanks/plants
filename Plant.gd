tool
extends MeshInstance

export (Material) var material setget set_material, get_material
export var generator_seed := -1 setget set_generator_seed
export var trunk_width := 1.0 setget set_trunk_width
export var segment_length := 1.0 setget set_segment_length

var cursor_position := Vector3.ZERO
var branch_width = 0.5
var branch_width_dropoff = 0.707
var branch_length = 1
var branch_length_dropoff = 0.707
var branch_color = Color(0.55, .27, .075)
var branch_sides = 6

var leaf_color = Color(.133, .55, .133)
var leaf_length = 3

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
	if generator_seed == -1:
		generator_seed = randi()
	generate()

func generate() -> void:
	cursor_position = Vector3.ZERO
	var stem_generator := StemGenerator.new()
	var path_specs = stem_generator.get_path_specs(0)
#	print(path_specs.sentence)
	var surface_tool = SurfaceTool.new()
	surface_tool.begin(Mesh.PRIMITIVE_TRIANGLES)
	surface_tool.add_color(branch_color)
	draw_branches(surface_tool, path_specs.pattern, path_specs.sentence)
	surface_tool.index()
	surface_tool.generate_normals()
	mesh = surface_tool.commit()
	set_surface_material(0, material)

func draw_branch(st: SurfaceTool, v: Vector3, width: float) -> void:
	var base_vertex = v.cross(Vector3.FORWARD).normalized() * branch_width
	var bottom = v.cross(Vector3.FORWARD).normalized()
	var pos = cursor_position
	var phi = (360 / branch_sides) * PI / 180
	st.add_color(branch_color)

	for i in range(branch_sides):
		var a = pos + base_vertex.rotated(v.normalized(), i * phi)
		var b = pos + base_vertex.rotated(v.normalized(), (i + 1) * phi)
		st.add_vertex(pos) 		# base
		st.add_vertex(a)
		st.add_vertex(b)
		st.add_vertex(a)			# side 1
		st.add_vertex(b + v)
		st.add_vertex(b)
		st.add_vertex(a)			# side 2
		st.add_vertex(a + v)
		st.add_vertex(b + v)
		st.add_vertex(pos + v)	# top
		st.add_vertex(b + v)
		st.add_vertex(a + v)

func draw_leaf(st: SurfaceTool) -> void:
	var pos = cursor_position
	st.add_color(leaf_color)
	st.add_vertex(pos)
	st.add_vertex(pos + Vector3(0.2, 0.2, 0.2))
	st.add_vertex(pos + Vector3(0.5, 0.5, 0.5))
#	st.add_vertex(pos)
#	st.add_vertex(pos + v)
#	st.add_vertex(pos + Vector3(v.y, v.x, v.z))

func draw_branches(st: SurfaceTool, pattern, sentence: String) -> void:
	var rot = 0
	var facing = 0
	var heading = Vector3.UP
	var stack = []
	for c in sentence:
		if c == 'F':
			var vertex = heading.normalized() * branch_length
			draw_branch(st, vertex, branch_width)
			cursor_position += vertex
		elif c == '[':
			stack.append({ 'pos': cursor_position, 'width': branch_width, 'heading': heading })
		elif c == ']':
#			var vertex = Vector3(sin(rot), cos(rot), 0).normalized() * leaf_length
#			draw_leaf(st, vertex)
			var state = stack.pop_back()
			cursor_position = state.pos
			branch_width = state.width
			heading = state.heading
		elif c == '+':
			var f = Vector3.RIGHT.rotated(Vector3.UP, facing)
			var cross = heading.cross(f).normalized()
			heading = heading.rotated(cross, pattern.angle)
		elif c == '-':
			var f = Vector3.RIGHT.rotated(Vector3.UP, facing)
			var cross = heading.cross(f).normalized()
			heading = heading.rotated(cross, -1 * pattern.angle)
		elif c == 'X':
			pass
		elif c == '!':
			# decrement branch width
			branch_width *= branch_width_dropoff
			pass
		elif c == 'L':
			draw_leaf(st)
			pass
		elif c == '|':
			heading *= -1
			pass
		elif c == 'f':
			# move forward without drawing
			pass
		elif c == '\\':
			heading = heading.rotated(Vector3.UP, -1 * pattern.facing_delta)
			pass
		elif c == '/':
			heading = heading.rotated(Vector3.UP, pattern.facing_delta)
			# rotate positively around trunk/heading
			pass
		elif c == 'S':
			pass
		else:
			push_error('Invalid L-System command: ' + c)
