extends KinematicBody

export var air_borne_dur := 1.1
export var fall_velocity := 400.0
export var area_radius := 12.0

var velocity := Vector3.ZERO
var aligned := false
var ray_point := Vector3.ZERO

const AREA_SHOCK := preload("res://Scenes/Universal/AreaShock.tscn")

onready var mesh: MeshInstance = $Mesh
onready var warning_beam: Sprite3D = $WarningBeam
onready var collision_shape: CollisionShape = $CollisionShape
onready var ray_cast: RayCast = $RayCast
onready var crosshair: Sprite3D = $Crosshair


func _ready() -> void:
	warning_beam.warning_dur = air_borne_dur
	warning_beam.starting_scale = area_radius * 5.0
	crosshair.warning_dur = air_borne_dur
	crosshair.starting_scale = area_radius
	crosshair.set_as_toplevel(true)
	var tween := create_tween()
	tween.tween_callback(self, "fall").set_delay(air_borne_dur - 0.4)


func _physics_process(delta: float) -> void:
	if !aligned:
		aligned = true
		align_floor_objects()
	var collision = move_and_collide(velocity * delta)
	if collision:
		var area_shock_inst := AREA_SHOCK.instance()
		area_shock_inst.scale.x = area_radius
		area_shock_inst.scale.z = area_radius
		area_shock_inst.translation = ray_point
		get_tree().current_scene.add_child(area_shock_inst)
		queue_free()


func align_floor_objects() -> void:
	ray_point = ray_cast.get_collision_point() + Vector3(0, .1, 0)
	crosshair.global_translation = ray_point


func fall() -> void:
	velocity.y = -fall_velocity


func _on_VisibilityNotifier_camera_exited(camera: Camera) -> void:
	queue_free()
