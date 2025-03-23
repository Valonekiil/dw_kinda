extends Node2D
class_name Monster_Controller

@export var stats_comp: Stats_Component
var stats:Stats_Source
var fullstats:Stats_Source
@export var skills: Skill_Component
@export var atk_modifiers: Atk_Modifier_Component
@export var buff_manager: Buff_Manager
@export var evolution_manager: Evolution_Manager
var cur_health:int
@export var AI_Advanced:Enemy_Comp
@export var texture:Sprite2D
@export var Anim:AnimationPlayer
var hp_bar:ProgressBar
var hp_txt:Label
@export var AI:bool
var action_point:int 
var is_defense:bool
# Signal untuk mengirim damage dan mengakhiri giliran
signal attack_completed(damage: int)
signal defense_completed(defense:int)
signal turn_ended()

func _ready() -> void:
	if !fullstats && evolution_manager.is_evolved:
		#fullstats = evolution_manager.evolution_1.
		pass
	elif !stats && stats_comp:
		stats = stats_comp.stats_source
	

# Fungsi yang dipanggil ketika giliran monster dimulai
func start_action():
	print(name + " mulai giliran!")
	action_point += 2
	if buff_manager.active_buffs:
		#buff_manager.apply_buff_effects(self)
		await buff_manager.done_apply
	if AI:
		perform_action()
	else:
		pass

func perform_action():
	if cur_health > stats.health/2:
		if action_point > 1:
			perform_attack()
		else :
			perform_defense()
	else:
		perform_attack()

# Fungsi untuk melakukan serangan
func perform_attack():
	if action_point > 0:
		#print(name + " menyerang dengan kekuatan " + str(attack_power) + "!")
		# Kirim signal attack_completed dengan damage yang diberikan
		emit_signal("attack_completed", stats.power)
	else :
		print("Aksi gagal karena action point kurang")

func perform_defense():
	if action_point > 0:
		#print(name +" bertahan dengan kekuatan " + str(defense) +"!")
		is_defense = true
		emit_signal("defense_completed",stats.guard)
	else :
		print("Aksi gagal karena action point kurang")

# Fungsi untuk menerima damage
func take_damage(damage: int):
	if is_defense:
		damage -= stats.guard
		if damage <= 0:
			print(name + " berhasil memblok serangan dengan sempurna!")
			return
	cur_health -= damage
	if is_defense:
		print(name + " hanya menerima " + str(damage) + " damage!  Health tersisa: " + str(cur_health))
		is_defense = false
	else:
		print(name + " menerima  " + str(damage) + " damage! Health tersisa: " + str(cur_health))
	if cur_health <= 0:
		die()

func use_skill(skill_name: String):
	if skills:
		skills.use_skill(skill_name)  # Gunakan skill dari Skill_Component
	else:
		print("Skill_Component tidak ditemukan!")

func evolve(evolution: Monster_Controller):
	if evolution_manager:
		pass
		#evolution_manager.evolve_to_evolution(evolution)
	else:
		print("Evolution_Manager tidak ditemukan!")

func update_hp(bar:ProgressBar, txt:Label):
	bar.max_value = stats.health
	bar.value = cur_health
	txt.text = str(cur_health)

# Fungsi untuk menangani kematian monster
func die():
	print(name + " telah dikalahkan!")
	queue_free()  # Hapus monster dari scene

# Fungsi untuk mengakhiri giliran
func end_turn():
	print(name + " mengakhiri giliran!")
	emit_signal("turn_ended")
