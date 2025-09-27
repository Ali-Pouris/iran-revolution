extends Node

const PROTESTER = preload("res://scenes/protester.tscn")

@export var isMainMenu = false
@onready var label = %Label
@onready var iranSprite = $"../Iran/Sprite2D"
@onready var protester_active_button_1 = $"../Ui/Active/ProtesterActiveButton1"
@onready var protester_active_button_2 = $"../Ui/Active/ProtesterActiveButton2"
@onready var protester_active_button_3 = $"../Ui/Active/ProtesterActiveButton3"
@onready var money_label = $"../Ui/Score/MoneyLabel"
@onready var fighting_label_1 = $"../Ui/Node2D/FightingLabel1"
@onready var fighting_label_2 = $"../Ui/Node2D/FightingLabel2"
@onready var fighting_label_3 = $"../Ui/Node2D/FightingLabel3"
@onready var goal_label = %GoalLabel
@onready var one_city_lock = $"../Ui/Active/OneCityLock"
@onready var two_city_lock = $"../Ui/Active/TwoCityLock"
@onready var protester_buy_button_2 = $"../Ui/Active/ProtesterBuyButton2"
@onready var protester_buy_button_3 = $"../Ui/Active/ProtesterBuyButton3"
@onready var protester_buy_button_5 = $"../Ui/Active/ProtesterBuyButton5"
@onready var protester_buy_button_6 = $"../Ui/Active/ProtesterBuyButton6"
@onready var notif = $"../Ui/notif"
@onready var animation_notif_player = $"../Ui/AnimationNotifPlayer"
@onready var victory = $"../Victory"
@onready var ui = $"../Ui"
@onready var player_record = $"../playerRecord"
@onready var cpu_particles = $"../Iran/CPUParticles2D"
@onready var color_rect = $"../CanvasLayerBG/ColorRect"
@onready var protesters = $"../YSort/Protesters"
@onready var unlock_audio = $"../unlockAudio"
@onready var main_animation = $"../mainAnimation"
@onready var protestor_audio = $"../protestorAudio"
@onready var win_audio = $"../winAudio"

var money: int = 900

var isWon = false
var elapsed_time: float = 0.0
var started: bool = false

var unlockSound1PlayedOnce = false
var unlockSound2PlayedOnce = false

var protester_costs := {
	1: 10,
	2: 25,
	3: 50
}

var protester_stock := {
	1: 100,
	2: 0,
	3: 0
}

var active_type: int = 1

var isMouseInsideIran = false

var hold_timer: float = 0.0
var winSoundPlayed = false

func _ready():
	#Ui.set_speed(0.0)
	winSoundPlayed = false
	elapsed_time = 0.0
	player_record.position = Vector2(62,0)
	Global.tower_destroyed = 0
	



