extends Node
class_name Evolution_Manager

@export var evolution_chain: Array[Monster_Data]  # [Base, Evo1, Evo2]
@export var controller: Monster_Controller  # Referensi ke controller aktif
var current_stage: int = 0
var is_evolved:bool

func can_evolve() -> bool:
	return current_stage < evolution_chain.size() - 1

func trigger_evolution() -> void:
	if not can_evolve() or controller == null:
		push_warning("Evolusi tidak valid atau controller null")
		return

	current_stage += 1
	is_evolved = true
	var next_form = evolution_chain[current_stage]
	controller.evolve_to(next_form)

func back_to_base_form():
	if evolution_chain.size() > 0 and controller:
		current_stage = 0
		is_evolved = false
		controller.evolve_to(evolution_chain[0])