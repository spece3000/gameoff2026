extends CharacterBody2D

@export var square_path = preload("res://scene/hero/square.tscn")
const HOLD_DURATION = 1.0

var hold_timer: float = 0.0
var action_performed: bool = false
var is_win = false
var check := true

const SPEED = 300.0
const JUMP_VELOCITY = -420.0
@onready var anim = $AnimatedSprite2D
@export var push_force: float = 400.0

@onready var on_player = $RayCast2D
@onready var on_player2 = $RayCast2D2
@onready var on_player3 = $RayCast2D5
@onready var on_player_up = $RayCast2D3
@onready var on_player_up2 = $RayCast2D4

@onready var action_manager = get_parent()
@export var player_id := 1 

var balls_in_area: Array[RigidBody2D] = []

func _ready() -> void:
	add_to_group("hero")
	Events.win.connect(win)
	Events.all_win.connect(all_win)

func _physics_process(delta: float) -> void:
	var is_active = action_manager.active
	if is_active == player_id:
		if Input.is_action_just_pressed("jump") and !is_win and is_on_floor() and !on_player.is_colliding() and !on_player2.is_colliding() and !on_player_up.is_colliding() and !on_player_up2.is_colliding() and !on_player3.is_colliding():
			velocity.y = JUMP_VELOCITY
			anim.play("jump")
		
		if velocity.y > 0:
			anim.play("fall")
		
		var direction := Input.get_axis("left", "right")
		if direction and !on_player_up.is_colliding() and !on_player_up2.is_colliding():
			velocity.x = direction * SPEED
			if velocity.y == 0 and !is_win:
				anim.play("run")
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			if velocity.y == 0 and !Input.is_action_pressed("down") and !is_win:
				anim.play("idle")
		if direction == -1 and !is_win:
			$AnimatedSprite2D.flip_h = true
		elif direction == 1 and !is_win:
			$AnimatedSprite2D.flip_h = false
		
		if Input.is_action_pressed("down") and is_on_floor() and !direction and !is_win:
			anim.play("down")
			if not action_performed:
				hold_timer += delta
				if hold_timer >= HOLD_DURATION:
					action_performed = true
					var square = square_path.instantiate()
					square.scale.x = 0.2
					square.scale.y = 0.2
					square.global_position.x = global_position.x
					square.global_position.y = global_position.y + 8
					Events.hero_gone.emit(player_id)
					add_sibling(square)
					queue_free()
		else:
			hold_timer = 0.0
			action_performed = false
		
		if direction != 0:
			for ball in balls_in_area:
				if not is_instance_valid(ball):
					continue
				var dir := ball.global_position - global_position
				if dir.length() < 1.0:
					continue
				dir = dir.normalized()
				ball.apply_central_force(dir * push_force)
		
		if is_win:
			velocity.x = 0
			anim.play("win")
			set_collision_mask_value(4, false)
			set_collision_layer_value(1, false)
			if check:
				Events.hero_gone.emit(player_id)
				check = false
		
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	move_and_slide()

func win(active: int):
	if player_id == active:
		is_win = true

func all_win():
	is_win = true

func _on_area_2d_body_entered(body: Node2D) -> void:
	balls_in_area.append(body)

func _on_area_2d_body_exited(body: Node2D) -> void:
	balls_in_area.erase(body)
