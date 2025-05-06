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
	Enums.Element.Fire: 0,
	Enums.Element.Water: 0,
	Enums.Element.Earth: 0,
	Enums.Element.Nature: 0,
	Enums.Element.Wind: 0,
	Enums.Element.Lighting: 0,
	Enums.Element.Ice: 0,
	Enums.Element.Metal: 0,
	Enums.Element.Light: 0,
	Enums.Element.Dark: 0,
	Enums.Element.Chaos: 0,
	Enums.Element.Mystical: 0
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
