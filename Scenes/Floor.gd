extends MeshInstance

func _process(dt):
	self.translation = get_parent().get_node("Player").translation
	self.get_active_material(0).uv1_offset.x = self.translation.x
	self.get_active_material(0).uv1_offset.y = self.translation.z
