extends Sprite2D

@export var speed: float = 200.0
@export var lifetime: float = 0.15  # seconds

var target: Node = null
var direction: Vector2 = Vector2.ZERO
var time_alive: float = 0.0

func _ready() -> void:
	if target:
		# Initial direction only
		direction = (target.global_position - global_position).normalized()
		# Rotate sprite to face the direction
		rotation = direction.angle()

func _process(delta: float) -> void:
	# Move in the initial direction
	position += direction * speed * delta

	# Lifetime countdown
	time_alive += delta
	if time_alive >= lifetime:
		queue_free()
