extends Node

@export var Monster:Monster_Data
@export var SKill: SkillData
@onready var sprite = $Sprite2D
@onready var Anim = $AnimationPlayer
@onready var t = $Sprite2D2

func _ready() -> void:
	var test_cases = [
	{"power": 100, "guard": 200, "expected": 0.0},
	{"power": 100, "guard": 150, "expected": 0.5},
	{"power": 100, "guard": 100, "expected": 1.0},
	{"power": 100, "guard": 75, "expected": 1.5},
	{"power": 100, "guard": 50, "expected": 2.0}
	]
	
	for test in test_cases:
		var ratio = test["guard"] / float(test["power"])
		var result = 0.0
		
		# PARAMETER YANG LEBIH TEPAT:
		var max_scaling = 2.0
		var midpoint = 1.4      # MIDPOINT LEBIH TINGGI
		var steepness = 3.5     # STEEPNESS LEBIH RENDAH
		
		var scaling = max_scaling / (1.0 + exp(steepness * (ratio - midpoint)))
		result += scaling
		
		print("Power: %d, Guard: %d, Result: %.1f, Expected: %.1f" % [
			test["power"], test["guard"], result, test["expected"]
		])
	$Button.grab_focus()

func _on_button_pressed() -> void:
	if Monster:
		Monster.texture = sprite.texture
		Monster.A_basic_attack = Anim.get_animation("basic_attack")
		Monster.A_special_attack = Anim.get_animation("special_attack")
		Monster.A_idle = Anim.get_animation("idle")
		Monster.take_damage = Anim.get_animation("take_damage")
		Monster.B_basic_attack =Anim.get_animation("B_basic_attack")
		Monster.B_special_attack = Anim.get_animation("B_special_attack")
		Monster.B_idle =Anim.get_animation("B_idle")
		ResourceSaver.save(Monster)
	if SKill:
		SKill.anim_A = Anim.get_animation("Attack_A")
		SKill.anim_B = Anim.get_animation("Attack_B")
		ResourceSaver.save(SKill)

func _on_button_1_pressed() -> void:
	pass

func _on_hurt_area_entered(area: Area2D):
	print("Area entered:", area.name)
	$Label.visible = true


func _on_hurt1_area_entered(_area: Area2D) -> void:
	$Label.visible = false
	print("gagal")


func _on_hurt_area_exited(area: Area2D) -> void:
	$Label.visible = true

func test():
	$Label.visible = true
