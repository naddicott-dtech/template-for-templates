extends Node
@export var seconds_per_day := 60
var _accumulated_seconds := 60

func _process(delta: float) -> void:
	SignalBus.tick.emit(delta)
	_accumulated_seconds += delta
	if _accumulated_seconds >= seconds_per_day:
		_accumulated_seconds = 0.0
		Globals.day += 1
		SignalBus.day_ended.emit(Globals.day)
