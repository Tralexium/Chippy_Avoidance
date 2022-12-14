extends Spatial

export var energy := 1.2
export var spotlight_col := Color("ced8ff")
export var ground_col := Color("ced8ff")


func _process(delta: float) -> void:
	for light in get_children():
		light.light_energy = energy
		if light.name == "SpotLight":
			light.light_color = spotlight_col
		else:
			light.light_color = ground_col
