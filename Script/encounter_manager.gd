extends Node
class_name EncounterManager

signal encounter_triggered(enemy_group: Array[Monster_Data])
@export var monster_group: Array[Monster_Data]
@export var more_encounter_rate:float 
@export var default_encounter_rate: float 
var encounter_rate:float
@export var step_threshold: int 

var step_counter: int = 0

func _ready():
	encounter_rate = default_encounter_rate

func register_step():
	step_counter += 1
	if step_counter >= step_threshold:
		step_counter = 0
		if randf() < default_encounter_rate:
			_trigger_random_encounter()
			encounter_rate = default_encounter_rate
		else:
			encounter_rate = min(1.0, encounter_rate + more_encounter_rate)

func _trigger_random_encounter():
	var enemies = _generate_enemy_group()
	encounter_triggered.emit(enemies)

func _generate_enemy_group() -> Array[Monster_Data]:
	# Return array of enemy IDs to spawn
	return monster_group
