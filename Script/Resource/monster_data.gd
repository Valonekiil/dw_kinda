extends Resource
class_name Monster_Data

@export var name: String # Nama monster
@export var stats_comp: Stats_Source
@export var skillset:Array[SkillData]
@export var atk_modifiers: Array[Atk_Modifer]
@export var texture: Texture2D
@export var A_idle: Animation
@export var A_basic_attack: Animation
@export var A_special_attack: Animation
@export var take_damage:Animation
@export var B_idle: Animation
@export var B_basic_attack: Animation
@export var B_special_attack: Animation
