extends Node2D

@export var type = 1
@onready var animated_sprite_2d = $AnimatedSprite2D

func _ready():
	if(type == 1): animated_sprite_2d.play("idle 1")
	if(type == 2): animated_sprite_2d.play("idle 2")
	if(type == 3): animated_sprite_2d.play("idle 3")


func _process(_delta):
	if(type == 1): animated_sprite_2d.play("idle 1")
	if(type == 2): animated_sprite_2d.play("idle 2")
	if(type == 3): animated_sprite_2d.play("idle 3")
