extends Node
class_name Atk_Modifier_Component

@export var modifiers: Array[Atk_Modifer]
var active_buffs: Array[Buff_Data] = []

func apply_modifier() -> bool:
	active_buffs.clear()
	var success = false
	for modifier in modifiers:
		if randf() * 100 < modifier.chance:
			active_buffs.append(modifier.Debuff)
			success = true
	return success
