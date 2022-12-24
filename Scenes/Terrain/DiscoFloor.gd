extends MultiMeshInstance

export(Gradient) var color_gradient
export(int) var disco_floor_size := 40
export(float, 0, 1) var intensity := 1.0
export(float, 0, 1) var gradient_spd := 0.2
export(float) var tile_margin := 6.0
export(float) var opacity := 1.0
export(float) var max_cycle_offset := 0.1

var tile_alphas : Array
var timer := 0.0


func _ready() -> void:
	multimesh.instance_count = disco_floor_size*disco_floor_size
	var i := 0
	for x in range(disco_floor_size/-2, disco_floor_size/2):
		for z in range(disco_floor_size/-2, disco_floor_size/2):
			var _x_offset = x * tile_margin
			var _z_offset = z * tile_margin
			multimesh.set_instance_transform(i, Transform(Basis(), Vector3(_x_offset, 0, _z_offset)))
			
			tile_alphas.append(
				max(pow(cos(PI*x / float(disco_floor_size)), 1.5), 0.0) * max(pow(cos(PI*z / float(disco_floor_size)), 1.5), 0.0)
			)
			i += 1


func _process(delta: float) -> void:
	timer += delta*gradient_spd
	for i in multimesh.instance_count:
		seed(i)
		var _rand_cycle_offset : float = randf() * max_cycle_offset
		
		var _offset : float = fmod((timer + _rand_cycle_offset), 1.0)
		var _gradient_col : Color = color_gradient.interpolate(_offset)
		_gradient_col.a = opacity * tile_alphas[i]
		multimesh.set_instance_color(i, _gradient_col)
		multimesh.set_instance_custom_data(i, Color(float(i % disco_floor_size), float(floor(i / disco_floor_size)), float(disco_floor_size), intensity))  # pass the intensity
