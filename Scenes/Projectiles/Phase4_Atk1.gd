extends Spatial

export var acceleration := 60.0
export var move_dir := Vector3.RIGHT

var velocity := 0.0
onready var mesh_instance: MeshInstance = $MeshInstance
onready var trail_3d: ImmediateGeometry = $Trail3D


func _ready() -> void:
	scale = Vector3.ZERO
	var tween := create_tween().set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_ELASTIC).tween_property(self, "scale", Vector3.ONE, 0.5)


func _process(delta: float) -> void:
	trail_3d.axe = "X" if move_dir.z > 0.0 else "Z"
	velocity += acceleration * delta
	translation += velocity * move_dir * delta
	mesh_instance.rotate_y(20.0*delta)


func shrink() -> void:
	var tween := create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC).set_parallel()
	tween.tween_property(self, "scale", Vector3.ZERO, 0.5)
	tween.tween_callback(self, "queue_free").set_delay(0.5)


func _on_VisibilityNotifier_camera_exited(camera: Camera) -> void:
	queue_free()
