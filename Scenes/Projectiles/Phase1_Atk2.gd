extends Spatial

export var target_scale := Vector3.ONE
export var life_time := 3.3

var is_shrunk := false
var elapsed_time := 0.0
onready var mesh: MeshInstance = $MeshInstance
onready var collision_shape: CollisionShape = $Hitbox/CollisionShape


func _ready() -> void:
	scale = Vector3.ZERO
	var tween := create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	tween.tween_property(self, "scale", target_scale, 0.5)


func _process(delta: float) -> void:
	elapsed_time += delta
	if !is_shrunk and elapsed_time >= life_time:
		is_shrunk = true
		shrink()


func shrink() -> void:
	var tween := create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_BACK)
	tween.tween_property(self, "scale", Vector3.ZERO, 0.5)
	tween.tween_callback(self, "queue_free").set_delay(0.5)


func _on_VisibilityNotifier_camera_exited(camera: Camera) -> void:
	queue_free()
