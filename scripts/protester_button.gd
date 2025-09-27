extends TouchScreenButton

@export var type = 1
@export var text = ''
@onready var cost_number = $CostNumber
@onready var color_rect_3 = $ColorRect3
@onready var animation_player = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	if(type == 1):
		cost_number.text = '10'
	if(type == 2):
		cost_number.text = '25'
	if(type == 3):
		cost_number.text = '50'


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if(text != ''): cost_number.text = text
	
func _on_area_2d_mouse_entered():
	color_rect_3.color = Color(1.0, 1.0, 0.0, 1.0)


func _on_area_2d_mouse_exited():
	color_rect_3.color = Color(0.235, 0.235, 0.235, 1.0)


func _on_pressed():
	animation_player.play("bounce")
