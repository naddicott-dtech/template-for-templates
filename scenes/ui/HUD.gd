extends Control

@export var debug_add_amount: int = 10
@onready var money_label: Label = %MoneyLabel
@onready var day_label: Label = %DayLabel

func _ready():
	SignalBus.money_changed.connect(_on_money_changed)
	SignalBus.day_ended.connect(_on_day_ended)
	_on_money_changed(Globals.money)
	_on_day_ended(Globals.day)
	%AddMoneyButton.visible = Globals.show_debug_buttons
	
func _on_money_changed(new_money:int) -> void:
	money_label.text = "$" + str(new_money)
	
func _on_day_ended(new_day:int) -> void:
	day_label.text = "Day " + str(new_day)

func _on_add_money_button_pressed():
	Globals.add_money(debug_add_amount) 
