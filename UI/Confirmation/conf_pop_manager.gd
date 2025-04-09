extends Control
class_name Conf_Manager

@onready var box = $Confirmation_Box
@onready var context = $RichTextLabel
@onready var btn = $Close_Btn
var tween: Tween
var twin: Tween

func _ready() -> void:
	print(context)
	box.visible = false
	context.visible = false
	btn.visible = false
	context.bbcode_enabled = true

func Animate_Conf():
	box.visible = true
	context.visible = true
	context.visible_ratio = 0
	tween = create_tween()
	print("tween1")
	tween.connect("finished", self.on_tween_finished)
	tween.tween_property(context, "visible_ratio", 1, 0.5).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
	tween.play()

func on_tween_finished():
	btn.visible = true
	btn.grab_focus()

func Monster_Turn(cur: Monster_Controller):
	context.text = "Giliran [b]"+cur.monster.name+"[/b] melakukan aksi"
	Animate_Conf()
func Monster_Turn_End(cur: Monster_Controller):
	context.text = "Giliran [b]"+cur.monster.name+"[/b] telah berakhir"
	Animate_Conf()
func Monster_Attack(cur:Monster_Controller):
	context.text = "[b]"+cur.monster.name+"[/b] melakukan serangan"
	Animate_Conf()
func Monster_Defense(cur:Monster_Controller):
	context.text = "[b]"+cur.monster.name+"[/b] sedang bertahan"
	Animate_Conf()
func Monster_Take_Damage(cur:Monster_Controller, count:int):
	context.text = "[b]"+cur.monster.name+"[/b] menerima telak serangan sebesar " +str(count) 
	Animate_Conf()
func Monster_Defensed_Damage(cur:Monster_Controller, count:int):
	context.text = "[b]"+cur.monster.name+"[/b] berhasil melakukan defense dan hanya menerima " +str(count) + " damage"
	Animate_Conf()
func Monster_Buffed(buff:Buff_Data,cur:Monster_Controller):
	if buff.is_debuff:
		context.text = "[b]"+cur.monster.name+"[/b] menerima [color=red]debuff "+ buff.buff_name +"[/color]"
	else :
		context.text = "[b]"+cur.monster.name+"[/b] menerima [color=green]buff "+ buff.buff_name +"[/color]"
	Animate_Conf()

func Buff_Activated(buff:Buff_Data):
	var count:int = 1
	context.text = "[center][b]"+ buff.buff_name + " aktif[/b][/center]" 
	if buff.stun:
		count += 1
		context.append_text("[left] Monster terkena stun [/left]")
	if buff.damage:
		count += 1
		context.append_text("[left] Monster terkena damage sebesar " + str(buff.damage)  + "[/left]")
	if buff.heal:
		count += 1
		context.append_text("[left] HP Monster pulih sebesar " + str(buff.heal)  + "[/left]")
	if buff.stats_manipulation:
		var stats = {
			"Power": buff.power_changed,
			"Defense": buff.defense_changed,
			"Arcane": buff.arcane_changed,
			"Insight": buff.insight_changed,
			"Speed": buff.speed_changed
		}
		print("confirm_stat_manipulation")
		for stat in stats:
			var value = stats[stat]
			if value != 0:
				if value > 0:
					count += 1
					context.append_text("[left] %s monster meningkat sebesar %d [/left]" % [stat, value])
				else:
					count += 1
					context.append_text("[left] %s monster berkurang sebesar %d [/left]" % [stat, abs(value)])
	if buff.element_manipulation:
		var element_names = {
			Enums.Element.FIRE: "Fire",
			Enums.Element.WATER: "Water",
			Enums.Element.EARTH: "Earth",
			Enums.Element.NATURE: "Nature",
			Enums.Element.WIND: "Wind",
			Enums.Element.LIGHTNING: "Lightning",
			Enums.Element.ICE: "Ice",
			Enums.Element.METAL: "Metal",
			Enums.Element.LIGHT: "Light",
			Enums.Element.DARK: "Dark",
			Enums.Element.CHAOS: "Chaos",
			Enums.Element.MYSTICAL: "Mystical"
		}
		print("confirm_element_manipulation")
		for element in buff.element_changed:
			var value = buff.element_changed[element]
			if value != 0:
				var element_name = element_names.get(element, "Unknown")
				if value > 0:
					count += 1
					context.append_text("[left]affinity %s monster meningkat sebesar %d [/left]" % [element_name, value])
				else:
					count += 1
					context.append_text("[left]affinity %s monster berkurang sebesar %d [/left]" % [element_name, abs(value)])
	box.visible = true
	context.visible = true
	context.visible_ratio = 0
	print("buff ui " + buff.buff_name + " dengan efek: " + str(count))
	twin = create_tween()
	twin.connect("finished", self.on_tween_finished)
	print("tween2")
	twin.tween_property(context, "visible_ratio", 1, 0.7*count).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
	twin.play()

func _on_close_btn_pressed() -> void:
	print("button pressed")
	box.visible = false
	btn.visible = false
	context.visible = false


func _on_timer_timeout() -> void:
	btn.emit_signal("pressed")
