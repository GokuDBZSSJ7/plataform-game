extends CharacterBody2D

@onready var _animated_sprite = $AnimatedSprite2D
@export var speed: float = 200.0
@export var jump_force: float = 400.0
@export var gravity: float = 1200.0
var attack_index := 0
var is_attacking := false
var attack_duration := 0.5 
var attack_timer := 0.0

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta
		if not is_attacking:
			_animated_sprite.play("jump")
	else:
		if Input.is_action_just_pressed("ui_accept"):
			velocity.y = -jump_force
			if not is_attacking:
				_animated_sprite.play("jump")
	
	var direction = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	if abs(direction) < 0.1:
		direction = 0
	velocity.x = direction * speed
	
	if not is_attacking:
		if direction != 0:
			_animated_sprite.play("run")
		elif direction == 0:
			_animated_sprite.play("Idle")
	
	if direction != 0:
		_animated_sprite.flip_h = direction < 0
	
	if is_attacking:
		attack_timer += delta
		if attack_timer >= attack_duration:
			attack_timer = 0.0  
			is_attacking = false
			if velocity.x == 0:
				_animated_sprite.play("Idle")
			else:
				_animated_sprite.play("run")

	move_and_slide()

func perform_attack():
	if is_attacking:
		return  # Não inicia novo ataque enquanto o anterior não terminar
	
	is_attacking = true
	attack_index += 1
	
	if attack_index > 3:
		attack_index = 1
	
	_animated_sprite.play("attack" + str(attack_index))

func _input(event):
	if event.is_action_pressed("Attack"):
		perform_attack()

signal health_changed

@export var max_health : int = 3
var current_health: float = 3.0

func take_damage(amount: float):
	current_health -= amount
	if current_health < 0:
		current_health = 0
	emit_signal("health_changed")

func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		print("FOI")
		take_damage(0.5)
