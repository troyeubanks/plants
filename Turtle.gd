# Turtle
# A cursor used to draw various 3D paths
class_name Turtle

# private vars
var _heading = Vector3.ZERO
var _up = Vector3.ZERO
var _left = Vector3.ZERO
var _pos = Vector3.ZERO
var _sides = 0
var _state = []

# public vars
var surface_tool: SurfaceTool

func _init(st: SurfaceTool, init_heading: Vector3, pos: Vector3 = Vector3.ZERO, sides: int = 6):
	_sides = sides
	_pos = pos
	surface_tool = st
	if (init_heading == Vector3.ZERO || init_heading == null):
		_heading = Vector3.UP
	else:
		_heading = init_heading.normalized()

	# calculate a perpendicular vector from heading
	# Vx * heading.x + Vy * heading.y + Vz * heading.z = 0
	# sub 1 for y and z, solve for x
	if (_heading.x == 0):
		_left = Vector3.LEFT
	else:
		var vx = ((-1 * _heading.y) - (_heading.z)) / _heading.x
		_left = Vector3(vx, 1, 1).normalized()

	_up = _left.cross(_heading).normalized()

func print_self():
	print('Heading: ', _heading)
	print('Up: ', _up)
	print('Left: ', _left)

# phi should be in rad
func yaw(phi: float) -> void:
	_heading = _heading.rotated(_up, -phi).normalized()
	_left = _left.rotated(_up, -phi).normalized()

func roll(phi: float) -> void:
	_up = _up.rotated(_heading, phi).normalized()
	_left = _left.rotated(_heading, phi).normalized()

func pitch(phi: float) -> void:
	_heading = _heading.rotated(_left, -phi).normalized()
	_up = _up.rotated(_left, -phi).normalized()

func reverse():
	_heading *= -1
	_left *= -1

func set_pos(new_pos: Vector3):
	_pos = new_pos

func save_state():
	_state.append({
		'heading': _heading,
		'up': _up,
		'left': _left,
		'pos': _pos
	})

func restore_state():
	var prev_state = _state.pop_back()
	if (prev_state):
		_heading = prev_state.heading
		_up = prev_state.up
		_left = prev_state.left
		_pos = prev_state.pos

func move_forward(distance: float):
	var v = distance * _heading.normalized()
	set_pos(_pos + distance * v)

func draw_forward(distance: float, width: float, color: Color):
	var phi = 2 * PI / _sides
	var v = distance * _heading.normalized()
	var radius = width * _left.normalized()
	surface_tool.add_color(color)

	for i in range(_sides):
		var a = _pos + radius.rotated(_heading, i * phi)
		var b = _pos + radius.rotated(_heading, (i + 1) * phi)
#		surface_tool.add_vertex(pos) 		# base
#		surface_tool.add_vertex(a)
#		surface_tool.add_vertex(b)
		surface_tool.add_vertex(a)			# side 1
		surface_tool.add_vertex(b + v)
		surface_tool.add_vertex(b)
		surface_tool.add_vertex(a)			# side 2
		surface_tool.add_vertex(a + v)
		surface_tool.add_vertex(b + v)
#		surface_tool.add_vertex(pos + v)	# top
#		surface_tool.add_vertex(b + v)
#		surface_tool.add_vertex(a + v)
	set_pos(_pos + v)

# theta is angle, in radians, from stem
# length is segment length, of which there are three
func draw_leaf(length: float, theta: float, color: Color) -> void:
	# save to reset after drawing
	save_state()
	surface_tool.add_color(color)

	# base of leaf
	var initial_pos = _pos
	pitch(2 * theta)

	# left side of leaf
	surface_tool.add_vertex(initial_pos)
	yaw(theta)
	move_forward(length)
	surface_tool.add_vertex(_pos)
	yaw(-theta)
	move_forward(length * 2)
	surface_tool.add_vertex(_pos)
	surface_tool.add_vertex(initial_pos)
	surface_tool.add_vertex(_pos)
	yaw(-theta)
	move_forward(length)
	surface_tool.add_vertex(_pos)
	yaw(theta)

	# right side of leaf
	surface_tool.add_vertex(initial_pos)
	surface_tool.add_vertex(_pos)
	reverse()
	yaw(theta)
	move_forward(length)
	surface_tool.add_vertex(_pos)
	surface_tool.add_vertex(initial_pos)
	surface_tool.add_vertex(_pos)
	yaw(-theta)
	move_forward(length * 2)
	surface_tool.add_vertex(_pos)

	# reset state after drawing
	restore_state()

# pitch_delta should be in radians
# angle is from centerline of petal
# length is length of segment
func draw_flower_petal(angle: float, length: float, pitch_delta: float, color: Color):
	save_state()
	surface_tool.add_color(color)

	pitch(4 * pitch_delta)
	surface_tool.add_vertex(_pos)
	yaw(-angle)
	move_forward(length)
	surface_tool.add_vertex(_pos)
	yaw(angle)
	move_forward(length)
	surface_tool.add_vertex(_pos)

	reverse()

	surface_tool.add_vertex(_pos)
	yaw(-angle)
	move_forward(length)
	surface_tool.add_vertex(_pos)
	yaw(angle)
	move_forward(length)
	surface_tool.add_vertex(_pos)

	restore_state()

#	flower → [&&& pedicel ‘ / wedge //// wedge ////
#	wedge //// wedge //// wedge ]
#	pedicel → FF
#	wedge → [‘ ∧ F][ { &&&& −f+f | −f+f } ]
func draw_flower(
	pitch_angle: float,
	roll_angle: float,
	stem_length: float,
	stem_width: float,
	petal_length: float,
	petal_angle: float,
	stem_color: Color,
	petal_color: Color):
		save_state()

		pitch(3 * pitch_angle)
		draw_forward(2 * stem_length, stem_width, stem_color)

		roll(roll_angle)
		draw_flower_petal(petal_angle, petal_length, pitch_angle, petal_color)
		for i in range(5):
			roll(4 * roll_angle)
			draw_flower_petal(petal_angle, petal_length, pitch_angle, petal_color)
		restore_state()
