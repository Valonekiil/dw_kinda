extends Node
class_name Buff_Manager

@export var stats: Stats_Component  # Komponen statistik yang akan dipengaruhi buff/debuff
var active_buffs: Array[Buff_Data] = []  # Daftar buff/debuff aktif
@export var buff_container: HBoxContainer  # Node untuk menampung TextureRect buff/debuff


# Fungsi untuk menambahkan buff/debuff
func add_buff(buff: Buff_Data):
	if buff:
		active_buffs.append(buff)
		create_buff_ui(buff)  # Buat UI untuk buff/debuff
		print("Buff/debuff ditambahkan: ", buff.buff_name)

# Fungsi untuk menghapus buff/debuff
func remove_buff(buff: Buff_Data):
	if buff in active_buffs:
		revert_buff(buff)  # Kembalikan efek buff/debuff
		active_buffs.erase(buff)
		remove_buff_ui(buff)  # Hapus UI buff/debuff
		print("Buff/debuff dihapus: ", buff.buff_name)

# Fungsi untuk mengaplikasikan buff/debuff
func apply_individual_effect(monster: Monster_Controller, buff: Buff_Data):
	stats.power += buff.power_changed
	stats.defense += buff.defense_changed
	stats.speed += buff.speed_changed
	
	for element in buff.element_changed:
		apply_element_resistance(element, buff.element_changed[element])

# Fungsi untuk mengembalikan efek buff/debuff
func revert_buff(buff: Buff_Data):
	if buff:
		# Kembalikan peningkatan/penurunan statistik dasar
		stats.power -= buff.power_changed
		stats.defense -= buff.defense_changed
		stats.speed -= buff.speed_changed

		# Kembalikan peningkatan/penurunan resistensi elemen
		for element in buff.element_changed:
			var amount = buff.element_changed[element]
			apply_element_resistance(element, -amount)  # Balikkan efeknya

		print("Buff/debuff dikembalikan: ", buff.buff_name)

# Fungsi untuk mengaplikasikan peningkatan/penurunan resistensi elemen
func apply_element_resistance(element: Enums.Element, amount: int):
	match element:
		Enums.Element.FIRE:
			stats.fire += amount
		Enums.Element.WATER:
			stats.water += amount
		Enums.Element.EARTH:
			stats.earth += amount
		Enums.Element.NATURE:
			stats.nature += amount
		Enums.Element.WIND:
			stats.wind += amount
		Enums.Element.LIGHTNING:
			stats.lightning += amount
		Enums.Element.ICE:
			stats.ice += amount
		Enums.Element.METAL:
			stats.metal += amount
		Enums.Element.LIGHT:
			stats.light += amount
		Enums.Element.DARK:
			stats.dark += amount
		Enums.Element.CHAOS:
			stats.chaos += amount
		Enums.Element.MYSTICAL:
			stats.mystical += amount
		_:
			print("Elemen tidak dikenali.")

func apply_buff_effects(monster: Monster_Controller):
	var buffs_to_remove = []
	
	for buff in active_buffs:
		apply_individual_effect(monster, buff)
		
		emit_signal("buff_applied", buff)
		await self.conf_buff_closed 
		
		buff.duration -= 1
		if buff.duration <= 0:
			buffs_to_remove.append(buff)
	
	for buff in buffs_to_remove:
		remove_buff(buff)
	
	emit_signal("done_apply")

# Fungsi untuk membuat UI buff/debuff
func create_buff_ui(buff: Buff_Data):
	if buff_container and buff.texture:
		var texture_rect = TextureRect.new()
		texture_rect.texture = buff.texture
		texture_rect.name = buff.buff_name
		texture_rect.stretch_mode = TextureRect.STRETCH_SCALE  # Scaling bisa diubah
		texture_rect.custom_minimum_size = Vector2(64, 64)  # Ukuran minimal

		var label = Label.new()
		label.name = "Duration"
		label.text = str(buff.duration)
		label.vertical_alignment =VERTICAL_ALIGNMENT_BOTTOM
		label.horizontal_alignment= HORIZONTAL_ALIGNMENT_CENTER
		label.modulate = Color(1, 1, 1, 1)  # Warna teks putih

		texture_rect.add_child(label)
		buff_container.add_child(texture_rect)

# Fungsi untuk menghapus UI buff/debuff
func remove_buff_ui(buff: Buff_Data):
	if buff_container:
		for child in buff_container.get_children():
			if child.name == buff.buff_name:
				child.queue_free()  # Hapus TextureRect dari scene

# Fungsi untuk memperbarui durasi buff/debuff
func update_buff_duration(buff: Buff_Data, new_duration: int):
	if buff_container:
		for child in buff_container.get_children():
			if child.name == buff.buff_name:
				var label = child.get_node("Duration")
				if label:
					label.text = str(new_duration)
					print("Durasi buff/debuff diperbarui: ", buff.buff_name, " -> ", new_duration)
