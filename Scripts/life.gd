extends Node2D

@onready var heart_sprite = $HeartSprite

enum HeartState {FULL, HALF, EMPTY}
var state : HeartState = HeartState.FULL

@export var full_heart : Texture
@export var half_heart : Texture
@export var empty_heart : Texture

func update_heart():
	match state:
		HeartState.FULL:
			heart_sprite.texture = full_heart
		HeartState.HALF:
			heart_sprite.texture = half_heart
		HeartState.EMPTY:
			heart_sprite.texture = empty_heart

func _ready():
	update_heart()
