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
@onready var atk_btn = $ui/Btn_Attack
@onready var def_btn = $ui/Btn_Defense
@onready var conf:Conf_Manager = $ui/Conf_Manager
# Variabel untuk melacak giliran saat ini
var Turn: int = 0
var current_turn: Monster_Controller
var current_target:Monster_Controller
var current_act: int = 1
var temp_def:bool

func init():
	monster_1.init()
	monster_2.init()
	monster_1.buff_manager.init(buff_con1,conf,monster_1.stats)
	monster_1.buff_manager.buff_activated.connect(conf.Buff_Activated)
	monster_2.buff_manager.init(buff_con2,conf,monster_2.stats)
	monster_2.buff_manager.buff_activated.connect(conf.Buff_Activated)
	monster_1.apply_animation(false) #karena_bukan_enemy
	monster_2.apply_animation(true)
	monster_1.attack_completed.connect(_on_attack_completed.bind(monster_2))
	monster_1.defense_completed.connect(_on_defense_completed)
	monster_1.hp_bar = hp_bar_1
	monster_1.hp_txt = hp1
	monster_1.turn_ended.connect(_on_turn_ended)
	monster_1.buff_added.connect(confirm_buff.bind(monster_1))
	#atk_btn.pressed.connect(monster_1.perform_attack())
	#def_btn.pressed.connect(monster_1.perform_defense())
	monster_2.attack_completed.connect(_on_attack_completed.bind(monster_1))
	monster_2.defense_completed.connect(_on_defense_completed)
	monster_2.hp_bar = hp_bar_2
	monster_2.hp_txt = hp2
	monster_2.turn_ended.connect(_on_turn_ended)
	monster_2.buff_added.connect(confirm_buff.bind(monster_2))
	# Memulai giliran pertama
	monster_1.update_hp(hp_bar_1,hp1)
	monster_2.update_hp(hp_bar_2,hp2)
	start_turn()
	
	name_1.text = monster_1.monster.name
	name_2.text = monster_2.monster.name
	print("Turn inited")

# Fungsi untuk memulai giliran
func start_turn():
	await get_tree().process_frame
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
	current_turn.start_action()


# Fungsi untuk menangani signal attack_completed
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
	target.update_hp(target.hp_bar,target.hp_txt)
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

# Fungsi untuk menangani signal turn_ended
func _on_turn_ended():
	current_act = 1
	start_turn()

func confirm_buff(buff:Buff_Data, mon:Monster_Controller):
	conf.Monster_Buffed(buff, mon)
	await conf.btn.pressed
	mon.emit_signal("buff_done_add")

func target_take_damage():
	current_target.anim_state(3)

func _on_btn_attack_pressed() -> void:
	if current_turn == monster_1:
		monster_1.perform_attack()
	else:
		print("ini bukan giliranmu")

func _on_btn_defense_pressed() -> void:
	if current_turn == monster_1:
		monster_1.perform_defense()
	else :
		print("ini bukan giliranmu")
