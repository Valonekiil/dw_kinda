extends Node
class_name Evolution_Manager

# Signals
signal form_changed(new_form: Monster_Data)
signal unlock_discovered(form_name: String)

# Reference ke Monster_Entity (single source of truth untuk save/load)
@export var entity: Monster_Entity

# Reference ke controller active (diset otomatis saat init)
var controller: Monster_Controller

# Form yang muncul di battle ini (untuk distribusi DVEXP post-battle)
var used_in_battle: Array[Monster_Data] = []

# ==================== BATTLE TRACKING ====================

func track_form_used(form: Monster_Data):
	if form and form not in used_in_battle:
		used_in_battle.append(form)
		print("[EvoManager] Track form used: %s" % form.name)

# ==================== POST-BATTLE PROCESSING ====================

func process_post_battle(rookie_exp: int, dv_exp: int):
	if not entity:
		push_warning("[EvoManager] Entity tidak diset, tidak bisa proses post-battle")
		return
	
	# Dapatkan pure stats untuk unlock check (dari base_form)
	var pure_stats = _get_pure_stats_from_entity()
	
	# Distribusi reward ke entity
	entity.distribute_battle_rewards(used_in_battle, rookie_exp, dv_exp)
	
	# Cek unlock setelah distribusi
	if pure_stats:
		entity.check_all_unlocks(pure_stats)
	
	# Reset tracking
	used_in_battle.clear()
	print("[EvoManager] Post-battle processing selesai")

# ==================== EVOLVE ====================

func try_evolve_to(target: Monster_Data) -> bool:
	if not entity or not controller:
		push_warning("[EvoManager] Entity atau controller null")
		return false
	
	if not entity.can_evolve_to(target):
		print("[EvoManager] %s tidak ada di active_slots" % target.name)
		return false
	
	# Cek MP
	if controller.stats.cur_mana < target.evolution_mp_cost:
		print("[EvoManager] MP tidak cukup! Butuh %d, punya %d" % [target.evolution_mp_cost, controller.stats.cur_mana])
		return false
	
	# Kurangi MP
	controller.stats.cur_mana -= target.evolution_mp_cost
	
	# Panggil evolve_to di controller (parent)
	controller.evolve_to(target)
	
	# Update default_form
	entity.default_form = target
	
	# Track form yang digunakan
	track_form_used(target)
	
	# Emit signal
	form_changed.emit(target)
	print("[EvoManager] Evolve ke %s berhasil!" % target.name)
	return true

# ==================== GETTERS ====================

func get_active_forms() -> Array[Monster_Data]:
	if not entity:
		return []
	var forms: Array[Monster_Data] = []
	# Base form selalu available
	if entity.base_form:
		forms.append(entity.base_form)
	# Active slots
	forms.append_array(entity.active_slots)
	return forms

func get_default_form() -> Monster_Data:
	return entity.default_form if entity else null

func get_current_form_index(current: Monster_Data) -> int:
	var forms = get_active_forms()
	return forms.find(current)

func can_evolve() -> bool:
	# Cek apakah ada form lain selain current yang tersedia
	if not controller or not entity:
		return false
	var forms = get_active_forms()
	for f in forms:
		if f != controller.monster and entity.can_evolve_to(f):
			return true
	return false

# ==================== HELPERS ====================

func _get_pure_stats_from_entity() -> Stats_Source:
	if entity and entity.base_form and entity.base_form.stats_comp:
		return entity.base_form.stats_comp.duplicate()
	if entity and entity.default_form and entity.default_form.stats_comp:
		return entity.default_form.stats_comp.duplicate()
	return null