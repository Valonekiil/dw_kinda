extends Control
class_name Skill_Menu

@onready var Con = $VBC

func init(S_Comp:Skill_Component,Skill_List:Array[SkillData]):
	if Skill_List.is_empty():
		return 
	for v in Skill_List:
		var SS = Skill_Slot.new()
		SS.skill = v
		SS.pressed.connect(S_Comp.use_skill.bind(v))
		Con.add_child(SS)
		SS.text = v.skill_name
