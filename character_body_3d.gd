extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 0

@onready var ball_mesh := $MeshInstance3D 

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()

	var horizontal_velocity := Vector3(velocity.x, 0, velocity.z)
	if horizontal_velocity.length() > 0.01:
		var roll_axis := Vector3(velocity.z, 0, -velocity.x).normalized()
		var ball_radius := 0.5
		var roll_angle := horizontal_velocity.length() * delta / ball_radius
		ball_mesh.rotate(roll_axis, roll_angle)
