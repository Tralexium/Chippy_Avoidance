extends Spatial

const COIN := preload("res://Scenes/Coin.tscn")


func spawn_coin(position: Vector3, velocity: Vector3, lifetime: float = -1.0) -> void:
	var coin_inst := COIN.instance()
	coin_inst.velocity = velocity
	coin_inst.lifetime = lifetime
	coin_inst.translation = position
	add_child(coin_inst)


func spawn_coin_random_spot(positions: Array, velocity: Vector3, lifetime: float = -1.0) -> void:
	var coin_inst := COIN.instance()
	coin_inst.velocity = velocity
	coin_inst.lifetime = lifetime
	coin_inst.translation = Util.choose(positions)
	add_child(coin_inst)


func spawn_coin_random_offset(random_offset: Vector3, position: Vector3, velocity: Vector3, lifetime: float = -1.0) -> void:
	var coin_inst := COIN.instance()
	coin_inst.velocity = velocity
	coin_inst.lifetime = lifetime
	coin_inst.translation = position
	coin_inst.translation += Vector3(rand_range(random_offset.x, -random_offset.x), \
									 rand_range(random_offset.y, -random_offset.y), \
									 rand_range(random_offset.z, -random_offset.z))
	add_child(coin_inst)
