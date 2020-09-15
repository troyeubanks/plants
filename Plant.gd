tool
extends MeshInstance

export (Material) var material setget set_material, get_material
export var generator_seed := -1 setget set_generator_seed
export var trunk_width := 1.0 setget set_trunk_width
export var segment_length := 1.0 setget set_segment_length


export(int, 0, 12) var tree = 12 setget set_tree
func set_tree(t: int):
	tree = t
	generate()


var cursor_position := Vector3.ZERO
export var branch_width = 0.3 setget set_branch_width
func set_branch_width(bw: float):
	branch_width = bw
	generate()
	
export var branch_width_dropoff = 0.707 setget set_branch_width_dropoff
func set_branch_width_dropoff(bwd: float):
	branch_width_dropoff = bwd
	generate()
	
export var branch_length := 3.0 setget set_branch_length
func set_branch_length(bl: float):
	branch_length = bl
	generate()
	
export var branch_length_dropoff := 0.707 setget set_branch_length_dropoff
func set_branch_length_dropoff(bld: float):
	branch_length_dropoff = bld
	generate()
	
export var branch_color := Color(0.55, .27, .075) setget set_branch_color
func set_branch_color(bc: Color):
	branch_color = bc
	generate()
	
export var branch_sides := 6 setget set_branch_sides
func set_branch_sides(bs: int):
	branch_sides = bs
	generate()
	
export(float, 0.0, 1.0) var leaf_spawn_chance := 1.0 setget set_leaf_spawn_chance
func set_leaf_spawn_chance(lsc: float):
	leaf_spawn_chance = lsc
	generate()

export var leaf_color := Color(.133, .55, .133) setget set_leaf_color
func set_leaf_color(lc: Color):
	leaf_color = lc
	generate()
	
export var leaf_edge_length := 1.0 setget set_leaf_edge_length
func set_leaf_edge_length(el: float):
	leaf_edge_length = el
	generate()
	
export(float, 0.0, 1.0) var flower_spawn_chance := 1.0 setget set_flower_spawn_chance
func set_flower_spawn_chance(fsc: float):
	flower_spawn_chance = fsc
	generate()

export var flower_stem_length := 0.05 setget set_flower_stem_length
func set_flower_stem_length(fsl: float):
	flower_stem_length = fsl
	generate()
	
export var flower_petal_length := 0.1 setget set_flower_petal_length
func set_flower_petal_length(fpl: float):
	flower_petal_length = fpl
	generate()
	
export var flower_num_petals := 5 setget set_flower_num_petals
func set_flower_num_petals(fnp: int):
	flower_num_petals = fnp
	generate()

export var flower_color := Color(188, 188, 186) setget set_flower_color
func set_flower_color(fc: Color):
	flower_color = fc
	generate()

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
	print("Ready")
	generate()

func generate() -> void:
	if !is_inside_tree():
		return
		
	print("Generating...")
	if generator_seed == -1:
		randomize()
	else:
		seed(generator_seed)
		
	cursor_position = Vector3.ZERO
	var stem_generator := StemGenerator.new()
	var path_specs = stem_generator.get_path_specs(tree)
	var surface_tool = SurfaceTool.new()
	var turtle = Turtle.new(
		surface_tool, 
		Vector3.UP, 
		Vector3.ZERO, 
		branch_sides
	)
	print("Got our turtle")

	turtle.surface_tool.begin(Mesh.PRIMITIVE_TRIANGLES)
	draw_branches(turtle, path_specs.pattern, path_specs.sentence)
	print("Drew our branches")
	turtle.surface_tool.index()
	turtle.surface_tool.generate_normals()
	mesh = turtle.surface_tool.commit()
	set_surface_material(0, material)
	print("Done")

func draw_branches(turtle: Turtle, pattern, sentence: String) -> void:
	var current_width = branch_width
#	if pattern.has("branch_width"):
#		current_width = pattern.branch_width
	var current_length = branch_length
#	if pattern.has("branch_length"):
#		current_length = pattern.branch_length
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
			if randf() < leaf_spawn_chance:
				var rando = 0.0
				if pattern.has("leaf_length_randomizer"):
					rando = pattern.leaf_length_randomizer
				turtle.draw_leaf(
					pattern.leaf_length * leaf_edge_length * rand_range(1.0 - rando, 1.0),
					pattern.leaf_angle, 
					leaf_color
				)
		elif c == '|':
			turtle.reverse()
		elif c == 'f':
			# draw flower
			if randf() < flower_spawn_chance:
				turtle.draw_flower(
					pattern.pitch_delta,
					pattern.roll_delta,
					flower_stem_length,
					current_width,
					flower_petal_length,
					pattern.yaw_delta,
					branch_color,
					flower_color,
					flower_num_petals
				)
			
#			pitch_angle: float,
#			roll_angle: float,
#			stem_length: float,
#			stem_width: float,
#			petal_length: float,
#			petal_angle: float,
#			stem_color: Color,
#			petal_color: Color,
#			num_petals: float):
		else:
			pass
