extends Spatial
onready var gimbal = $Gimbal
onready var camera = $Gimbal/Camera
const move_margin := 20
const move_speed := 30
const ray_length := 1000
var rotate_direction := 0
var x_rotate_direction := 0
var rotation_rate := deg2rad(180.0)
func calculate_movement(m_pos: Vector2, delta: float) -> void:
	var v_size = get_viewport().size
	var move_vec = Vector3.ZERO
#	if m_pos.x < move_margin or Input.is_action_pressed("camera_left"):
#		move_vec.x -= 1
#	if m_pos.y < move_margin or Input.is_action_pressed("camera_forward"):
#		move_vec.z -= 1
#	if m_pos.x > v_size.x - move_margin or Input.is_action_pressed("camera_right"):
#		move_vec.x += 1
#	if m_pos.y > v_size.y - move_margin or Input.is_action_pressed("camera_backward"):
#		move_vec.z += 1
	if Input.is_action_pressed("camera_left"):
		move_vec.x -= 1
	if Input.is_action_pressed("camera_forward"):
		move_vec.z -= 1
	if Input.is_action_pressed("camera_right"):
		move_vec.x += 1
	if Input.is_action_pressed("camera_backward"):
		move_vec.z += 1
	move_vec = move_vec.rotated(Vector3(0, 1, 0), rotation.y)
	global_translate(move_vec * delta * move_speed)
func raycast_from_mouse(m_pos, collision_mask):
	var ray_start = camera.project_ray_origin(m_pos)
	var ray_end = ray_start + camera.project_ray_normal(m_pos) * ray_length
	var space_state = get_world().direct_space_state
	return space_state.intersect_ray(ray_start, ray_end, [], collision_mask)
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_WHEEL_UP:
			camera.fov -= 1.0
		elif event.button_index == BUTTON_WHEEL_DOWN:
			camera.fov += 1.0
func _process(delta: float) -> void:
	var m_pos = get_viewport().get_mouse_position()
	calculate_movement(m_pos, delta)
	if Input.is_action_pressed("rotate_left"):
		rotate_direction = -1
	elif Input.is_action_pressed("rotate_right"):
		rotate_direction = +1
	elif Input.is_action_pressed("rotate_forward"):
		x_rotate_direction = +1
	elif Input.is_action_pressed("rotate_backward"):
		x_rotate_direction = -1
	else:
		rotate_direction = 0
	if Input.is_action_pressed("zoom_in"):
		camera.fov -= 1.0
	elif Input.is_action_pressed("zoom_out"):
		camera.fov += 1.0
	rotate_y(rotate_direction * rotation_rate * delta)


