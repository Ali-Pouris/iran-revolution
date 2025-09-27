extends Node2D

signal close_guid()

func _on_touch_screen_button_pressed():
	emit_signal('close_guid')
