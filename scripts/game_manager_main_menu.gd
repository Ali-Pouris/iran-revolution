extends Node

@onready var iranSprite = $"../Iran/Sprite2D"
@onready var click_sound = $"../ClickSound"
@onready var play_button_anim = $"../MainMenu/PlayButtonAnim"
@onready var intro = $"../Intro"
@onready var protestor_audio = $"../protestorAudio"
@onready var color_rect = $"../../CanvasLayer/ColorRect"

const PROTESTER = preload("res://scenes/protester.tscn")

var isMouseInsideIran = false
var hold_timer: float = 0.0
#func _ready():
	#Ui.set_speed(2.0)

func _process(delta):
	if isMouseInsideIran and Input.is_action_pressed("left_click"):
		deploy_protester(delta)

func deploy_protester(delta) -> void:
		if Input.is_action_pressed("left_click"):
			hold_timer -= delta
			if hold_timer <= 0.0:
				if(!protestor_audio.playing):
					protestor_audio.play()
					#protestor_audio.volume_db -= 0.2
					if(protestor_audio.pitch_scale <= 1.2):
						protestor_audio.pitch_scale += 0.005
				hold_timer = 0.1   # reset cooldown
			else:
				hold_timer = 0.0  # reset when released
		var protester = PROTESTER.instantiate()
		protester.isGod = true
		protester.type = randi() % 3 + 1
		protester.position = get_viewport().get_mouse_position()
		if(color_rect.size.y > 216):
			protester.position.y = get_viewport().get_mouse_position().y - (color_rect.size.y - 216) / 2
		if(color_rect.size.x > 384):
			protester.position.x = get_viewport().get_mouse_position().x - (color_rect.size.x - 384) / 2 
		
		get_node("../YSort/Protesters").add_child(protester)



func _on_area_2d_mouse_entered():
	iranSprite.region_rect = Rect2(160,0,160,160)
	isMouseInsideIran = true

func _on_area_2d_mouse_exited():
	iranSprite.region_rect = Rect2(0,0,160,160)
	isMouseInsideIran = false


func _on_play_button_pressed():
	if(!intro.is_playing()):
		intro.play('outro')
		click_sound.play()
		play_button_anim.play("click")



func _on_button_area_2d_mouse_entered():
	play_button_anim.play("grow")


func _on_button_area_2d_mouse_exited():
	play_button_anim.play("shrink")


func _on_intro_animation_finished(anim_name):
	if(anim_name == "outro"):
		var x = get_tree()
		if(x):
			x.change_scene_to_file("res://scenes/game_level.tscn")
