extends Spatial

func _process(delta):
	$Hole1.rotation.y += delta
	$Hole2.rotation.y -= delta

func appear():
	#self.scale = Vector3(0, 0, 0)
	self.visible = true
	print("start")
	$Tween.interpolate_property(self, "scale", Vector3(0, 0, 0), Vector3(2, 2, 2), 0.5, Tween.TRANS_CUBIC, Tween.EASE_OUT)
	$Tween.start()

func disappear():
	$Tween.interpolate_property(self, "scale", self.scale, Vector3(0, 0, 0), 0.5, Tween.TRANS_CUBIC, Tween.EASE_OUT)
	$Tween.start()

func _on_Tween_tween_step(object, key, elapsed, value):
	pass#print(key, " ", elapsed, " Vector3: ", value)
