extends Spatial

const RING := preload("res://Scenes/Universal/RingShockwave.tscn")

export var rotate_spd := 100.0
onready var smashers: Position3D = $Smashers
onready var spike_ring: MeshInstance = $SpikeRing
onready var animation_player: AnimationPlayer = $AnimationPlayer


func _process(delta: float) -> void:
	smashers.rotation_degrees.y += rotate_spd * delta
	spike_ring.rotation_degrees.y -= rotate_spd * delta


func _on_Timer_timeout() -> void:
	animation_player.play("smash")
	var ring_inst := RING.instance()
	add_child(ring_inst)
