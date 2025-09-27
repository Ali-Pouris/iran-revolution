extends VSlider

var bus_index: int

func _ready() -> void:
	bus_index = AudioServer.get_bus_index('Master')
	value_changed.connect(_on_value_changed)
	
	value = db_to_linear(
		AudioServer.get_bus_volume_db(bus_index)
	)
	
	print('value',value)

func _on_value_changed(amount: float) -> void:
	AudioServer.set_bus_volume_db(
		bus_index,
		linear_to_db(amount)
	)
