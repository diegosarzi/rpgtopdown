extends Node

var spider_scene = preload("res://Spider.tscn")
var spider_die = preload("res://spider_die.tscn")
var sangue_load = preload("res://sangue.tscn")

func _ready():
	for i in range(0,25):
		respawSpider()

func sangueEnemy(enemy, pos_enemy):
	var sangue = sangue_load.instance()
	sangue.position = pos_enemy
	sangue.z_index = -1
	
	add_child(sangue)

func dieEnemy(enemy, pos_die, enemy_xp):
	var spider = spider_die.instance()
	spider.position = pos_die
	spider.z_index = -1
	
	get_node("Mage").xp += enemy_xp

	add_child(spider)
	
func respawSpider():
	randomize()
	var new_spider = spider_scene.instance()
	new_spider.position = Vector2(rand_range(-700,970), rand_range(450,-2000))
	#new_spider.position = Vector2(rand_range(-250,550), rand_range(-500,-1200))
	
	
	add_child(new_spider)
