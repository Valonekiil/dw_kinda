extends Node

@export var Monster:Monster_Data
@onready var sprite = $Sprite2D
@onready var Anim = $AnimationPlayer

func _ready() -> void:
	Monster.texture = sprite.texture
	Monster.A_basic_attack = Anim.get_animation("basic_attack")
	Monster.A_special_attack = Anim.get_animation("special_attack")
	Monster.A_idle = Anim.get_animation("idle")
	Monster.take_damage = Anim.get_animation("take_damage")
	Monster.B_basic_attack =Anim.get_animation("B_basic_attack")
	Monster.B_special_attack = Anim.get_animation("B_special_attack")
	Monster.B_idle =Anim.get_animation("B_idle")
	ResourceSaver.save(Monster, "res://Aset/Demo/Vegamon(test2).tres")


func _on_button_pressed() -> void:
	pass
