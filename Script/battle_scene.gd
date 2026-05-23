extends Control

@export var Player_Curent:Monster_Data
@export var Enemy_Curent:Monster_Data
@export var Player_Monster1:Monster_Data
@export var Player_Monster2:Monster_Data
@export var Player_Monster3:Monster_Data
@export var Enemy_Monster1:Monster_Data
@export var Enemy_Monster2:Monster_Data
@export var Enemy_Monster3:Monster_Data

# Monster_Entity untuk tracking progression (single source of truth)
@export var player_entity: Monster_Entity
@export var enemy_entity: Monster_Entity

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
	print(player_current_index ,0 ,enemy_current_index)
	player_current_index = player_monsters.find(Player_Curent)
	enemy_current_index = enemy_monsters.find(Enemy_Curent)
	print(player_current_index ,0 ,enemy_current_index)
	# Pastikan indeks valid
	if player_current_index == -1 || !Player_Curent:
		player_current_index = 0
		Player_Curent = player_monsters[0]
	if enemy_current_index == -1 || !Enemy_Curent:
		enemy_current_index = 0
		Enemy_Curent = enemy_monsters[0]
	print(Player_Curent)
	print(Enemy_Curent)
	BM.monster_1.monster = Player_Curent
	BM.monster_2.monster = Enemy_Curent
	
	# Hubungkan entity ke evolution_manager di controller
	if player_entity and BM.monster_1.evolution_manager:
		BM.monster_1.evolution_manager.entity = player_entity
	if enemy_entity and BM.monster_2.evolution_manager:
		BM.monster_2.evolution_manager.entity = enemy_entity
	
	BM.init()
	print("Battle inited")

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
		
		# Track form used untuk distribusi DVEXP
		if enemy_entity and BM.monster_2.evolution_manager:
			BM.monster_2.evolution_manager.track_form_used(new)
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
		
		# Track form used untuk distribusi DVEXP
		if player_entity and BM.monster_1.evolution_manager:
			BM.monster_1.evolution_manager.track_form_used(new)

func finalize_battle(player_victory: bool = true):
	# Kalkulasi reward post-battle
	var rookie_reward = 50  # TODO: Ganti dengan kalkulasi berdasarkan difficulty musuh
	var dv_reward = randi_range(1, 10)
	
	# Proses reward untuk player
	if BM.monster_1 and BM.monster_1.evolution_manager:
		BM.monster_1.evolution_manager.process_post_battle(rookie_reward, dv_reward)
	
	# Proses reward untuk enemy (jika punya entity)
	if BM.monster_2 and BM.monster_2.evolution_manager:
		BM.monster_2.evolution_manager.process_post_battle(max(1, rookie_reward / 2), max(1, dv_reward / 2))
	
	print("[Battle] Post-battle rewards distributed!")
	print("  Rookie EXP: %d, DVEXP: %d" % [rookie_reward, dv_reward])
	
	# Cetak status player entity
	if player_entity:
		print("  Rookie Level: %d, Training Points: %d" % [player_entity.rookie_lvl, player_entity.training_points])

func target_take_damage():
	BM.current_target.anim_state(3)

func _on_button_pressed() -> void:
	var v = anim_player.get_animation_library("")
	ResourceSaver.save(v,"player_anim.tres")
	var e = anim_enemy.get_animation_library("")
	ResourceSaver.save(e,"enemy_anim.tres")