func _process(delta):

		
	if(Global.tower_destroyed == 0):
		cpu_particles.speed_scale = 0.2
		cpu_particles.color = Color(1.0, 1.0, 1.0, 1.0)
	if(Global.tower_destroyed == 1):
		cpu_particles.speed_scale = 0.2
		cpu_particles.color = Color(1.0, 1.0, 0.878, 1.0)
	if(Global.tower_destroyed == 2):
		cpu_particles.speed_scale = 0.3
		cpu_particles.color = Color(1.0, 1.0, 0.0, 1.0)
	if(Global.tower_destroyed == 3):
		cpu_particles.speed_scale = 0.4
		cpu_particles.color = Color(1.0, 0.827, 0.0, 1.0)
	if(Global.tower_destroyed == 4):
		cpu_particles.speed_scale = 0.5
		cpu_particles.color = Color(1.0, 0.647, 0.0, 1.0)
	if(Global.tower_destroyed == 5):
		cpu_particles.speed_scale = 0.6
		cpu_particles.color = Color(1.0, 0.439, 0.0, 1.0)
	if(Global.tower_destroyed == 6):
		cpu_particles.speed_scale = 0.7
		cpu_particles.color = Color(1.0, 0.208, 0.0, 1.0)
	if(Global.tower_destroyed == 7):
		cpu_particles.speed_scale = 0.8
		cpu_particles.color = Color(1.0, 0.055, 0.0, 1.0)
	if(Global.tower_destroyed == 7):
		if(!winSoundPlayed):
			win_audio.play()
			winSoundPlayed = true
		cpu_particles.emitting = false
		isWon = true
		victory.visible = true
		ui.visible = false
		player_record.position = Vector2(221,113)
	player_record.text = get_formatted_time()
	
	if not started and Input.is_action_just_pressed("left_click"):
		started = true
	if started and not isWon:
		elapsed_time += delta
	if(isWon): return
	if Input.is_action_just_released("left_click"):
		protestor_audio.volume_db = 0.0
		protestor_audio.pitch_scale = 1.0
	if isMouseInsideIran and Input.is_action_pressed("left_click"):
		deploy_protester(delta)
	if(money_label):
		money_label.text = str(money)
	if(protester_active_button_1 && protester_active_button_2 && protester_active_button_3):
		protester_active_button_1.count = protester_stock[1]
		protester_active_button_2.count = protester_stock[2]
		protester_active_button_3.count = protester_stock[3]
		protester_active_button_1.active = active_type == 1
		protester_active_button_2.active = active_type == 2
		protester_active_button_3.active = active_type == 3
	
	var towers_parent = get_node("../YSort/Towers")
	var alive_towers = 0
	for tower in towers_parent.get_children():
		if not tower.is_queued_for_deletion() and tower.hp > 0:
			alive_towers += 1
	
	Global.tower_destroyed = 7 - alive_towers
	if(goal_label):
		goal_label.text = "Goal: %d / 7" % Global.tower_destroyed
	
	if(one_city_lock && protester_buy_button_2 && protester_buy_button_5 && protester_buy_button_6 && protester_active_button_2 && two_city_lock && protester_buy_button_3 && protester_active_button_3):

		if(Global.tower_destroyed >= 1): 
			one_city_lock.visible = false 
			protester_buy_button_2.visible = true
			protester_buy_button_5.visible = true
			protester_active_button_2.visible = true
		else:
			unlockSound1PlayedOnce = false
			one_city_lock.visible = true 
			protester_buy_button_2.visible = false
			protester_buy_button_5.visible = false
			protester_active_button_2.visible = false
		if(Global.tower_destroyed >= 2): 
			two_city_lock.visible =false 
			protester_buy_button_3.visible = true
			protester_buy_button_6.visible = true
			protester_active_button_3.visible = true
		else: 
			unlockSound2PlayedOnce = false
			two_city_lock.visible = true 
			protester_buy_button_3.visible = false
			protester_buy_button_6.visible = false
			protester_active_button_3.visible = false
		if(Global.tower_destroyed == 1 && !unlockSound1PlayedOnce): 
			unlock_audio.play()
			unlockSound1PlayedOnce = true
		if(Global.tower_destroyed == 2 && !unlockSound2PlayedOnce):
			unlock_audio.play()
			unlockSound2PlayedOnce = true
	if(!isMainMenu):
		process_protesters()

func get_formatted_time() -> String:
	var total_ms = int(elapsed_time * 1000)
	var hours = total_ms / (100 * 60 * 60)
	var minutes = (total_ms / (1000 * 60)) % 60
	var seconds = (total_ms / 1000) % 60
	var milliseconds = total_ms % 1000
	return "%02d:%02d:%02d:%03d" % [hours, minutes, seconds, milliseconds]
	
func process_protesters():
	var protesters_parent = get_node("../YSort/Protesters")
	var type1_sum = 0
	var type2_sum = 0
	var type3_sum = 0
	
	for protester in protesters_parent.get_children():
		if(protester.type == 1): type1_sum += 1
		if(protester.type == 2): type2_sum += 1
		if(protester.type == 3): type3_sum += 1
	if(fighting_label_1 && fighting_label_2 && fighting_label_3):
		fighting_label_1.text = str(type1_sum)
		fighting_label_2.text = str(type2_sum)
		fighting_label_3.text = str(type3_sum)

func buy_protester(p_type: int, amount: int = 1) -> void:
	var cost = protester_costs[p_type] * amount
	if money >= cost:
		money -= cost
		#protester_stock[p_type] += amount
		protester_stock[p_type] += 10
		#print("Bought %d protesters of type %d. Remaining money: %d" % [amount, p_type, money])
	else:
		pass
		#print("Not enough money!")

