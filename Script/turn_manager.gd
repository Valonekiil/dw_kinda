extends Control
class_name Turn_Manager

@export var monster_1: Monster_Controller
@export var monster_2: Monster_Controller
@onready var name_1 =$ui/P1_Con/Name
@onready var hp_bar_1 = $ui/P1_Con/hp
@onready var hp1 = $ui/P1_Con/hp/c/txt
@onready var buff_con1 = $ui/P1_Con/buff
@onready var name_2 = $ui/P2_Con/Name
@onready var hp_bar_2 = $ui/P2_Con/hp
@onready var hp2 = $ui/P2_Con/hp/c/txt
@onready var buff_con2 = $ui/P2_Con/buff
@onready var atk_btn = $ui/Player_Btn/Btn_Attack
@onready var def_btn = $ui/Player_Btn/Btn_Defense
@onready var conf:Conf_Manager = $ui/Conf_Manager
@onready var Player_Btn = $ui/Player_Btn
@onready var Skill_UI:Skill_Menu = $ui/Skill_Menu
@onready var Ui_Anim = $AnimationPlayer
@onready var Damage_Calculator:ElementSystem = $Element_Manager
# Variabel untuk melacak giliran saat ini
var cur_ui_state:int = 0
var Turn: int = 0
var current_turn: Monster_Controller
var current_target:Monster_Controller
var current_act: int = 1
var temp_def:bool

func init():
	 #Fungsi init yang sudah direfaktor
	GlobalSignal.Take_damage.connect(take_animation_damage)
	GlobalSignal.emit_signal("Take_damage")

	connect_monster_to_player(monster_1, monster_2)
	connect_monster_to_enemy(monster_2, monster_1)

	start_turn()
	print("Turn inited")

# Fungsi koneksi untuk monster pemain (monster_1)
func connect_monster_to_player(monster: Monster_Controller, target: Monster_Controller) -> void:
	monster.init(hp_bar_1, hp1)
	monster.buff_manager.init(buff_con1, conf, monster.stats)
	monster.buff_manager.buff_activated.connect(conf.Buff_Activated)
	monster.apply_animation(false)

	monster.attack_completed.connect(_on_attack_completed.bind(target))
	monster.defense_completed.connect(_on_defense_completed)
	monster.turn_ended.connect(_on_turn_ended)
	monster.buff_added.connect(confirm_buff.bind(monster))

	monster.hp_bar = hp_bar_1
	monster.hp_txt = hp1
	name_1.text = monster.monster.name
	monster.update_hp()

	if monster.skill_comp:
		Skill_UI.init(monster.skill_comp, monster.skill_comp.skillset)

# Fungsi koneksi untuk monster musuh (monster_2)
func connect_monster_to_enemy(monster: Monster_Controller, target: Monster_Controller) -> void:
	monster.init(hp_bar_2, hp2)
	monster.buff_manager.init(buff_con2, conf, monster.stats)
	monster.buff_manager.buff_activated.connect(conf.Buff_Activated)
	monster.apply_animation(true)

	monster.attack_completed.connect(_on_attack_completed.bind(target))
	monster.defense_completed.connect(_on_defense_completed)
	monster.turn_ended.connect(_on_turn_ended)
	monster.buff_added.connect(confirm_buff.bind(monster))

	monster.hp_bar = hp_bar_2
	monster.hp_txt = hp2
	name_2.text = monster.monster.name
	monster.update_hp()

# Fungsi diskoneksi untuk membersihkan sinyal & referensi UI
func disconnect_monster(monster: Monster_Controller, target: Monster_Controller) -> void:
	var atk_bound = _on_attack_completed.bind(target)
	if monster.attack_completed.is_connected(atk_bound):
		monster.attack_completed.disconnect(atk_bound)

	if monster.defense_completed.is_connected(_on_defense_completed):
		monster.defense_completed.disconnect(_on_defense_completed)

	if monster.turn_ended.is_connected(_on_turn_ended):
		monster.turn_ended.disconnect(_on_turn_ended)

	var buff_bound = confirm_buff.bind(monster)
	if monster.buff_added.is_connected(buff_bound):
		monster.buff_added.disconnect(buff_bound)

	if monster.buff_manager.buff_activated.is_connected(conf.Buff_Activated):
		monster.buff_manager.buff_activated.disconnect(conf.Buff_Activated)

	monster.hp_bar = null
	monster.hp_txt = null
	if monster == monster_1:
		name_1.text = ""
	elif monster == monster_2:
		name_2.text = ""

func take_animation_damage(me:Monster_Controller):
	print("ternigger")
	match me:
		monster_1:
			monster_2.anim_state(3)
		monster_2:
			monster_1.anim_state(3)

# Fungsi untuk memulai giliran
func start_turn():
	if cur_ui_state != 0:
		ui_state(0)
		await Ui_Anim.animation_finished
	# Tentukan siapa yang mendapat giliran berdasarkan nilai Turn
	print("turn start")
	if Turn % 2 == 0:
		current_turn = monster_1
		current_target = monster_2
	else:
		current_turn = monster_2
		current_target = monster_1
		print("turn monster 2")
	# Mulai aksi monster
	Turn += 1
	$ui/Cur_Turn.text = str(Turn)
	conf.Monster_Turn(current_turn)
	current_target.anim_state(0)
	current_turn.anim_state(0)
	await conf.btn.pressed
	current_turn.start_action()
	if current_turn == monster_1:
		if current_turn.buff_manager.active_buffs:
			await current_turn.buff_manager.done_active
		if current_turn.action_point <= 0:
			return
		ui_state(1)
		await Ui_Anim.animation_finished
		

