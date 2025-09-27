extends Area2D

signal tower_died(reward_money: int)
signal tower_up()

@export var type = 1
@export var isAlive = true
@export var isDecorative = false
@onready var sprite = $Sprite2D
@onready var label = $Label
@onready var collision_shape_2d = $CollisionShape2D
@onready var timer = $Timer
@onready var progress_bar = $ProgressBar
@onready var polygon_2d = $Polygon2D
@onready var animation_player = $AnimationPlayer
@onready var reward_label = $Node2D/RewardLabel
@onready var timer_3 = $Timer3
@onready var lose_tower_audio = $loseTowerAudio
@onready var win_tower_audio = $winTowerAudio

const BULLET = preload("res://scenes/bullet.tscn")
var fire_rate: float = 0.1
var shooting: bool = false

var hp: float = 100.0
var damage: float = 0.1
var rewardMoney: int = 0
var targets: Array[Node] = []

# Called when the node enters the scene tree for the first time.
func _ready():
	
	if(!isDecorative):
		if(type == 1): sprite.region_rect =  Rect2(0,0,16,16)
		if(type == 2): sprite.region_rect = Rect2(0,16,16,16)
	else:
		progress_bar.visible = false
		if(type == 1): sprite.region_rect =  Rect2(0,0,16,16)
		if(type == 2): sprite.region_rect = Rect2(0,16,16,16)
		if(type == 3): 
			sprite.region_rect =  Rect2(16,0,16,16)
			polygon_2d.visible = false
			progress_bar.visible = false
		if(type == 4): 
			sprite.region_rect = Rect2(16,16,16,16)
			polygon_2d.visible = false
			progress_bar.visible = false
	if(!isDecorative):
		match type:
			1:
				damage = 0.2
				hp = 100
				rewardMoney = 200
				progress_bar.max_value = 100
				reward_label.text = str(200)
			2:
				damage = 0.4
				hp = 500
				rewardMoney = 400
				progress_bar.max_value = 500
				reward_label.text = str(400)
	else:
		damage =0
		hp = randi() % 100 + 1
		rewardMoney = 111
		progress_bar.max_value = 100
		reward_label.text = str(111)
	add_to_group("towers")
	add_to_group("towers2")


func _process(_delta):
	label.text = str(int(hp)) +'hp'
	progress_bar.value = int(hp)
	if(targets.size() > 0 && !(type == 3 || type == 4)): start_shooting()
	else: stop_shooting()


func start_shooting():
	if not shooting:
		shooting = true
		_shoot_loop()

func stop_shooting():
	shooting = false

func _shoot_loop() -> void:
	if not shooting:
		return

	if targets.size() > 0:
		var target = targets.pick_random()
		_shoot(target)

	# Call again after delay
	await get_tree().create_timer(fire_rate).timeout
	_shoot_loop()

func _shoot(target: Node) -> void:
	if not BULLET:
		return

	var bullet = BULLET.instantiate()
	bullet.global_position = global_position - Vector2(randi() % 2 + 1,randi() % 6 + 2)
	bullet.target = target
	get_tree().current_scene.add_child(bullet)
	
func tower_take_damage(amount: float):
	hp -= amount
	if hp <= 0:
		die()

func die():
	if(isAlive):
		isAlive = false
		emit_signal('tower_died', rewardMoney)
		progress_bar.visible = false
		label.visible = false
		timer.stop()
		collision_shape_2d.disabled = true
		polygon_2d.visible = false
		if(Global.tower_destroyed == 0): win_tower_audio.pitch_scale = 1.0
		if(Global.tower_destroyed == 1): win_tower_audio.pitch_scale = 1.0
		if(Global.tower_destroyed == 2): win_tower_audio.pitch_scale = 1.2
		if(Global.tower_destroyed == 3): win_tower_audio.pitch_scale = 1.4
		if(Global.tower_destroyed == 4): win_tower_audio.pitch_scale = 1.6
		if(Global.tower_destroyed == 5): win_tower_audio.pitch_scale = 1.8
		if(Global.tower_destroyed == 6): win_tower_audio.pitch_scale = 2.0
		if(Global.tower_destroyed == 7): win_tower_audio.pitch_scale = 2.2
		animation_player.play('reward')
		targets=[]
		timer_3.start()
		if(type == 1): sprite.region_rect =  Rect2(16,0,16,16)
		if(type == 2): sprite.region_rect = Rect2(16,16,16,16)

func _on_area_entered(area: Area2D):
	if area.is_in_group("protesters"):
		if area not in targets:
			targets.append(area)

func _on_area_exited(area: Area2D):
	if area in targets:
		targets.erase(area)

func _on_timer_timeout():
	for target in targets.duplicate():
		if is_instance_valid(target):
			#print('Tower Damage', str(damage))
			target.protester_take_damage(damage)
		else:
			targets.erase(target)


func _on_timer_3_timeout():
	isAlive = true
	progress_bar.visible = true
	#label.visible = true
	timer.start()
	collision_shape_2d.disabled = false
	polygon_2d.visible = true
	if(type == 1): 
		sprite.region_rect =  Rect2(0,0,16,16)
		if(Global.difficulty == 1):
			rewardMoney =  150
			reward_label.text = str(150)
		if(Global.difficulty == 2):
			rewardMoney =  100
			reward_label.text = str(100)
		if(Global.difficulty == 3):
			rewardMoney =  50
			reward_label.text = str(50)
		if(Global.difficulty == 4):
			rewardMoney =  25
			reward_label.text = str(25)
	if(type == 2): 
		sprite.region_rect = Rect2(0,16,16,16)
		if(Global.difficulty == 1):
			rewardMoney =  200
			reward_label.text = str(200)
		if(Global.difficulty == 2):
			rewardMoney =  150
			reward_label.text = str(150)
		if(Global.difficulty == 3):
			rewardMoney =  100
			reward_label.text = str(100)
		if(Global.difficulty == 4):
			rewardMoney =  100
			reward_label.text = str(100)
	match type:
		1:
			damage = 0.2
			hp = 100
			progress_bar.max_value = 100
		2:
			damage = 0.4
			hp = 500
			progress_bar.max_value = 500
	emit_signal('tower_up')
	lose_tower_audio.play()
