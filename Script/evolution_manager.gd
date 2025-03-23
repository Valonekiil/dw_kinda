extends Node
class_name Evolution_Manager

@export var base_form: Monster_Controller
@export var evolution_1: Monster_Controller
@export var evolution_2: Monster_Controller
var is_evolved:bool

# Fungsi untuk mengubah monster ke bentuk evolusi
func evolve_to_evolution(evolution: Monster_Controller):
	if evolution == evolution_1 or evolution == evolution_2:
		base_form.queue_free()  # Hapus bentuk dasar
		add_child(evolution)  # Tambahkan bentuk evolusi
		print("Monster berevolusi ke " + evolution.name)
	else:
		print("Evolusi tidak valid")

# Fungsi untuk mengembalikan monster ke bentuk dasar
func back_to_base_form():
	if evolution_1:
		evolution_1.queue_free()
	if evolution_2:
		evolution_2.queue_free()
	add_child(base_form)
	print("Monster kembali ke bentuk dasar")
