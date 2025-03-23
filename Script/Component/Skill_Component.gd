extends Node
class_name Skill_Component

@export var skills: Array[String] = ["Fireball", "Heal", "Thunder Strike"]

func use_skill(skill_name: String):
	if skill_name in skills:
		print("Menggunakan skill: " + skill_name)
	else:
		print("Skill tidak ditemukan")
