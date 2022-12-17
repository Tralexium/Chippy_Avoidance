extends Path

const ORB := preload("res://Scenes/Universal/PathOrb.tscn")
const PLATFORM := preload("res://Scenes/Universal/Platform.tscn")

export var platforms := 1
export var move_speed := 0.1
export var dot_frequency := 2.0
onready var dots: Position3D = $Dots


func _ready() -> void:
	_spawn_path_dots()
	_spawn_platforms()


func _spawn_path_dots() -> void:
	var count := 0
	var repeats := ceil(curve.get_baked_length() / dot_frequency)
	for dot in repeats:
		var pos := curve.interpolate_baked(dot * dot_frequency)
		var small_dot_mesh : Sprite3D = ORB.instance()
		small_dot_mesh.pixel_size = 0.001
		small_dot_mesh.translation = pos
		dots.add_child(small_dot_mesh)
		count += 1
	for corner in curve.get_point_count():
		var pos := curve.get_point_position(corner)
		var large_dot_mesh : Sprite3D = ORB.instance()
		large_dot_mesh.pixel_size = 0.002
		large_dot_mesh.translation = pos
		large_dot_mesh.render_priority = 1
		dots.add_child(large_dot_mesh)


func _spawn_platforms() -> void:
	for i in range(platforms):
		var platform_inst := PLATFORM.instance()
		var path_follower := PathFollow.new()
		path_follower.add_child(platform_inst)
		add_child(path_follower)
		path_follower.unit_offset = float(i) / float(platforms)
		path_follower.rotation_mode = PathFollow.ROTATION_NONE


func _physics_process(delta: float) -> void:
	for platform in get_children():
		if platform.name == "Dots":
			continue
		platform.unit_offset += move_speed * delta
