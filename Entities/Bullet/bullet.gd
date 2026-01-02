extends Node3D

const MUZZLE_VELOCITY = 400.0  # m/s (1300 fps converted)
const GRAVITY = 9.8  # m/s²
const MAX_RANGE = 50.0  # meters (~55 yards, realistic for clay)

@export var enable_debug_visualization: bool = false
@export var path_point_interval: int = 2

var velocity: Vector3 = Vector3.ZERO
var path_points: Array[Vector3] = []
var _starting_position: Vector3 = Vector3.ZERO


func _ready():
	_starting_position = global_position


func _physics_process(delta):
	if Engine.get_process_frames() % path_point_interval == 0:
		path_points.append(global_position)

	velocity.y -= GRAVITY * delta
	global_position += velocity * delta

	var ray_start = global_position
	var ray_end = global_position + velocity.normalized() * 100.0

	var ray = PhysicsRayQueryParameters3D.create(ray_start, ray_end)
	var result = get_world_3d().direct_space_state.intersect_ray(ray)

	if enable_debug_visualization:
		if result:
			DebugDraw3D.draw_line(ray_start, result.position, Color.RED)
			DebugDraw3D.draw_sphere(result.position, 0.1, Color.YELLOW)
			DebugDraw3D.draw_arrow(
				result.position, result.position + result.normal * 0.5, Color.ORANGE, 0.05
			)
		else:
			DebugDraw3D.draw_line(ray_start, ray_end, Color.CYAN)

		DebugDraw3D.draw_sphere(global_position, 0.05, Color.WHITE)

		if path_points.size() > 1:
			DebugDraw3D.draw_line_path(path_points, Color.AQUA)

	if result:
		print("Hit ", result.collider, " at ", result.position)
		queue_free()

	if _starting_position.distance_to(global_position) > MAX_RANGE:
		queue_free()


func _exit_tree():
	if enable_debug_visualization and path_points.size() > 1:
		DebugDraw3D.draw_line_path(path_points, Color.GREEN, 10.0)
