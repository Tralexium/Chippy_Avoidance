extends Area

export var ring_target_scale := 20.0
export var ring_expand_dur := 3.0
onready var mesh_instance: MeshInstance = $MeshInstance


func _ready() -> void:
	var tween := create_tween().set_ease(Tween.EASE_OUT).set_parallel()
	tween.tween_property(self, "scale", Vector3(ring_target_scale, 0.0, ring_target_scale), ring_expand_dur)
	tween.tween_callback(self, "_fade_out").set_delay(ring_expand_dur - 0.5)
	tween.tween_callback(self, "queue_free").set_delay(ring_expand_dur)


func _fade_out() -> void:
	var tween := create_tween().set_ease(Tween.EASE_IN)
	tween.tween_property(mesh_instance, "material_override:albedo_color:a", 0.0, 0.5)
