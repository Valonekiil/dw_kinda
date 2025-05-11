extends Node
class_name Skill_Component

@export var skillset: Array[SkillData]

# Inisialisasi komponen skill
func init(stats: Stats_Source, all_skills: Array[SkillData]):
	skillset.clear()  # Kosongkan skillset sebelum init
	
	# Filter skill yang memenuhi requirement
	for skill in all_skills:
		if skill.is_requirements_met(stats):
			skillset.append(skill)
	
	print("Skill yang tersedia:", skillset.map(func(s): return s.skill_name))

# Menggunakan skill
func use_skill(skill: SkillData):
	if skill in skillset:
		print("Menggunakan skill: ", skill.skill_name)
		# Implementasi efek skill bisa ditambahkan di sini
	else:
		print("Skill ", skill.skill_name, " tidak tersedia atau tidak memenuhi syarat")

# Contoh implementasi efek skill (opsional)
func apply_skill_effect(user: Stats_Source, target: Stats_Source, skill: SkillData):
	if skill in skillset:
		match skill.skill_type:
			Enums.SkillType.OFFENSIVE:
				var damage = skill.power + user.power - target.guard
				target.cur_hp -= damage
				print("Memberi ", damage, " damage ke musuh")
			
			Enums.SkillType.DEFENSIVE:
				var heal = skill.power + user.arcane
				user.cur_hp = min(user.cur_hp + heal, user.health)
				print("Memulihkan ", heal, " HP")
		
		if skill.buff:
			target.buff_manager.apply_buff(skill.buff)
	else:
		push_error("Skill tidak valid untuk digunakan")
