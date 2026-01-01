extends Node3D

@export var bullet_scene: PackedScene
@export var pellet_count: int = 100
@export var spread_angle: float = 15.0  # degrees

@onready var barrel_top = $BarrelEndTop
@onready var barrel_bottom = $BarrelEndBottom


func fire():
	if bullet_scene == null:
		push_error("Bullet scene not assigned to shotgun!")
		return

	var camera = get_viewport().get_camera_3d()
	if camera == null:
		push_error("No camera found!")
		return

	var base_direction = -camera.global_transform.basis.z

	for i in range(pellet_count):
		var bullet = bullet_scene.instantiate()
		get_tree().root.add_child(bullet)
		bullet.global_position = barrel_top.global_position

		var spread_direction = apply_gaussian_spread(base_direction, spread_angle)
		bullet.velocity = spread_direction * bullet.MUZZLE_VELOCITY


func apply_gaussian_spread(direction: Vector3, max_angle_degrees: float) -> Vector3:
	var max_angle_rad = deg_to_rad(max_angle_degrees)
	var sigma = max_angle_rad / 3.0

	var angle_x = RandomUtils.gaussian_fast() * sigma
	var angle_y = RandomUtils.gaussian_fast() * sigma

	angle_x = clamp(angle_x, -max_angle_rad, max_angle_rad)
	angle_y = clamp(angle_y, -max_angle_rad, max_angle_rad)

	var right = direction.cross(Vector3.UP)
	if right.length_squared() < 0.001:
		right = direction.cross(Vector3.FORWARD)
	right = right.normalized()

	var up = direction.cross(right).normalized()

	var spread_dir = direction
	spread_dir = spread_dir.rotated(right, angle_y)
	spread_dir = spread_dir.rotated(up, angle_x)

	return spread_dir.normalized()
