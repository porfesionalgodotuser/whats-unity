extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 0
const ACCELERATION = 15.0
const FRICTION = 10.0
const GRAVITY_MULTIPLIER = 1.0
const CAMERA_DISTANCE = 5.0
const CAMERA_HEIGHT = 2.5
const CAMERA_SMOOTHING = 0.8

@onready var ball_mesh := $MeshInstance3D
@onready var camera := $Camera3D

var ball_radius: float
var camera_yaw := 0.0

func _ready() -> void:
	var aabb: AABB = ball_mesh.get_aabb()
	ball_radius = aabb.size.x / 2.0

func _physics_process(delta: float) -> void:
	# 1. Apply Gravity (Always happens)
	if not is_on_floor():
		velocity += get_gravity() * GRAVITY_MULTIPLIER * delta

	# 2. Get Input Direction
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var cam_basis := Basis(Vector3.UP, camera_yaw)
	var direction := (cam_basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	# 3. MOVEMENT LOGIC (Moved outside is_on_floor)
	if direction:
		velocity.x = move_toward(velocity.x, direction.x * SPEED, ACCELERATION * delta)
		velocity.z = move_toward(velocity.z, direction.z * SPEED, ACCELERATION * delta)
	else:
		# Apply friction/slope logic
		if is_on_floor():
			var floor_normal := get_floor_normal()
			velocity.x += floor_normal.x * 9.8 * delta
			velocity.z += floor_normal.z * 9.8 * delta
		
		velocity.x = move_toward(velocity.x, 0, FRICTION * delta)
		velocity.z = move_toward(velocity.z, 0, FRICTION * delta)

	# 4. Execute Movement
	move_and_slide()

	# Roll the ball based on horizontal velocity
	var horizontal_velocity := Vector3(velocity.x, 0, velocity.z)
	if horizontal_velocity.length() > 0.01:
		var roll_axis := Vector3(velocity.z, 0, -velocity.x).normalized()
		var roll_angle := horizontal_velocity.length() * delta / ball_radius
		ball_mesh.rotate(roll_axis, roll_angle)

		# Very lazily drift camera behind ball
		var target_yaw := atan2(-velocity.x, -velocity.z)
		var angle_diff := wrapf(target_yaw - camera_yaw, -PI, PI)
		camera_yaw += angle_diff * CAMERA_SMOOTHING * delta

	var cam_x := sin(camera_yaw) * CAMERA_DISTANCE
	var cam_z := cos(camera_yaw) * CAMERA_DISTANCE
	camera.position = Vector3(cam_x, CAMERA_HEIGHT, cam_z)
	camera.look_at(global_position, Vector3.UP)
