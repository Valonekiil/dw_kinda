extends Node

@export var Buff_manager:Buff_Manager
@export var buff_1:BuffData
@export var buff_2:BuffData
@export var buff_3:BuffData

func _ready() -> void:
	print(Buff_manager)
	if !Buff_manager:
		var t = get_node("Buff_Manager")
		if t:
			Buff_manager = get_node("Buff_Manager")
			
			
	print(Buff_manager)
