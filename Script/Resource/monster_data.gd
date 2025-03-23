extends Resource
class_name Monster_Data

@export var name: String = ""  # Nama monster
@export var stats_comp: Stats_Source
#@export var skills: Skill_Component
#@export var atk_modifiers: Atk_Modifier_Component
@export var texture: Texture2D
@export var basic_attack: Animation
@export var special_attack: Animation
@export var take_damage:Animation
