extends Node2D

@onready var active = 1
var quantity_hero = 0
@export var quantity_for_victory = 2
var check := false

func _ready() -> void:
	Events.hero_gone.connect(change_quantity)
	var hero_now = get_tree().get_nodes_in_group("hero")
	quantity_hero = hero_now.size()
	var i = 1
	for hero in hero_now:
		hero.player_id = i
		i += 1

func  _process(delta: float) -> void:
	if Input.is_action_just_pressed("switch_hero"):
		if active != quantity_hero:
			active += 1
		else:
			active = 1

func change_quantity(id_gone: int):
	quantity_hero -= 1
	var players = get_tree().get_nodes_in_group("hero")
	for player in players:
		if (player.player_id > id_gone):
			player.player_id -= 1
		if active != quantity_hero:
			active = 1
	if quantity_hero <= 0 and quantity_for_victory != 0:
		print("С")
	elif quantity_for_victory == 0:
		if check:
			print("П")
		check = true
		Events.all_win.emit()

func _on_area_2d_body_entered(body: Node2D) -> void:
	quantity_for_victory -= 1
	Events.win.emit(active)

func _on_dead_body_entered(body: Node2D) -> void:
	Events.hero_gone.emit(body.player_id)
	body.queue_free()
