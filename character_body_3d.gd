extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 0
const ACCELERATION = 15.0
const FRICTION = 15.0
const GRAVITY_MULTIPLIER = 1.0
const CAMERA_DISTANCE = 5.0
const CAMERA_HEIGHT = 2.5
const CAMERA_SMOOTHING = 1
const BALL_SCALE = 0.5

@onready var ball_mesh := $MeshInstance3D
@onready var camera := $Camera3D

const DEATH_Y := -20.0

var ball_radius: float
var camera_yaw := 0.0
var ball_rotation := Quaternion.IDENTITY
var spawn_position: Vector3

func _ready() -> void:
	spawn_position = global_position
	ball_mesh.scale = Vector3(BALL_SCALE, BALL_SCALE, BALL_SCALE)
	var aabb: AABB = ball_mesh.get_aabb()
	ball_radius = (aabb.size.x * BALL_SCALE) / 2.0

func _physics_process(delta: float) -> void:
	# 1. Apply Gravity
	if not is_on_floor():
		velocity += get_gravity() * GRAVITY_MULTIPLIER * delta

	# 2. Get Input Direction
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var cam_basis := Basis(Vector3.UP, camera_yaw)
	var direction := (cam_basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	# 3. Movement Logic
	if direction:
		velocity.x = move_toward(velocity.x, direction.x * SPEED, ACCELERATION * delta)
		velocity.z = move_toward(velocity.z, direction.z * SPEED, ACCELERATION * delta)
	else:
		if is_on_floor():
			var floor_normal := get_floor_normal()
			var gravity_vec := get_gravity() * GRAVITY_MULTIPLIER
			var slope_force := gravity_vec - floor_normal * gravity_vec.dot(floor_normal)
			velocity += slope_force * delta
			velocity.x = move_toward(velocity.x, 0, FRICTION * 0.1 * delta)
			velocity.z = move_toward(velocity.z, 0, FRICTION * 0.1 * delta)

	# 4. Execute Movement
	move_and_slide()

	# 5. Roll the ball using quaternion accumulation
	var horizontal_velocity := Vector3(velocity.x, 0, velocity.z)
	if horizontal_velocity.length() > 0.01:
		var roll_axis: Vector3 = Vector3(velocity.z, 0, -velocity.x).normalized()
		var roll_angle: float = horizontal_velocity.length() * delta / ball_radius
		var delta_rotation := Quaternion(roll_axis, roll_angle)
		ball_rotation = (delta_rotation * ball_rotation).normalized()
		# FIX: preserve scale when applying rotation
		ball_mesh.transform.basis = Basis(ball_rotation).scaled(Vector3(BALL_SCALE, BALL_SCALE, BALL_SCALE))

		# Lazily drift camera behind ball
		var target_yaw := atan2(-velocity.x, -velocity.z)
		var angle_diff := wrapf(target_yaw - camera_yaw, -PI, PI)
		camera_yaw += angle_diff * CAMERA_SMOOTHING * delta

	# 6. Death check
	if global_position.y < DEATH_Y:
		global_position = spawn_position
		velocity = Vector3.ZERO
		camera_yaw = 0.0
		ball_rotation = Quaternion.IDENTITY

	# 7. Update camera
	camera.position = Vector3(sin(camera_yaw) * CAMERA_DISTANCE, CAMERA_HEIGHT, cos(camera_yaw) * CAMERA_DISTANCE)
	camera.look_at(global_position, Vector3.UP)
