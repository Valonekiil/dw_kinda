extends Node

@export var Buff_manager:Buff_Manager
@export var buff_1:Buff_Data
@export var buff_2:Buff_Data
@export var buff_3:Buff_Data

func _ready() -> void:
	if !Buff_manager:
		var t = get_node("Buff_Manager")
		if t:
			Buff_manager = get_node("Buff_Manager")
			
			
	Buff_manager.add_buff(buff_1)
	Buff_manager.add_buff(buff_2)
	#check_buff(buff_1)
	#check_buff(buff_2)
	#check_buff(buff_3)
	#ResourceSaver.save(buff_3)
	#ResourceSaver.save(buff_1)
	#ResourceSaver.save(buff_2)

func check_buff(v:Buff_Data):
	print("Sebelum")
	print("apakah manipulasi stats: " + str(v.stats_manipulation))
	print("apakah manipulasi elemen: " + str(v.element_manipulation))
	v.update_manipulation()
	print("sesudah")
	print("apakah manipulasi stats: " + str(v.stats_manipulation))
	print("apakah manipulasi elemen: " + str(v.element_manipulation))
	#ResourceSaver.save(v)


func _on_button_pressed() -> void:
	pass # Replace with function body.


func _on_btn_2_pressed() -> void:
	$RichTextLabel.text = "test ini text baru"

func _on_btn_1_pressed() -> void:
	$RichTextLabel.text = "[center]text pertama[/center]\n"
	$RichTextLabel.append_text("[right]text di append 1[/right]\n")
	$RichTextLabel.append_text("text di append 2\n")
	$RichTextLabel.append_text("text di append 3\n")
