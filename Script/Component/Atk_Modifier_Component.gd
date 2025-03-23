extends Node
class_name Atk_Modifier_Component

@export var modifiers: Array[String] = ["Poison", "Stun", "Burn"]

# Fungsi untuk menerapkan modifier
func apply_modifier(modifier_name: String):
	if modifier_name in modifiers:
		print("Menerapkan modifier: " + modifier_name)
	else:
		print("Modifier tidak ditemukan")
