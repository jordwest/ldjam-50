tool
extends Control

export(float) var charge_level setget _set_charge, _get_charge

func _set_charge(v):
	charge_level = v
	$Sprite.frame = floor(v * 5)

func _get_charge():
	return charge_level
