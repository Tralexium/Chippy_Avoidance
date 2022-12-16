extends MeshInstance

export var sky_col = Color("f1ccff")
export var horizon_col = Color("8df7f2")
export var ground_col = Color("81aaea")
export var pit_col = Color("140a2a")


func _ready() -> void:
	scale = Vector3.ONE * 2.0


func change_skybox_colors(_sky_col: Color, _horizon_col: Color, _ground_col: Color, _pit_col: Color, duration: float):
	if duration > 0.0:
		var tween = create_tween().set_trans(Tween.TRANS_LINEAR).set_parallel()
		tween.tween_property(self, "sky_col", _sky_col, duration)
		tween.tween_property(self, "horizon_col", _horizon_col, duration)
		tween.tween_property(self, "ground_col", _ground_col, duration)
		tween.tween_property(self, "pit_col", _pit_col, duration)
	else:
		sky_col = _sky_col
		horizon_col = _horizon_col
		ground_col = _ground_col
		pit_col = _pit_col


func _process(delta: float) -> void:
	material_override.set_shader_param("sky_col", sky_col)
	material_override.set_shader_param("horizon_col", horizon_col)
	material_override.set_shader_param("ground_col", ground_col)
	material_override.set_shader_param("pit_col", pit_col)
