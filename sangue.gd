extends Node2D

func _ready():
	randomize()
	var random = int(rand_range(1,4))
	get_node("sangue" + str(random)).visible = true
	
	print(random)
	
	$Timer.start(60)


func _on_Timer_timeout():
	queue_free()
