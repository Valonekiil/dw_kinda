extends Node
class_name Skill_Component

@export var skillset: Array[SkillData]
var Anim:AnimationPlayer
var sprite_skill:Sprite2D
var area_attack:Area2D

# Inisialisasi komponen skill
func init(stats: Stats_Source, all_skills: Array[SkillData]):
	skillset.clear()  # Kosongkan skillset sebelum init
	
	# Filter skill yang memenuhi requirement
	for skill in all_skills:
		if skill.is_requirements_met(stats):
			skillset.append(skill)
	
	print("Skill yang tersedia:", skillset.map(func(s): return s.skill_name))
	await get_parent().done_init
	area_attack = get_parent().attack_hitbox
	Anim = get_parent().Anim
	sprite_skill = get_parent().sprite_skill

func calculate(element: Enums.Element, formula: Skill_Formula, user: Stats_Source,) -> int:
	var total_damage: float = 0.0
	
	# Mapping untuk mengonversi enum Element ke nama stat yang sesuai
	var element_stat_map = {
		Enums.Element.Neutral: "arcane",
		Enums.Element.Fire: "fire",
		Enums.Element.Water: "water",
		Enums.Element.Earth: "earth",
		Enums.Element.Nature: "nature",
		Enums.Element.Wind: "wind",
		Enums.Element.Lighting: "lightning",
		Enums.Element.Ice: "ice",
		Enums.Element.Metal: "metal",
		Enums.Element.Light: "light",
		Enums.Element.Dark: "dark",
		Enums.Element.Chaos: "chaos",
		Enums.Element.Mystical: "mystical"
	}
	
	# Hitung physical damage jika diperlukan
	if formula.IsPhysical:
		total_damage += user.power * formula.ScalingPhysic
	
	# Hitung magical damage jika diperlukan
	if formula.IsMagical:
		total_damage += user.arcane * formula.ScalingMagic
	
	# Hitung elemental damage jika diperlukan
	if formula.IsElemental:
		var element_stat: String = element_stat_map[element]
		var element_value: float = user.get(element_stat)
		total_damage += element_value * formula.ScalingElement
	
	# Bulatkan dan kembalikan sebagai integer
	return int(round(total_damage)) 

# Menggunakan skill
func use_skill(skill: SkillData):
	if skill in skillset:
		print("Menggunakan skill: ", skill.skill_name)
		var tmp = Skill_Player.new()
		tmp.set_var(Anim,sprite_skill)
		tmp.play(skill, area_attack, true)
	else:
		print("Skill ", skill.skill_name, " tidak tersedia atau tidak memenuhi syarat")

func apply_skill_effect(user: Stats_Source, target: Stats_Source, skill: SkillData):
	if skill in skillset:
		match skill.skill_type:
			Enums.SkillType.OFFENSIVE:
				var damage = skill.power + user.power - target.guard
				target.cur_hp -= damage
				print("Memberi ", damage, " damage ke musuh")
			
			Enums.SkillType.DEFENSIVE:
				var heal = skill.power + user.arcane
				target.cur_hp = min(target.cur_hp + heal, target.health)
				print("Memulihkan ", heal, " HP")
		
		if skill.buff:
			target.buff_manager.apply_buff(skill.buff)
	else:
		push_error("Skill tidak valid untuk digunakan")
