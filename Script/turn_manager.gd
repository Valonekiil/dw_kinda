extends Control
class_name Turn_Manager

# Ekspor variabel untuk menyimpan referensi ke monster-monster
@export var monster_1: Monster_Controller
@export var monster_2: Monster_Controller
@onready var hp_bar_1 = $hp_1
@onready var hp_bar_2 = $hp_2
@onready var atk_btn = $Btn_Attack
@onready var def_btn = $Btn_Defense
# Variabel untuk melacak giliran saat ini
var Turn: int = 0
var current_turn: Monster_Controller
var current_act: int

# Fungsi yang dipanggil ketika node siap
func _ready():
	
	# Hubungkan signal dari setiap monster
	monster_1.attack_completed.connect(_on_attack_completed.bind(monster_2))
	monster_1.defense_completed.connect(_on_defense_completed)
	monster_1.update_hp.bind(hp_bar_1)
	monster_1.turn_ended.connect(_on_turn_ended)
	atk_btn.pressed.connect(monster_1.perform_attack())
	def_btn.pressed.connect(monster_1.perform_defense())
	
	monster_2.attack_completed.connect(_on_attack_completed.bind(monster_1))
	monster_2.defense_completed.connect(_on_defense_completed)
	monster_2.update_hp.bind(hp_bar_2)
	monster_2.turn_ended.connect(_on_turn_ended)
	
	# Memulai giliran pertama
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
	current_turn.start_action()
	Turn += 1

# Fungsi untuk menangani signal attack_completed
func _on_attack_completed(damage: int, target: Monster_Controller):
	print("dalam aksi ke " + str(current_act) + " " + current_turn.name + " melakukan serangan")
	print(current_turn.name + "berhasil melakukan serangan ke " + target.name)
	target.take_damage(damage)
	if current_turn.action_point == 0:
		current_turn.end_turn()
	else:
		current_turn.perform_action()

func _on_defense_completed(defense:int):
	print("dalam aksi ke " + str(current_act) + " " + current_turn.name + " melakukan pertahanan")
	print(current_turn.name + "berhasil melakukan defense sebesar " + str(defense))
	if current_turn.action_point == 0:
		current_turn.end_turn()
	else:
		current_turn.perform_action()

# Fungsi untuk menangani signal turn_ended
func _on_turn_ended():
	# Mulai giliran berikutnya
	start_turn()

# memodif gameloop agar 60 fps
#
