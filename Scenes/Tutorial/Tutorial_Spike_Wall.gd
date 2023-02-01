extends Spatial

export var phase := -1
export var speed := Vector3(12.0, 0.0, 0.0)
onready var spikes: Position3D = $Spikes
onready var tutorial_phase_clear_area: Area = $Spikes/BottomSpikes/TutorialPhaseClearArea


func _ready() -> void:
	for spike in spikes.get_children():
		spike.speed = speed
		spike.lifetime_timer.start(10.0)
	tutorial_phase_clear_area.phase = phase


func _on_TutorialPhaseClearArea_body_entered(body: Node) -> void:
	for spike in spikes.get_children():
		spike.shrink()
