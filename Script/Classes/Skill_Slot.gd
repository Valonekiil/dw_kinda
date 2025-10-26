extends Button
class_name Skill_Slot

var skill:SkillData

func _on_pressed():
	if skill:
		use_skill(skill)
	else:
		print("gaje")

func use_skill(v:SkillData):
	pass
