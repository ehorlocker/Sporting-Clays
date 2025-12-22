extends CharacterBody3D

# -- Movement Params --
@export var walk_speed = 5.0
@export var gravity = 9.8

# -- Look & Feel Params --
@export var mouse_sensitivity = 0.002

# -- Node References --
@onready var head = $Head


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _input(event: InputEvent):
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * mouse_sensitivity)

		var new_rotation_x = head.rotation.x - event.relative.y * mouse_sensitivity
		head.rotation.x = clamp(new_rotation_x, deg_to_rad(-80), deg_to_rad(80))


func _physics_process(delta: float):
	if not is_on_floor():
		velocity.y -= gravity * delta

	var input_dir = Input.get_vector("move_right", "move_left", "move_backward", "move_forward")

	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	if direction:
		velocity.x = direction.x * walk_speed
		velocity.z = direction.z * walk_speed
	else:
		velocity.x = 0.0
		velocity.z = 0.0

	move_and_slide()
