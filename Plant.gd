tool
extends MeshInstance

export (Material) var material setget set_material, get_material
export var generator_seed := -1 setget set_generator_seed
export var trunk_width := 1.0 setget set_trunk_width
export var segment_length := 1.0 setget set_segment_length


var tree = 2


var cursor_position := Vector3.ZERO
var branch_width = 0.2
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
	var path_specs = stem_generator.get_path_specs(tree)
	var surface_tool = SurfaceTool.new()

	var turtle = Turtle.new(surface_tool, Vector3.UP)

	turtle.surface_tool.begin(Mesh.PRIMITIVE_TRIANGLES)
	draw_branches(turtle, path_specs.pattern, path_specs.sentence)
	turtle.surface_tool.index()
	turtle.surface_tool.generate_normals()
	mesh = turtle.surface_tool.commit()
	set_surface_material(0, material)

func draw_leaf(st: SurfaceTool) -> void:
	var pos = cursor_position
	st.add_color(leaf_color)
	st.add_vertex(pos)
	st.add_vertex(pos + Vector3(-1, 1, 1))
	st.add_vertex(pos + Vector3(1, 1, 1))


#	[’’’∧∧{-f+f+f-|-f+f+f}]
#	st.add_vertex(pos)
#	st.add_vertex(pos + v)
#	st.add_vertex(pos + Vector3(v.y, v.x, v.z))

func draw_branches(turtle: Turtle, pattern, sentence: String) -> void:
	for c in sentence:
		if c == 'F':
			turtle.draw_forward(branch_length, branch_width, branch_color)
		elif c == '[':
			turtle.save_state()
		elif c == ']':
			turtle.restore_state()
		elif c == '+':
			turtle.yaw(pattern.yaw_delta)
		elif c == '-':
			turtle.yaw(-pattern.yaw_delta)
		elif c == '&':
			turtle.pitch(pattern.pitch_delta)
		elif c == '^':
			turtle.pitch(-pattern.pitch_delta)
		elif c == '\\':
			turtle.roll(-pattern.roll_delta)
		elif c == '/':
			turtle.roll(pattern.roll_delta)
		elif c == 'X':
			pass
		elif c == '!':
			branch_width *= branch_width_dropoff
			pass
		elif c == 'L':
#			draw_leaf(st)
			pass
		elif c == '|':
			turtle.reverse()
		elif c == 'f':
			# move forward without drawing
			pass
		elif c == 'S':
			pass
		else:
			push_error('Invalid L-System command: ' + c)
