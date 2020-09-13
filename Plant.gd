tool
extends MeshInstance

export (Material) var material setget set_material, get_material
export var generator_seed := -1 setget set_generator_seed
export var trunk_width := 1.0 setget set_trunk_width
export var segment_length := 1.0 setget set_segment_length


var tree = 12


var cursor_position := Vector3.ZERO
var branch_width = 0.3
var branch_width_dropoff = 0.707
var branch_length = 3
var branch_length_dropoff = 0.707
var branch_color = Color(0.55, .27, .075)
var branch_sides = 6

var leaf_color = Color(.133, .55, .133)
var leaf_edge_length = 1

var flower_color := Color(188, 188, 186)

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

func draw_branches(turtle: Turtle, pattern, sentence: String) -> void:
	var current_width = pattern.branch_width
	var current_length = pattern.branch_length
	var dimension_stack = []
	for c in sentence:
		if c == 'F':
			turtle.draw_forward(current_length, current_width, branch_color)
		elif c == '[':
			turtle.save_state()
			dimension_stack.append({
				'width': current_width,
				'length': current_length
			})
		elif c == ']':
			turtle.restore_state()
			var dimensions = dimension_stack.pop_back()
			if (dimensions):
				current_length = dimensions.length
				current_width = dimensions.width
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
		elif c == '!':
			current_width *= pattern.branch_width_dropoff
		elif c == 'L':
			turtle.draw_leaf(pattern.leaf_length, pattern.leaf_angle, pattern.leaf_color)
		elif c == '|':
			turtle.reverse()
		elif c == 'f':
			# draw flower
			turtle.draw_flower(
				pattern.pitch_delta,
				pattern.roll_delta,
				0.1,
				current_width,
				1,
				pattern.yaw_delta,
				branch_color,
				flower_color,
				5
			)
		else:
			pass
