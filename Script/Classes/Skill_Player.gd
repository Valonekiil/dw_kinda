extends Node
class_name Skill_Player

var anim:AnimationPlayer
var txt:Sprite2D
var current_skill:SkillData

func set_var(v:AnimationPlayer,x:Sprite2D):
	anim = v
	txt = x

func play(skill:SkillData, area:Area2D, is_player: bool):
	var original_parent = area.get_parent()
	var remote_transform = RemoteTransform2D.new()
	
	# Setup remote transform untuk mengikuti sprite
	txt.add_child(remote_transform)
	remote_transform.remote_path = remote_transform.get_path_to(area)
	remote_transform.position = Vector2.ZERO
	current_skill = skill
	
	# Setup sprite
	txt.texture = skill.sprite
	txt.visible = true
	
	# Pilih animation berdasarkan sisi (player/lawan)
	var animation_to_play = skill.anim_A if is_player else skill.anim_B
	
	if animation_to_play:
		var lib: AnimationLibrary
		if anim.has_animation_library(""): 
			lib = anim.get_animation_library("")
		lib.add_animation(skill.skill_name, animation_to_play)
		anim.play(skill.skill_name)
		await anim.animation_finished
		original_parent.add_child(area)
		remote_transform.queue_free()
		lib.remove_animation(skill.skill_name)
		anim = null
		txt.visible = false
		txt = null
		queue_free()
	else:
		push_error("Animation not found for skill: " + skill.skill_name)
		queue_free()
