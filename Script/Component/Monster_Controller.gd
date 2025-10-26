extends Node2D
class_name Monster_Controller

@export var monster:Monster_Data
@export var stats_comp: Stats_Component
var stats:Stats_Source
var basestats:Stats_Source
@export var skill_comp: Skill_Component
@export var atk_modifiers: Atk_Modifier_Component
@export var buff_manager: Buff_Manager
@export var evolution_manager: Evolution_Manager
@export var AI_Advanced:Enemy_Comp
@export var sprite:Sprite2D
@export var sprite_skill:Sprite2D
@export var Anim:AnimationPlayer
@export var attack_hitbox: Area2D
@export var hurtbox: Area2D
var hp_bar:ProgressBar
var hp_txt:Label
@export var AI:bool
var action_point:int 
var is_defense:bool
var bar:ProgressBar
var txt:Label
# Signal untuk mengirim damage dan mengakhiri giliran
signal attack_completed(damage: int, buff:Variant)
signal skill_completed(skill:SkillData, buff:Variant)
signal defense_completed(defense:int)
signal buff_added(buff:Buff_Data)
signal done_init()
signal buff_done_add()
signal done_buff()
signal turn_ended()

#func _ready():
	#hurtbox.area_entered.connect(_on_hurtbox_hit)
	#attack_hitbox.collision_mask = 0b0010  # Mask: Layer 2 (hurtboxes)
	#hurtbox.collision_layer = 0b0010       # Layer: 2 (hurtbox)

func init(hp_bar:ProgressBar, hp_num:Label):
	if attack_hitbox:
		print("iki onok")
	bar = hp_bar
	txt = hp_num
	if !atk_modifiers && monster.atk_modifiers:
		var am = Atk_Modifier_Component.new()
		add_child(am)
		atk_modifiers = am
		atk_modifiers.modifiers = monster.atk_modifiers
	if !stats_comp:
		var scom = Stats_Component.new()
		add_child(scom) 
		stats_comp = scom
		stats_comp.stats_source = monster.stats_comp
	if !evolution_manager:
		var em = Evolution_Manager.new()
		add_child(em)
		evolution_manager = em
		#Memasukan evolusi_monster_data
	if !buff_manager:
		var v = Buff_Manager.new()
		add_child(v)
		buff_manager = v
	if !skill_comp:
		var v = Skill_Component.new()
		#stats: Stats_Source, all_skills: Array[SkillData]
		add_child(v)
		v.init(stats_comp.stats_source, monster.skillset) 
		skill_comp = v
		#memasukan skill
	#Anim.add_animation_library("basic_attack", monster.A_basic_attack)
	sprite.texture = monster.texture
	#stats_comp.stats_source = monster.stats_comp
	if !basestats && evolution_manager.is_evolved:
		"stats evolusi"
		#fullstats = evolution_manager.evolution_1.
		pass
	elif !stats && stats_comp:
		print("stats defualt")
		stats = stats_comp.stats_source
		
	print("Monster inited")
	emit_signal("done_init")

func apply_animation(is_enemy:bool):
	var lib: AnimationLibrary
	if Anim.has_animation_library(""): 
		lib = Anim.get_animation_library("")
	else:
		lib = AnimationLibrary.new()
		Anim.add_animation_library("", lib)
	if is_enemy:
		lib.add_animation("take_damage", monster.take_damage)
		lib.add_animation("basic_attack", monster.B_basic_attack)
		lib.add_animation("special_attack", monster.B_special_attack)
		lib.add_animation("idle", monster.B_idle)
		print("enemy anime")
	else:
		lib.add_animation("take_damage", monster.take_damage)
		lib.add_animation("basic_attack", monster.A_basic_attack)
		lib.add_animation("special_attack", monster.A_special_attack)
		lib.add_animation("idle", monster.A_idle)
		print("player anim")