func _on_attack_completed(damage: int, buff: Variant, target: Monster_Controller):
	conf.Monster_Attack(current_turn)
	await conf.btn.pressed
	if target.is_defense:
		temp_def = true
	print("target take damage")
	target.take_damage(damage)
	if temp_def:
		conf.Monster_Defensed_Damage(target,damage-target.stats.guard)
		temp_def = false
	else:
		conf.Monster_Take_Damage(target,damage)
	target.update_hp()
	await conf.btn.pressed
	if target:
		if target.stats.cur_hp > 0:
			target.anim_state(0)
	if buff is Array[Buff_Data] && target:
		target.apply_array_buff(buff)
		await target.done_buff
	current_turn.action_point -= 1
	if current_turn.action_point == 0:
		current_turn.end_turn()
	elif (current_turn == monster_1):
		pass
	else:
		current_turn.perform_action()

func _on_defense_completed(defense:int):
	#print("dalam aksi ke " + str(current_act) + " " + current_turn.name + " melakukan pertahanan")
	#print(current_turn.name + "berhasil melakukan defense sebesar " + str(defense))
	print("defense")
	conf.Monster_Defense(current_turn)
	await conf.btn.pressed
	current_turn.action_point -= 1
	if current_turn.action_point == 0:
		current_turn.end_turn()
	else:
		current_turn.perform_action()

func _on_skill_completed(skill:SkillData, buff: Variant, target: Monster_Controller):
	conf.Monster_Skill(current_turn, skill)
	var damage = Damage_Calculator.calculate_damage_simple(current_turn.stats, skill)
	await conf.btn.pressed
	target.take_skill(int(damage))
	conf.Monster_Take_Damage(target,damage)
	target.update_hp()
	await conf.btn.pressed
	if target:
		if target.stats.cur_hp > 0:
			target.anim_state(0)
	if buff is Array[Buff_Data] && target:
		target.apply_array_buff(buff)
		await target.done_buff
	current_turn.action_point -= 1
	if current_turn.action_point == 0:
		current_turn.end_turn()
	elif (current_turn == monster_1):
		pass
	else:
		current_turn.perform_action()

func _on_turn_ended():
	conf.Monster_Turn_End(current_turn)
	await conf.btn.pressed
	current_act = 1
	start_turn()

func confirm_buff(buff:Buff_Data, mon:Monster_Controller):
	conf.Monster_Buffed(buff, mon)
	await conf.btn.pressed
	mon.emit_signal("buff_done_add")

func target_take_damage():
	current_target.anim_state(3)

func ui_state(i:int):
	match i:
		0:
			match cur_ui_state:
				1:
					Ui_Anim.play("BaseToNothing")
					
				2:
					Ui_Anim.play("SkillToNothing")
			#get_viewport().gui_get_focus_owner().release_focus()
			cur_ui_state = 0
		1:
			match cur_ui_state:
				0:
					Ui_Anim.play_backwards("BaseToNothing")
				2:
					Ui_Anim.play_backwards("BaseToSkill")
			#Player_Btn.get_child(0).grab_focus()
			cur_ui_state = 1
		2:
			match cur_ui_state:
				1:
					Ui_Anim.play("BaseToSkill")
			#if Skill_UI.Con.get_child_count() > 0:
				#Skill_UI.Con.get_child(0).grab_focus()
			cur_ui_state = 2

func _on_btn_attack_pressed() -> void:
	if current_turn == monster_1:
		monster_1.perform_attack()
		#atk_btn.disabled = true
	else:
		print("ini bukan giliranmu")

func _on_btn_defense_pressed() -> void:
	if current_turn == monster_1:
		monster_1.perform_defense()
	else :
		print("ini bukan giliranmu")

func _on_btn_skill_pressed() -> void:
	if current_turn == monster_1:
		print("keteken")
		ui_state(2)
		await Ui_Anim.animation_finished
		print("lah")
	else :
		print("ini bukan giliranmu")

func _on_btn_evolve_pressed() -> void:
	if current_turn == monster_1:
		var em = monster_1.evolution_manager
		if not em:
			print("Evolution Manager tidak ditemukan!")
			return
		
		# Dapatkan opsi evolusi yang tersedia (form selain current)
		var options = em.get_active_forms().filter(func(f): return f != monster_1.monster)
		
		if options.is_empty():
			print("Tidak ada wujud evolusi yang tersedia")
			return
		
		# TODO: Ganti dengan UI selector jika ada. Untuk sekarang, pakai form pertama
		var target = options[0]
		
		# Coba evolusi via evolution_manager (cek MP, panggil evolve_to, track form)
		var success = em.try_evolve_to(target)
		
		if success:
			conf.Monster_Evolution(monster_1)
			await conf.btn.pressed
			name_1.text = monster_1.monster.name
			# Perbarui skill UI setelah evolusi
			if monster_1.skill_comp:
				Skill_UI.init(monster_1.skill_comp, monster_1.skill_comp.skillset)
			print("Evolusi berhasil! %s" % monster_1.monster.name)
		else:
			print("Evolusi gagal! Cek MP atau ketersediaan form.")
	else:
		print("ini bukan giliranmu")

func _on_btn_tag_pressed() -> void:
	if current_turn == monster_1:
		monster_1.perform_defense()
	else :
		print("ini bukan giliranmu")

func _on_btn_item_pressed() -> void:
	if current_turn == monster_1:
		monster_1.perform_defense()
	else :
		print("ini bukan giliranmu")

func _on_btn_flee_pressed() -> void:
	if current_turn == monster_1:
		monster_1.perform_defense()
	else :
		print("ini bukan giliranmu")

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_key_pressed(KEY_R):
		ui_state(1)
		await Ui_Anim.animation_finished
