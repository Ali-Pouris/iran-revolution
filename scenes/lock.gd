extends Node2D

@export var text: String = "Capture two cities"
@onready var label = $Label

func _ready():
	label.text = text
