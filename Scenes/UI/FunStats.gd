extends VBoxContainer

onready var survival_time_count: Label = $TimeSurvived/Count
onready var damage_taken_count: Label = $HealthLost/Count
onready var abilities_used_count: Label = $AbilitiesUsed/Count
onready var jumps_count: Label = $Jumps/Count
onready var footsteps_count: Label = $WalkDist/Count


func _ready() -> void:
	var time : int = round(Globals.run_stats["survival_time"])
	var seconds := time%60
	var minutes := (time/60)%60
	survival_time_count.text = "%d:%02d" % [minutes, seconds]
	damage_taken_count.text = str(floor(Globals.run_stats["damage_taken"]))
	abilities_used_count.text = str(floor(Globals.run_stats["items_used"]))
	jumps_count.text = str(floor(Globals.run_stats["jumps"]))
	footsteps_count.text = str(floor(Globals.run_stats["steps"]))
