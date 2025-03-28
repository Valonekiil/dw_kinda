extends Resource
class_name Buff_Data

@export var buff_name: String 
@export var texture: Texture2D 
@export var duration: int
@export var is_debuff: bool
@export var stun: bool
@export var heal: int
@export var damage: int
@export var stats_manipulation: bool 
@export var power_changed: int
@export var defense_changed: int 
@export var arcane_changed: int
@export var insight_changed: int
@export var speed_changed: int 
@export var element_manipulation: bool
@export var element_changed: Dictionary = {
	Enums.Element.FIRE: 0,
	Enums.Element.WATER: 0,
	Enums.Element.EARTH: 0,
	Enums.Element.NATURE: 0,
	Enums.Element.WIND: 0,
	Enums.Element.LIGHTNING: 0,
	Enums.Element.ICE: 0,
	Enums.Element.METAL: 0,
	Enums.Element.LIGHT: 0,
	Enums.Element.DARK: 0,
	Enums.Element.CHAOS: 0,
	Enums.Element.MYSTICAL: 0
}


# Fungsi untuk mengupdate variabel manipulation
func update_manipulation():
	stats_manipulation = (
		power_changed != 0 or
		defense_changed != 0 or
		arcane_changed != 0 or
		insight_changed != 0 or
		speed_changed != 0
	)
	
	element_manipulation = false
	for element in element_changed:
		if element_changed[element] != 0:
			element_manipulation = true
			break

# Fungsi yang dipanggil saat resource diubah di editor
func _validate_property(property: Dictionary):
	if property.name in ["stats_manipulation", "element_manipulation"]:
		property.usage = PROPERTY_USAGE_NO_EDITOR  # Sembunyikan dari Inspector

# Fungsi yang dipanggil saat resource disimpan
func _post_save():
	update_manipulation()
