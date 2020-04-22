extends KinematicBody2D

var life = 100
var damage = false
var damage_amount
var damage_amount_shuffer

var velocity = 0.3

var tile_set = 32

var visao = false

var escolha = [1,2]

onready var Player = get_parent().get_node("Mage")

func _process(delta):
	if damage:
		randomize()
		damage_amount_shuffer = rand_range(damage_amount - damage_amount, damage_amount)
		life -= int(damage_amount_shuffer)
		
		if int(damage_amount_shuffer) <= 0:
			$AnimationPlayer.play("puff")
		else:
			$AnimationPlayer.play("dano")
		
		$LifeBar._on_health_updated(life,1)
		
		get_parent().get_node("Life_Text").damagePlayer(int(-damage_amount_shuffer),position,Color(1.0,0,0,1))
		damage = false
		
	if life <= 0:
		Player.selected = false
		self.queue_free()
		
func _on_Damage_body_entered(body):
	if "damage" in body:
		body.damage_amount = 20


func _on_TimerWalk_timeout():
	if visao:
		# direita
		if Player.position.x - position.x > tile_set and Player.position.x - position.x != 0 and !$right.is_colliding():
			right()
		# esquerda
		elif Player.position.x - position.x < -tile_set and Player.position.x - position.x != 0 and !$left.is_colliding():
			left()
		#baixo
		elif Player.position.y - position.y > tile_set and Player.position.y - position.y != 0 and !$down.is_colliding():
			up()
		#cima
		elif Player.position.y - position.y < -tile_set and Player.position.y - position.y != 0 and !$up.is_colliding():
			down()
		elif Player.position.y - position.y > tile_set and Player.position.y - position.y != 0 and !$left.is_colliding():
			var choice = escolha[randi() % escolha.size()]
			if choice == 1:
				right()
			else:
				left()
		elif Player.position.y - position.y < -tile_set and Player.position.y - position.y != 0 and !$right.is_colliding():
			var choice = escolha[randi() % escolha.size()]
			if choice == 1:
				right()
			else:
				left()
		elif Player.position.x - position.x > tile_set and Player.position.x - position.x != 0 and !$up.is_colliding():
			if !$down.is_colliding():
				up()
			else:
				down()
		elif Player.position.x - position.x < -tile_set and Player.position.x - position.x != 0 and !$down.is_colliding():
			if !$up.is_colliding():
				down()
			else:
				up()
		else:
			position = position

func down():
	if !$down.is_colliding():
		$Tween.interpolate_property(self, "position", Vector2(position.x,position.y),
			Vector2(position.x,position.y - tile_set),
			velocity,
			Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
				
		$Tween.start()
		
func up():
	if !$up.is_colliding():	
		$Tween.interpolate_property(self, "position", Vector2(position.x,position.y),
			Vector2(position.x,position.y + tile_set),
			velocity,
			Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
			
		$Tween.start()
	
func left():
	if !$left.is_colliding():
		$Tween.interpolate_property(self, "position", Vector2(position.x,position.y),
			Vector2(position.x + -tile_set, position.y),
			velocity,
			Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
		
		$Tween.start()
		
func right():
	if !$right.is_colliding():
		$Tween.interpolate_property(self, "position", Vector2(position.x,position.y),
			Vector2(position.x + tile_set, position.y),
			velocity,
			Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
		$Tween.start()
