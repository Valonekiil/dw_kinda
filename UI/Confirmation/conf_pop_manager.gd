extends Control
class_name Conf_Manager

@onready var box = $Confirmation_Box
@onready var context = $RichTextLabel
@onready var btn = $Close_Btn
var tween: Tween

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
	tween.connect("finished", self.on_tween_finished)
	tween.tween_property(context, "visible_ratio", 1, 0.5).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
	tween.play()

func on_tween_finished():
	btn.visible = true
	btn.grab_focus()

func Monster_Turn(cur: Monster_Controller):
	context.text = "Giliran [b]"+cur.name+"[/b] melakukan aksi"
	Animate_Conf()
func Monster_Attack(cur:Monster_Controller):
	context.text = "[b]"+cur.name+"[/b] melakukan serangan"
	Animate_Conf()
func Monster_Defense(cur:Monster_Controller):
	context.text = "[b]"+cur.name+"[/b] sedang bertahan"
	Animate_Conf()
func Monster_Take_Damage(cur:Monster_Controller, count:int):
	context.text = "[b]"+cur.name+"[/b] menerima telak serangan sebesar " +str(count) 
	Animate_Conf()
func Monster_Defensed_Damage(cur:Monster_Controller, count:int):
	context.text = "[b]"+cur.name+"[/b] berhasil melakukan defense dan hanya menerima " +str(count) + " damage"
	Animate_Conf()
func _on_close_btn_pressed() -> void:
	box.visible = false
	btn.visible = false
	context.visible = false
