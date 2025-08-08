extends Node

@export var starting_money := 100
@export var start_day := 1

var money := 0
var day := 1

func _ready():
	money = starting_money
	day = start_day
	SignalBus.money_changed.emit(money)
