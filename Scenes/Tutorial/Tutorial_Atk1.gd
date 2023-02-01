extends Spatial

export var speed := Vector3(12.0, 0.0, 0.0)
export var rot_scale := 0.5
export var lifetime := 3.5
export var target_scale := 1.0

onready var mesh: MeshInstance = $Mesh
onready var collision_shape: CollisionShape = $Hitbox/CollisionShape
onready var lifetime_timer: Timer = $Lifetime


func _ready() -> void:
	scale = Vector3.ZERO
	var tween := create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	tween.tween_property(self, "scale", Vector3.ONE * target_scale, 0.5)
	lifetime_timer.start(lifetime)


func _process(delta: float) -> void:
	translation += speed * delta
	mesh.rotation.z += (speed.length() * rot_scale) * delta * sign(-speed.x - speed.z)


func shrink() -> void:
	collision_shape.disabled = true
	var tween := create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(mesh, "scale", Vector3.ZERO, 0.3)
	tween.tween_callback(self, "queue_free").set_delay(0.3)


func _on_Lifetime_timeout() -> void:
	shrink()
