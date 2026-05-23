extends Resource
class_name Monster_Entity

@export var base_form: Monster_Data
@export var default_form: Monster_Data
@export var active_slots: Array[Monster_Data] = []

# Rookie Progress (progres pemain secara global)
var rookie_lvl: int = 1
var rookie_exp: int = 0
var max_rookie_exp: int = 100
var training_points: int = 0

# Progres per Form: Dictionary[res_path:String -> Dictionary]
# Setiap entry: { "dv_exp": int, "skill_level": int, "is_unlocked": bool }
var form_records: Dictionary = {}

# ==================== INITIALIZATION ====================

func _init():
	pass

func get_record_key(form: Monster_Data) -> String:
	if form == null:
		return ""
	return form.resource_path

func ensure_record(form: Monster_Data) -> Dictionary:
	var key = get_record_key(form)
	if key.is_empty():
		return {}
	if not form_records.has(key):
		form_records[key] = {
			"dv_exp": 0,
			"skill_level": 1,
			"is_unlocked": false
		}
	return form_records[key]

func get_record(form: Monster_Data) -> Dictionary:
	return ensure_record(form)

func get_form_by_key(key: String) -> Monster_Data:
	for form in active_slots:
		if form.resource_path == key:
			return form
	if base_form and base_form.resource_path == key:
		return base_form
	if default_form and default_form.resource_path == key:
		return default_form
	return null

# ==================== EXP / DVEXP DISTRIBUTION ====================

func distribute_battle_rewards(used_forms: Array[Monster_Data], rookie_gain: int, dv_gain: int):
	# 1. Rookie EXP
	rookie_exp += rookie_gain
	_check_rookie_level_up()
	
	# 2. DVEXP dibagi rata ke form yang muncul di battle
	var dv_share = max(1, ceil(dv_gain / max(1, used_forms.size())))
	for form in used_forms:
		var rec = ensure_record(form)
		if rec["is_unlocked"]:
			rec["dv_exp"] += dv_share
			_check_dv_level_up(form, rec)

func _check_rookie_level_up():
	while rookie_exp >= max_rookie_exp:
		rookie_exp -= max_rookie_exp
		rookie_lvl += 1
		max_rookie_exp = int(100 * pow(1.2, rookie_lvl))
		training_points += 5
		print("[MonsterEntity] Rookie level up! Sekarang Level %d, +5 TP (Total: %d)" % [rookie_lvl, training_points])

func _check_dv_level_up(form: Monster_Data, rec: Dictionary):
	var tier = int(form.stats_comp.monster_type) + 1  # Echo=0 -> Tier 1
	var needed = 10  # Default (Tier 1)
	
	match tier:
		2:  # Mythling
			needed = 50 if rec["skill_level"] >= 95 else 10
		3:  # Mythical
			needed = 50 if rec["skill_level"] >= 90 else 10
		4, 5:  # Majestic / Mythos
			needed = 50 if rec["skill_level"] >= 80 else 10
		6:  # Deity
			needed = 50 if rec["skill_level"] >= 60 else 10

	if rec["dv_exp"] >= needed:
		rec["dv_exp"] -= needed
		rec["skill_level"] += 1
		print("[MonsterEntity] Skill level up! %s sekarang Level %d" % [form.name, rec["skill_level"]])

# ==================== UNLOCK CHECK ====================

func check_all_unlocks(pure_stats: Stats_Source):
	# Cek unlock untuk semua form yang ada di active_slots dan base_form
	var all_forms: Array[Monster_Data] = []
	if base_form:
		all_forms.append(base_form)
	all_forms.append_array(active_slots)
	
	for form in all_forms:
		if form == null:
			continue
		var rec = ensure_record(form)
		if rec["is_unlocked"]:
			continue
		if form.evolution_requirements and form.evolution_requirements.size() > 0:
			if _validate_requirements(form.evolution_requirements, pure_stats):
				rec["is_unlocked"] = true
				print("[Unlock] %s terbuka!" % form.name)

func _validate_requirements(reqs: Array[Requirement], pure_stats: Stats_Source) -> bool:
	for req in reqs:
		var stat_name = req.get_stat_name_string().strip_edges()
		var stat_val = pure_stats.get(stat_name)
		if stat_val == null:
			continue
		
		var met = false
		match req.comparison:
			req.CompareOperator.GREATER_THAN:
				met = stat_val > req.value
			req.CompareOperator.LESS_THAN:
				met = stat_val < req.value
			req.CompareOperator.GREATER_EQUAL:
				met = stat_val >= req.value
			req.CompareOperator.LESS_EQUAL:
				met = stat_val <= req.value
			req.CompareOperator.EQUAL:
				met = stat_val == req.value
			
		if not met:
			return false
	return true

# ==================== SLOT MANAGEMENT ====================

func add_to_active_slot(form: Monster_Data) -> bool:
	if form == null:
		return false
	if form in active_slots:
		return false
	if active_slots.size() >= 3:
		return false
	if not ensure_record(form)["is_unlocked"]:
		return false
	active_slots.append(form)
	return true

func remove_from_active_slot(form: Monster_Data) -> bool:
	if form == null:
		return false
	if form not in active_slots:
		return false
	# Tidak bisa remove default_form
	if form == default_form:
		return false
	active_slots.erase(form)
	return true

func set_default_form(form: Monster_Data) -> bool:
	if form in active_slots:
		default_form = form
		return true
	return false

func can_evolve_to(form: Monster_Data) -> bool:
	if form == null:
		return false
	# Cek di active_slots
	if form in active_slots:
		return true
	# Atau base_form (always available)
	if form == base_form:
		return true
	return false

func get_evolve_options(current_form: Monster_Data) -> Array[Monster_Data]:
	var options: Array[Monster_Data] = []
	for form in active_slots:
		if form != current_form:
			options.append(form)
	if base_form and base_form != current_form and base_form not in options:
		options.append(base_form)
	return options