func delete_animtation():
	Anim.remove_animation("take_damage")
	Anim.remove_animation("basic_attack")
	Anim.remove_animation("special_attack")
	Anim.remove_animation("idle")

# Fungsi yang dipanggil ketika giliran monster dimulai
func start_action():
	Anim.play("idle")
	print(name + " mulai giliran!")
	action_point += 2
	if buff_manager.active_buffs:
		print("cek_buff")
		buff_manager.apply_buff_effects(self)
		await buff_manager.done_active
		if stats.cur_hp <=0:
			die()
			return
		if action_point <= 0:
			end_turn()
	elif AI && action_point > 0:
		perform_action()
	else:
		pass

func perform_action():
	if stats.cur_hp > stats.health/2:
		if action_point > 1:
			perform_attack()
		else :
			perform_defense()
	else:
		perform_attack()

func perform_attack():
	if action_point > 0:
		if atk_modifiers:
			var has_buff = atk_modifiers.apply_modifier()  # Coba aktifkan buff
			if has_buff:
				print("attack buff")
				#emit_signal("attack_completed", stats.power, atk_modifiers.active_buffs)
			else :
				print("attack nt")
				#emit_signal("attack_completed", stats.power, null)
		else:
			print("attack polos")
			emit_signal("attack_completed", stats.power, null)
		anim_state(1)
	else :
		print("Aksi gagal karena action point kurang")

func perform_defense():
	if action_point > 0:
		#print(name +" bertahan dengan kekuatan " + str(defense) +"!")
		is_defense = true
		emit_signal("defense_completed",stats.guard)
	else :
		print("Aksi gagal karena action point kurang")

func take_skill(damage: int):
	stats.cur_hp -= damage
	if stats.cur_hp <= 0:
		die()

func take_damage(damage: int):
	if is_defense:
		damage -= stats.guard
		if damage <= 0:
			print(name + " berhasil memblok serangan dengan sempurna!")
			return
	stats.cur_hp -= damage
	if is_defense:
		#print(name + " hanya menerima " + str(damage) + " damage!  Health tersisa: " + str(cur_health))
		is_defense = false
	
	if stats.cur_hp <= 0:
		die()

func use_skill(skill_name: SkillData):
	skill_comp.use_skill(skill_name)  # Gunakan skill dari Skill_Component
	

func evolve(evolution: Monster_Controller):
	if evolution_manager:
		pass
		#evolution_manager.evolve_to_evolution(evolution)
	else:
		print("Evolution_Manager tidak ditemukan!")

func update_hp():
	bar.max_value = stats.health
	bar.value = stats.cur_hp
	if stats.cur_hp <= 0:
		txt.text = " "
	else:
		txt.text = str(stats.cur_hp)

# Fungsi untuk menangani kematian monster
func die():
	print(name + " telah dikalahkan!")
	queue_free()  # Hapus monster dari scene

# Fungsi untuk mengakhiri giliran
func end_turn():
	print(name + " mengakhiri giliran!")
	emit_signal("turn_ended")

func anim_state(v:int):
	match v:
		1:
			Anim.play("basic_attack")
			await Anim.animation_finished
			Anim.play("idle")
		2:
			Anim.play("special_attack")
			await Anim.animation_finished
			Anim.play("idle")
		3:
			Anim.play("take_damage")
		_:
			Anim.play("idle")

func apply_array_buff(buff:Array[Buff_Data]):
	for v in buff:
		buff_manager.add_buff(v)
		emit_signal("buff_added", v)
		await buff_done_add
	emit_signal("done_buff")

func target_take_damage():
	var bodies = attack_hitbox.get_overlapping_areas()
	print(bodies.size())
	for v in bodies:
		
		if v != hurtbox:
			var x:Monster_Controller = v.get_parent().get_parent()
			x.anim_state(3)
			print(x.monster.name + " terkena colision")
		else:
			print(v.name +" nt "+v.get_parent().get_parent().name )