func deploy_protester(delta) -> void:

	if protester_stock[active_type] > 0:
		if Input.is_action_pressed("left_click"):
			hold_timer -= delta
			if hold_timer <= 0.0:
				if(!protestor_audio.playing):
					protestor_audio.play()
					#protestor_audio.volume_db -= 0.2
					if(protestor_audio.pitch_scale <= 1.2):
						protestor_audio.pitch_scale += 0.005
					else: 
						protestor_audio.volume_db -= 0.2
				hold_timer = 0.1   # reset cooldown
			else:
				hold_timer = 0.0  # reset when released
		var protester = PROTESTER.instantiate()
		
		protester.position = get_viewport().get_mouse_position()
		if(color_rect.size.y > 216):
			protester.position.y = get_viewport().get_mouse_position().y - (color_rect.size.y - 216) / 2
		if(color_rect.size.x > 384):
			protester.position.x = get_viewport().get_mouse_position().x - (color_rect.size.x - 384) / 2 

		protester.type = active_type
		get_node("../YSort/Protesters").add_child(protester)
		
		protester_stock[active_type] -= 1
		#print("Deployed type %d. Remaining stock: %d" % [active_type, protester_stock[active_type]])
	else:
		if(animation_notif_player && notif && !animation_notif_player.is_playing()):
			animation_notif_player.play("fade_in")
			notif.type = active_type
		#print("No stock left for type %d" % active_type)

func set_active_type(p_type: int) -> void:
	if p_type in protester_stock:
		active_type = p_type
		#print("Active type set to %d" % active_type)

func _on_area_2d_mouse_entered():
	iranSprite.region_rect = Rect2(160,0,160,160)
	isMouseInsideIran = true


func _on_area_2d_mouse_exited():
	iranSprite.region_rect = Rect2(0,0,160,160)
	isMouseInsideIran = false


func _on_protester_active_button_1_pressed():
	set_active_type(1)


func _on_protester_active_button_2_pressed():
	set_active_type(2)


func _on_protester_active_button_3_pressed():
	set_active_type(3)


func _on_protester_buy_button_1_pressed():
	buy_protester(1)


func _on_protester_buy_button_2_pressed():
	buy_protester(2)


func _on_protester_buy_button_3_pressed():
	buy_protester(3)


func onTowerDie(reward_money):
	money += reward_money
	#if(Global.tower_destroyed <= 7):
		#Global.tower_destroyed += 1
	#goal_label.text = 'Goal: ' + str(Global.tower_destroyed) + ' / 7'

func onTowerUp():
	pass
	#if(Global.tower_destroyed > 0):
		#Global.tower_destroyed -= 1
	#goal_label.text = 'Goal: ' + str(Global.tower_destroyed) + ' / 7'
	
func _on_tower_tower_died(reward_money):
	onTowerDie(reward_money)


func _on_tower_2_tower_died(reward_money):
	onTowerDie(reward_money)


func _on_tower_3_tower_died(reward_money):
	onTowerDie(reward_money)


func _on_tower_4_tower_died(reward_money):
	onTowerDie(reward_money)


func _on_tower_5_tower_died(reward_money):
	onTowerDie(reward_money)


func _on_tower_6_tower_died(reward_money):
	onTowerDie(reward_money)


func _on_tower_7_tower_died(reward_money):
	onTowerDie(reward_money)


func _on_tower_tower_up():
	onTowerUp()


func _on_tower_2_tower_up():
	onTowerUp()


func _on_tower_3_tower_up():
	onTowerUp()


func _on_tower_4_tower_up():
	onTowerUp()


func _on_tower_5_tower_up():
	onTowerUp()


func _on_tower_6_tower_up():
	onTowerUp()


func _on_tower_7_tower_up():
	onTowerUp()


func _on_play_button_pressed():
	get_tree().reload_current_scene()


func _on_protester_buy_button_4_pressed():
	while (money >= 10):
		buy_protester(1)
	

func _on_protester_buy_button_5_pressed():
	while (money >= 25):
		buy_protester(2)

func _on_protester_buy_button_6_pressed():
	while (money >= 50):
		buy_protester(3)
