extends Node
class_name Buff_Manager

signal done_apply

# Struktur data untuk menyimpan informasi buff
class Buff:
	var name: String
	var duration: int
	var value: float
	func _init(buff_name: String, buff_duration: int, buff_value: float):
		name = buff_name
		duration = buff_duration
		value = buff_value

# Array untuk menyimpan buff aktif
var active_buffs: Array[Buff] = []

# Fungsi untuk menambahkan buff
func add_buff(buff_name: String, duration: int, value: float):
	var new_buff = Buff.new(buff_name, duration, value)
	active_buffs.append(new_buff)
	print("Buff ditambahkan: " + buff_name + " (Durasi: " + str(duration) + ", Nilai: " + str(value) + ")")

# Fungsi untuk menghapus buff
func remove_buff(buff_name: String):
	for buff in active_buffs:
		if buff.name == buff_name:
			active_buffs.erase(buff)
			print("Buff dihapus: " + buff_name)
			return
	print("Buff tidak ditemukan: " + buff_name)

# Fungsi untuk menerapkan efek buff/debuff
func apply_buff_effects(monster: Monster_Controller):
	for buff in active_buffs:
		match buff.name:
			"Poison":
				monster.take_damage(buff.value)  # Contoh: Poison mengurangi HP sesuai nilai buff
				print(monster.name + " terkena efek Poison! (Damage: " + str(buff.value) + ")")
			"Stun":
				monster.action_point = 0  # Contoh: Stun menghilangkan action point
				print(monster.name + " terkena efek Stun!")
			"Strength Up":
				monster.stats.power += buff.value  # Contoh: Meningkatkan power
				print(monster.name + " mendapat Strength Up! (Power +" + str(buff.value) + ")")
			_:
				print("Buff/debuff tidak dikenali: " + buff.name)
		
		# Kurangi durasi buff
		buff.duration -= 1
		if buff.duration <= 0:
			remove_buff(buff.name)  # Hapus buff jika durasi habis
	emit_signal("done_apply")

# Fungsi untuk mengecek buff aktif
func has_buff(buff_name: String) -> bool:
	for buff in active_buffs:
		if buff.name == buff_name:
			return true
	return false
