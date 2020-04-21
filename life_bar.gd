extends Control

onready var health_bar = $TextureProgress

func _on_health_updated(health, _amount):
	health_bar.value = health
	
func _on_max_health_updated(max_health):
	health_bar.max_value = max_health
