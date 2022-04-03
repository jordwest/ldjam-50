tool
extends Spatial

export(float) var alpha setget set_alpha, get_alpha

func set_alpha(v):
	alpha = v
	$Circle.get_active_material(0).set_shader_param("alpha", v)

func get_alpha():
	return $Circle.get_active_material(0).get_shader_param("alpha")
