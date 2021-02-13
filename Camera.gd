extends Camera

var SPEED = 10
var SPEED_M = 1.0

var rot_x = 0
var rot_y = 0

const LOOKAROUND_SPEED = 0.01

func _ready():
	print_debug(global_transform.basis.x)
	print_debug(global_transform.basis.y)
	print_debug(global_transform.basis.z)

func _input(event):
	if event is InputEventMouseMotion and Input.is_action_pressed("MouseMove"):
		rot_x += event.relative.x * LOOKAROUND_SPEED
		rot_y += event.relative.y * LOOKAROUND_SPEED
		transform.basis = Basis()
		rotate_object_local(Vector3(0, 1, 0), -rot_x)
		rotate_object_local(Vector3(1, 0, 0), -rot_y)

func _process(delta):
	if Input.is_action_pressed("MouseMove"):
		if (Input.is_action_pressed("move_forward")):
			translation -= global_transform.basis.z * delta * SPEED * SPEED_M
		if (Input.is_action_pressed("moce_backward")):
			translation += global_transform.basis.z * delta * SPEED * SPEED_M
		if (Input.is_action_pressed("move_left")):
			translation -= global_transform.basis.x * delta * SPEED * SPEED_M
		if (Input.is_action_pressed("move_right")):
			translation += global_transform.basis.x * delta * SPEED * SPEED_M
		if (Input.is_action_pressed("move_up")):
			translation += global_transform.basis.y * delta * SPEED * SPEED_M
		if (Input.is_action_pressed("move_down")):
			translation -= global_transform.basis.y * delta * SPEED * SPEED_M
		if (Input.is_action_just_pressed("shift")):
			SPEED_M = 4
		if (Input.is_action_just_released("shift")):
			SPEED_M = 1.0
