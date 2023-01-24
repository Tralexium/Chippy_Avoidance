extends Node

# Music
const MAIN_MENU := preload("res://Scenes/UI/MainMenu.tscn")
const AVOIDANCE := preload("res://Scenes/Avoidance.tscn")
const MAIN_MENU_MUSIC := preload("res://Audio/Music/Mittsies - Horizon.ogg")
const AVOIDANCE_MUSIC := preload("res://Audio/Music/aran_EPHMR.ogg")
const TUTORIAL_MUSIC := preload("res://Audio/Music/Tutorial - Unreal_Tournament_Forgone_Rejuvenation_OC_ReMix.ogg")
# General Sounds
const UI_ERROR := preload("res://Audio/SFX/ui_error.wav")
const UI_SUCCESS := preload("res://Audio/SFX/ui_success.wav")
const UI_BUTTON := preload("res://Audio/SFX/ui_button.wav")
const UI_BACK := preload("res://Audio/SFX/ui_back.wav")
const UI_OFF := preload("res://Audio/SFX/ui_toggle_off.wav")
const UI_ON := preload("res://Audio/SFX/ui_toggle_on.wav")


enum TIMELINE_EVENTS {
	ITEM_1, ITEM_2, ITEM_3, ITEM_4,
	DEATH, DAMAGE,
}

enum ABILITIES {
	SUPER_SPEED, MEGA_JUMP, SHIELD, SLO_MO
}

var debug_mode := true
var god_mode := false
var can_pause := false

var timeline_events := []
var run_stats := {
	"survival_time": 0.0,
	"unit_survival_time": 0.0,
	"damage_taken": 0.0,
	"items_used": 0.0,
	"jumps": 0.0,
	"steps": 0.0,
}


func reset_run_stats() -> void:
	timeline_events.clear()
	for stat in run_stats.keys():
		run_stats[stat] = 0.0
