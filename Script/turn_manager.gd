extends Control
class_name Turn_Manager

# Ekspor variabel untuk menyimpan referensi ke monster-monster
@export var monster_1: Monster_Controller
@export var monster_2: Monster_Controller
@onready var hp_bar_1 = $hp_1
@onready var hp1 = $hp_1/c/txt
@onready var hp_bar_2 = $hp_2
@onready var hp2 = $hp_2/c/txt
@onready var atk_btn = $Btn_Attack
@onready var def_btn = $Btn_Defense
# Variabel untuk melacak giliran saat ini
var Turn: int = 0
var current_turn: Monster_Controller
var current_act: int = 1

# Fungsi yang dipanggil ketika node siap
func _ready():
	
	# Hubungkan signal dari setiap monster
	monster_1.attack_completed.connect(_on_attack_completed.bind(monster_2))
	monster_1.defense_completed.connect(_on_defense_completed)
	monster_1.hp_bar = hp_bar_1
	monster_1.hp_txt = hp1
	monster_1.turn_ended.connect(_on_turn_ended)
	#atk_btn.pressed.connect(monster_1.perform_attack())
	#def_btn.pressed.connect(monster_1.perform_defense())
	monster_2.attack_completed.connect(_on_attack_completed.bind(monster_1))
	monster_2.defense_completed.connect(_on_defense_completed)
	monster_2.hp_bar = hp_bar_2
	monster_2.hp_txt = hp2
	monster_2.turn_ended.connect(_on_turn_ended)
	# Memulai giliran pertama
	monster_1.update_hp(hp_bar_1,hp1)
	monster_2.update_hp(hp_bar_2,hp2)
	start_turn()

# Fungsi untuk memulai giliran
func start_turn():
	# Tentukan siapa yang mendapat giliran berdasarkan nilai Turn
	print("turn start")
	if Turn % 2 == 0:
		current_turn = monster_1
		print("turn monster 1")
	else:
		current_turn = monster_2
		print("turn monster 2")
	# Mulai aksi monster
	Turn += 1
	print("Turn ke " + str(Turn))
	current_turn.start_action()
	

# Fungsi untuk menangani signal attack_completed
func _on_attack_completed(damage: int, target: Monster_Controller):
	print("dalam aksi ke " + str(current_act) + " " + current_turn.name + " melakukan serangan")
	print(current_turn.name + "berhasil melakukan serangan ke " + target.name)
	target.take_damage(damage)
	target.update_hp(target.hp_bar,target.hp_txt)
	current_turn.action_point -= 1
	if current_turn.action_point == 0:
		current_turn.end_turn()
	elif (current_turn == monster_1):
		pass
	else:
		current_turn.perform_action()

func _on_defense_completed(defense:int):
	print("dalam aksi ke " + str(current_act) + " " + current_turn.name + " melakukan pertahanan")
	print(current_turn.name + "berhasil melakukan defense sebesar " + str(defense))
	current_turn.action_point -= 1
	if current_turn.action_point == 0:
		current_turn.end_turn()
	else:
		current_turn.perform_action()

# Fungsi untuk menangani signal turn_ended
func _on_turn_ended():
	current_act = 1
	start_turn()

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
