extends CharacterBody2D

@export var SPEED:float
@onready var tile = get_tree().current_scene.find_child("TileMap")
@onready var location:Label = $CanvasLayer/VBoxContainer/Label

var step_size = 30
var curstep = 0
var step = 0

var area: String = "":
	set(val):
		area = val
		location.text = val

var step_taken: float = 0.0:
	set(val):
		step_taken = val
		step = int(step_taken / step_size)
		$CanvasLayer/VBoxContainer/HBoxContainer/Label.text = "%d" % step
		
		print("Step taken: ", step_taken, " | Step: ", step)
		
		if step > curstep:
			if step % 2 == 0:
				var v = randi_range(1, 20)
				print("Random check: ", v)
				if v > 18:
					#set_physics_process(false)
					#SceneManager.save_player_data(self)
					#SceneManager.battle_called()
					pass
			curstep = step

func _ready() -> void:
	if SceneManager.battled:
		position = SceneManager.last_post

func isometric_convert(value):
	return Vector2(value.x - value.y, (value.x + value.y) / 2)

func _physics_process(delta: float) -> void:
	var initpos = position
	var direction = Vector2()
	
	if Input.is_action_pressed("ui_up"):
		direction += Vector2(0, -1)
	elif Input.is_action_pressed("ui_down"):
		direction += Vector2(0, 1)
	elif Input.is_action_pressed("ui_left"):
		direction += Vector2(-1, 0)
	elif Input.is_action_pressed("ui_right"):
		direction += Vector2(1, 0)
	
	if direction != Vector2.ZERO:
		direction = direction.normalized()
		var motion = isometric_convert(direction) * SPEED
		velocity = motion
		move_and_slide()
	
	var distance_moved = initpos.distance_squared_to(position)
	if distance_moved > 0:
		step_taken += sqrt(distance_moved)
	
	update_tile()

func update_tile():
	if tile:
		var map_pos = tile.local_to_map(position)
		var tiledata = tile.get_cell_tile_data(0, map_pos)
		if tiledata:
			var new_area = tiledata.get_custom_data("Area")
			if new_area:
				area = new_area
