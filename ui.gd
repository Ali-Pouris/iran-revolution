extends CanvasLayer

@onready var guid = $Control/Control/Guid
@onready var easy_button = $Control2/FoldableContainer/Control/EasyButton
@onready var medium_button = $Control2/FoldableContainer/Control/MediumButton
@onready var hard_button = $Control2/FoldableContainer/Control/HardButton
@onready var impossible_button = $Control2/FoldableContainer/Control/ImpossibleButton
@onready var color_rect = $CanvasLayerBG/ColorRect
@onready var click_sound = $ClickSound

var tween: Tween
var mat: ShaderMaterial
#var elapsed_time: float = 0.0

func _ready():
	mat = color_rect.material
	if(easy_button && hard_button && impossible_button):
		if(Global.difficulty == 1):
			easy_button.modulate.a = 1.0
			medium_button.modulate.a = 0.6
			hard_button.modulate.a = 0.6
			impossible_button.modulate.a = 0.6
		if(Global.difficulty == 2):
			easy_button.modulate.a = 0.6
			medium_button.modulate.a = 1.0
			hard_button.modulate.a = 0.6
			impossible_button.modulate.a = 0.6
		if(Global.difficulty == 3):
			easy_button.modulate.a = 0.6
			medium_button.modulate.a = 0.6
			hard_button.modulate.a = 1.0
			impossible_button.modulate.a = 0.6
		if(Global.difficulty == 4):
			easy_button.modulate.a = 0.6
			medium_button.modulate.a = 0.6
			hard_button.modulate.a = 0.6
			impossible_button.modulate.a = 1.0

#func _process(delta: float) -> void:
	#if mat:
		#if(elapsed_time > 6.31): elapsed_time = 0
		#elapsed_time += delta
		#mat.set_shader_parameter("custom_time", elapsed_time)
		
		
func set_speed(value: float) -> void:
	if mat is ShaderMaterial:
		# Kill old tween if one exists
		if tween:
			tween.kill()
		
		var current_speed = mat.get_shader_parameter("speed")
		
		# Create a new tween
		tween = create_tween()
		tween.tween_method(
			func(new_val): mat.set_shader_parameter("speed", new_val),
			current_speed,   # from
			value,           # to
			1.0              # duration (1s)
		)

func _on_guid_button_pressed():
	click_sound.play()
	if(guid):
		guid.visible = !guid.visible


func _on_guid_close_guid():
	click_sound.play()
	if(guid):
		guid.visible = false


func _on_restart_button_pressed():
	click_sound.play()
	get_tree().reload_current_scene()
	


func _on_exit_button_pressed():
	click_sound.play()
	var current_scene = get_tree().current_scene
	if current_scene.name == "GameLevel":
		get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
	elif current_scene.name == "MainMenu":
		get_tree().quit()

func set_sounds_defaults():
	var music_bus_index = AudioServer.get_bus_index("Music")
	var musix_is_muted = AudioServer.is_bus_mute(music_bus_index)

	var btn = get_node('%MusicButton')
	if musix_is_muted:
		btn.modulate.a = 0.5
	else:
		btn.modulate.a = 1.0
	
	var sfx_bus_index = AudioServer.get_bus_index("SFX")
	var sfx_is_muted = AudioServer.is_bus_mute(sfx_bus_index)
	var sfxbtn = get_node('%SFXButton')
	if sfx_is_muted:
		sfxbtn.modulate.a = 0.5
	else:
		sfxbtn.modulate.a = 1.0

func toggle_bus(bus_name: String) -> void:
	var bus_index = AudioServer.get_bus_index(bus_name)
	var is_muted = AudioServer.is_bus_mute(bus_index)
	AudioServer.set_bus_mute(bus_index, !is_muted)

func _on_music_button_pressed():
	click_sound.play()
	toggle_bus("Music")

	var bus_index = AudioServer.get_bus_index("Music")
	var is_muted = AudioServer.is_bus_mute(bus_index)

	var btn = get_node('%MusicButton')
	if is_muted:
		btn.modulate.a = 0.5
	else:
		btn.modulate.a = 1.0
		


func _on_sfx_button_pressed():
	click_sound.play()
	toggle_bus("SFX")

	var bus_index = AudioServer.get_bus_index("SFX")
	var is_muted = AudioServer.is_bus_mute(bus_index)

	var btn = get_node('%SFXButton')
	if is_muted:
		btn.modulate.a = 0.5
	else:
		btn.modulate.a = 1.0


func _on_full_screen_button_pressed():
	click_sound.play()
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)


func _on_easy_button_pressed():
	click_sound.play()
	Global.difficulty = 1
	easy_button.modulate.a = 1.0
	medium_button.modulate.a = 0.6
	hard_button.modulate.a = 0.6
	impossible_button.modulate.a = 0.6

func _on_medium_button_pressed():
	click_sound.play()
	Global.difficulty = 2
	easy_button.modulate.a = 0.6
	medium_button.modulate.a = 1.0
	hard_button.modulate.a = 0.6
	impossible_button.modulate.a = 0.6

func _on_hard_button_pressed():
	click_sound.play()
	Global.difficulty = 3
	easy_button.modulate.a = 0.6
	medium_button.modulate.a = 0.6
	hard_button.modulate.a = 1.0
	impossible_button.modulate.a = 0.6


func _on_impossible_button_pressed():
	click_sound.play()
	Global.difficulty = 4
	easy_button.modulate.a = 0.6
	medium_button.modulate.a = 0.6
	hard_button.modulate.a = 0.6
	impossible_button.modulate.a = 1.0


func _on_foldable_container_folding_changed(is_folded):
	click_sound.play()
