extends Spatial


export var speed := Vector3(12.0, 0.0, 0.0)
export var rot_scale := 0.5
export var lifetime := 3.6
export var target_scale := 1.0

onready var mesh: MeshInstance = $Mesh


func _ready() -> void:
	scale = Vector3.ZERO
	var tween := create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	tween.tween_property(self, "scale", Vector3.ONE * target_scale, 0.5)
	tween.tween_callback(self, "expire").set_delay(lifetime)


func _process(delta: float) -> void:
	translation += speed * delta
	mesh.rotation.z += (speed.length() * rot_scale) * delta * sign(-speed.x - speed.z)


func expire() -> void:
	var tween := create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(self, "scale", Vector3.ZERO, 0.3)
	tween.tween_callback(self, "queue_free").set_delay(0.3)
