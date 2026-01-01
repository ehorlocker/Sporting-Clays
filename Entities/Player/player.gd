extends CharacterBody3D

# -- Movement Params --
@export var walk_speed = 5.0
@export var gravity = 9.8

# -- Look & Feel Params --
@export var mouse_sensitivity = 0.002

# -- Node References --
@onready var camera = $fp_arms_low_poly/arms_root/Skeleton3D/BoneAttachment3D/Camera3D
@onready var arms = $fp_arms_low_poly
@onready var shotgun = $fp_arms_low_poly/shotgun


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _input(event: InputEvent):
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * mouse_sensitivity)

		var new_rotation_x = arms.rotation.x + event.relative.y * mouse_sensitivity
		arms.rotation.x = clamp(new_rotation_x, deg_to_rad(-80), deg_to_rad(80))

	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			shotgun.fire()


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
