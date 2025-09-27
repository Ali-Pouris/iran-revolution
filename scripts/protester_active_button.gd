extends TouchScreenButton

@export var type = 1
@export var active = false
@export var count = 0
@onready var animated_sprite = $AnimatedSprite2D
@onready var color_rect = $ColorRect
@onready var color_rect_2 = $ColorRect2
@onready var label = $Label
@onready var cost_number = $CostNumber
@onready var animation_player = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	if(type == 1):
		animated_sprite.play("type 1")
		label.text = '+1 dps
		+1 hp
		-----
		available:
		'
		cost_number.text = '5'
	if(type == 2):
		animated_sprite.play("type 2")
		label.text = '+2 dps
		+4 hp
		-----
		available:
		'
		cost_number.text = '10'
	if(type == 3):
		animated_sprite.play("type 3")
		label.text = '+3 dps
		+6 hp
		-----
		available:
		'
		cost_number.text = '20'


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if(active): color_rect_2.color = Color(1.0, 1.0, 0.0, 1.0)
	else: color_rect_2.color = Color(0.235, 0.235, 0.235, 1.0)
	cost_number.text = str(count)

func _on_area_2d_mouse_entered():
	color_rect.color = Color(1.0, 1.0, 0.0, 1.0)
	pass # Replace with function body.


func _on_area_2d_mouse_exited():
	color_rect.color = Color(1.0, 1.0, 1.0, 1.0)


func _on_pressed():
	animation_player.play("bounce")
