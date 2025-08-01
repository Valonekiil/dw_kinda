extends CanvasLayer

@export var battle_scene:PackedScene

var battled:bool
var area:String 
var last_post:Vector2

func _ready() -> void:
	pass

func save_player_data(player):
	area = player.area
	last_post = player.position
	battled = true

func battle_called():
	$AnimationPlayer.play("Enemy_Appear")
	await $AnimationPlayer.animation_finished
	get_tree().change_scene_to_packed(battle_scene)
	$AnimationPlayer.play("Battle_Start")
