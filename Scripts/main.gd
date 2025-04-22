extends Node2D

@onready var heart_scene = preload("res://Scenes/life.tscn")
@onready var player = $Player  # Ajuste o caminho conforme necessário

var hearts = []

func _ready():
	update_health()  # Exibe os corações no começo
	player.health_changed.connect(update_health)  # Conecta o sinal

func update_health():
	# Pega vida atual e máxima direto do jogador
	var max_health = player.max_health
	var current_health = player.current_health

	# Limpa corações anteriores
	for heart in hearts:
		heart.queue_free()
	hearts.clear()

	var health = current_health
	var position = Vector2(20, 20)
	for i in range(max_health):
		var heart_instance = heart_scene.instantiate()
		heart_instance.position = position
		add_child(heart_instance)

		if health >= 1:
			heart_instance.state = heart_instance.HeartState.FULL
			health -= 1
		elif health == 0.5:
			heart_instance.state = heart_instance.HeartState.HALF
			health -= 0.5
		else:
			heart_instance.state = heart_instance.HeartState.EMPTY

		heart_instance.update_heart()
		position.x += 26
		hearts.append(heart_instance)
