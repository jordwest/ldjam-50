extends Spatial

export(Resource) var player_info

var hit_rids = Dictionary()

func _on_AreaOfEffect_body_entered(body):
	var rid = body.get_rid()
	
	# Don't process twice
	if hit_rids.has(body.get_rid()):
		return
	
	hit_rids[rid] = true
	
	if body.has_method("hit"):
		body.hit(1)
	if body.has_method("knockback"):
		var player = player_info.player_node
		body.knockback((body.global_transform.origin - player.global_transform.origin).normalized() * 3.0)
