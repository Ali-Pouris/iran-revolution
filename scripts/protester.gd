extends Area2D

@onready var animated_sprite = $AnimatedSprite2D
@onready var animation_player = $AnimationPlayer

@export var isGod = false
@export var type = 1
@export var speed: float = 25.0    # Movement speed
@export var stop_radius_min: float = 0.8  # Min distance to stop from tower
@export var stop_radius_max: float = 2.2  # Max distance to stop from tower
@export var extra_stop_distance: float = 0.0  # how far outside the rectangle to stop

var hp: float = 1.0
var damage: float = 1.0
var enemyTargets: Array[Node] = []



var towers: Array[Node] = []
var target: Vector2
var stop_radius: float

func _ready() -> void:
	if(type == 1): animated_sprite.play("idle 1")
	if(type == 2): animated_sprite.play("idle 2")
	if(type == 3): animated_sprite.play("idle 3")
	add_to_group("protesters")
	towers = get_tree().get_nodes_in_group("towers2")
	if towers.is_empty():
		push_warning("No towers found in scene tree (make sure towers are in group 'towers').")
		return
	choose_closest_target()

	if(!isGod):
		match type:
			1:
				damage = 1.0 / 10 
				hp = 1
			2:
				damage = 2.0 / 10 
				hp = 4
			3:
				damage = 3.0 / 10
				hp = 6
	else:
		damage = 0
		hp = 99999
	add_to_group("protesters")

func _process(delta: float) -> void:
	if target == Vector2.ZERO:
		return
	
	var direction = (target - global_position).normalized()
	var distance = global_position.distance_to(target)

	if distance > 2.0: # small tolerance so it doesn't jitter
		global_position += direction * speed * delta
	else:
		#print("Reached outside tower rectangle")
		target = Vector2.ZERO

func choose_closest_target() -> void:
	if towers.is_empty():
		return
	
	var closest_tower = towers[0]
	
	var closest_dist = global_position.distance_to(closest_tower.global_position - Vector2(0,2))
	
	for tower in towers:
		var d = global_position.distance_to(tower.global_position)
		if d < closest_dist:
			closest_tower = tower
			closest_dist = d
	
	# Assume tower has a CollisionShape2D with a RectangleShape2D
	var shape_node = closest_tower.get_node_or_null("CollisionShape2D2")
	var rect: Rect2 = Rect2(
			closest_tower.global_position - Vector2(5,5),
			Vector2(5,5) * 2
		)
	if(shape_node): 
		rect = Rect2(
			closest_tower.global_position - shape_node.shape.extents,
			shape_node.shape.extents * 2
		)
	
	# Pick a random point OUTSIDE the rectangle
	var point: Vector2
	while true:
		var angle = randf_range(0, TAU)
		var dist
		if(shape_node):
			dist = max(shape_node.shape.extents.length(), 10.0) + extra_stop_distance
		else:
			dist = max(Vector2(5,5).length(), 10.0) + extra_stop_distance
		stop_radius = randf_range(stop_radius_min, stop_radius_max)
		point = closest_tower.global_position + Vector2.RIGHT.rotated(angle) * stop_radius * dist
		
		if not rect.has_point(point - closest_tower.global_position):
			break
	
	target = point
	

func protester_take_damage(amount: float):
	if(isGod): return
	animation_player.play("hit")
	hp -= amount
	if hp <= 0:
		die()

func die():
	queue_free()

func _on_area_entered(area: Area2D):
	if area.is_in_group("towers") or area.is_in_group("guards"):
		if area not in enemyTargets:
			enemyTargets.append(area)

func _on_area_exited(area: Area2D):
	if area in enemyTargets:
		enemyTargets.erase(area)

func _on_timer_timeout():
	for t in enemyTargets.duplicate():
		if is_instance_valid(t):
			t.tower_take_damage(damage)
		else:
			enemyTargets.erase(t)
