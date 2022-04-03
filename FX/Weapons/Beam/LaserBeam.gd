extends Node2D

export(Color) var beam_color

func _ready():
	$LaserParticles1.emitting = false
	$LaserParticles2.emitting = false
	$BeamLine.default_color = beam_color
	$BeamLine.default_color.a = 0.0

func fire():
	var end_color = beam_color
	end_color.a = 0.0
	
	$Tween.interpolate_property($BeamLine, "default_color", beam_color, end_color, 0.6,Tween.TRANS_CUBIC,Tween.EASE_OUT)
	$Tween.start()
	$LaserParticles1.emitting = true
	$LaserParticles2.emitting = true
	$ParticleEmissionTimer.start(0.2)

func _on_ParticleEmissionTimer_timeout():
	$LaserParticles1.emitting = false
	$LaserParticles2.emitting = false
