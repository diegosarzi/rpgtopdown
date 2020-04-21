extends Node2D

var playerPosition
var enemyPosition

func _ready():
	$Tween.interpolate_property(self, "position", playerPosition,
	enemyPosition,
	0.2,
	Tween.TRANS_LINEAR,Tween.EASE_IN)
	$Tween.start()

func _process(delta):
	if !$Tween.is_active():
		self.queue_free()
