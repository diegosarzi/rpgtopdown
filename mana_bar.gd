extends Control

onready var mana_bar = $TextureProgress

func _on_health_updated(mana, _amount):
	mana_bar.value = mana
	
func _on_max_health_updated(mana_full):
	mana_bar.max_value = mana_full
