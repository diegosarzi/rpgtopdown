extends Node

var floaty_text_scene = preload("res://text_life.tscn")

func damagePlayer(amount, position, color):
	
	var float_text = floaty_text_scene.instance()
	
	float_text.position = position + Vector2(-10,-30)
	float_text.velocity = Vector2(0, -100)
	float_text.modulate = color
		
	float_text.text = amount
	
	add_child(float_text)
