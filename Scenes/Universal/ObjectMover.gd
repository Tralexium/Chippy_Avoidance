extends Path

export(Array, NodePath) var nodes := []
export(Curve) var ease_curve : Curve
export var path_duration := 1.0

var curve_weight := 0.0 
var tween : SceneTreeTween
onready var path_follow: PathFollow = $PathFollow


func start() -> void:
	tween = create_tween().set_trans(Tween.TRANS_LINEAR)
	tween.tween_property(self, "curve_weight", 1.0, path_duration)


func _process(delta: float) -> void:
	path_follow.unit_offset = ease_curve.interpolate(curve_weight)
	if tween != null and tween.is_running():
		_move_assigned_nodes()


func _move_assigned_nodes() -> void:
	for node_path in nodes:
		var node := get_node(node_path)
		if node == null or not node is Spatial:
			continue
		node.global_translation = path_follow.global_translation
