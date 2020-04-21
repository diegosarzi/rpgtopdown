extends Node

var fireball_load = preload("res://Fireball.tscn")

func fireballGo(playerPosition, enemyPosition):
	
	var fireball = fireball_load.instance()
	
	fireball.position = playerPosition
	fireball.playerPosition = playerPosition
	fireball.enemyPosition = enemyPosition

	add_child(fireball)
