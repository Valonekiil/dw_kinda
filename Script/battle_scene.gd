extends Control

@export var Player_Curent:Monster_Data
@export var Enemy_Curent:Monster_Data
@export var Player_Monster1:Monster_Data
@export var Player_Monster2:Monster_Data
@export var Player_Monster3:Monster_Data
@export var Enemy_Monster1:Monster_Data
@export var Enemy_Monster2:Monster_Data
@export var Enemy_Monster3:Monster_Data
@onready var BM = $Turn_Manager
var player_monsters: Array[Monster_Data]
var enemy_monsters: Array[Monster_Data]
var player_current_index: int = 0
var enemy_current_index: int = 0
@export var anim_player:AnimationPlayer
@export var anim_enemy:AnimationPlayer

func _ready() -> void:
	player_monsters = [Player_Monster1, Player_Monster2, Player_Monster3]
	enemy_monsters = [Enemy_Monster1, Enemy_Monster2, Enemy_Monster3]
	
	player_current_index = player_monsters.find(Player_Curent)
	enemy_current_index = enemy_monsters.find(Enemy_Curent)
	
	# Pastikan indeks valid
	if player_current_index == -1:
		player_current_index = 0
		Player_Curent = player_monsters[0]
	if enemy_current_index == -1:
		enemy_current_index = 0
		Enemy_Curent = enemy_monsters[0]
	
	BM.monster_1.monster = Player_Curent
	BM.monster_2.monster = Enemy_Curent
	BM.init()
	print("Batlle inited")

func switch(new: Monster_Data, enem: bool):
	if enem:
		var index = enemy_monsters.find(new)
		if index == -1:
			print("Monster musuh tidak ditemukan")
			return
		# Simpan monster musuh saat ini ke resource yang sesuai
		ResourceSaver.save(enemy_monsters[enemy_current_index])
		enemy_current_index = index
		Enemy_Curent = new
		BM.monster_2.monster = new
	else:
		var index = player_monsters.find(new)
		if index == -1:
			print("Monster pemain tidak ditemukan")
			return
		# Simpan monster pemain saat ini ke resource yang sesuai
		ResourceSaver.save(player_monsters[player_current_index])
		player_current_index = index
		Player_Curent = new
		BM.monster_1.monster = new

func target_take_damage():
	BM.current_target.anim_state(3)


func _on_button_pressed() -> void:
	var v = anim_player.get_animation_library("")
	ResourceSaver.save(v,"player_anim.tres")
	var e = anim_enemy.get_animation_library("")
	ResourceSaver.save(e,"enemy_anim.tres")
