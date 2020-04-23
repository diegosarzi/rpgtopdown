extends KinematicBody2D

#maginas
var fireball_load = preload("res://fireball.tscn")
var hud_enemy_load = preload("res://hud_inimigo.tscn")

export (int) var life = 30
export (int) var mana = 30
export (int) var xp = 10
export (int) var lvl = 1
export (int) var speed = 100
export (int) var dano = 3
export (int) var def = 0

var mana_full = mana
var life_full = life

onready var fps_label = get_node("label_fps")

var wood_mana = 2
var weapon = "wood-wand"
var magic = ""

var tile_size = 32

onready var ray = $RayCast2D

var last_position = Vector2()
var target_position = Vector2()
var movedir = Vector2()

var damage = false
var damage_amount = 0
var damage_amount_shuffer

var enemys_array = []

var selected = false
var colider = []
var damage_on = false
var damage_on_magic = false


var count = 100
var count_on = false

var time_magic = 200
var count_damage_time = time_magic
var count_damage_time_magic = time_magic

# magias
var fireball_mana = 10

var temp = "baixo"

var hud_enemy_names = []
var hud_enemy_number = 1
var hud_enemy_y = -155

func _ready():
	position = position.snapped(Vector2(tile_size, tile_size))
	last_position = position
	target_position = position
	
	$LifeBar/TextureProgress.max_value = life
	$LifeBar/TextureProgress.value = life
	$ManaBar/TextureProgress.max_value = mana
	$ManaBar/TextureProgress.value = mana
	
	$up_life_mana.start(10)
	

func _physics_process(delta):
	
	fps_label.set_text("fps: " + str(Engine.get_frames_per_second()))
	
	$label_life.text = "life: " + str(life)
	$label_mana.text = "mana: " + str(mana)	
	$label_xp.text = "xp: " + str(xp)
	
	if !enemys_array.empty():
		for i in range(0, enemys_array.size()):
			if i == 0:
				hud_enemy_y = -155
				hud_enemy_number = 1
			if i == 1:
				hud_enemy_y = -130
				hud_enemy_number = 2
			if i == 2:
				hud_enemy_y = -105
				hud_enemy_number = 3
			if i == 3:
				hud_enemy_y = -80
				hud_enemy_number = 4
			if i == 4:
				hud_enemy_y = -55
				hud_enemy_number = 5
			if i == 5:
				hud_enemy_y = -30
				hud_enemy_number = 6
			if i == 6:
				hud_enemy_y = -05
				hud_enemy_number = 7
			if i == 7:
				hud_enemy_y = 20
				hud_enemy_number = 8
			if i == 8:
				hud_enemy_y = 45
				hud_enemy_number = 9
			if i == 9:
				hud_enemy_y = 70
				hud_enemy_number = 0

			if !has_node(str(enemys_array[i])) and hud_enemy_names.find(enemys_array[i]) == -1:
				hudEnemyShow(str(enemys_array[i]),Vector2(-300,hud_enemy_y),hud_enemy_number)
				hud_enemy_names.append(enemys_array[i])
				#print(hud_enemy_names[i])

			#### nao funciona!				
			if enemys_array[i] != hud_enemy_names[i]:
					get_node(str(hud_enemy_names[i]).replace(":","")).queue_free()
				
	else:
		$inimigos.text = ""

	if life <= 0:
		return get_tree().reload_current_scene()
	
	for i in colider:
		if count_on:
			damage = true
			count = 0
			count_on = false
		
		if count < 100:
			count += 1
		else:
			count = 101
			damage = false
			if !colider.empty():
				count_on = true
			else:
				count_on = false

	## enemys_array DE INIMIGOS
	if !enemys_array.empty():
		for i in range(0, enemys_array.size()):
			if Input.is_action_just_pressed(str(i+1)):
				if selected and selected == enemys_array[i]:
					selected.get_node("Panel").visible = false
					selected.damage = false
					selected = false
					return
					
				if selected:
					selected.get_node("Panel").visible = false
					selected.damage = false
				
				selected = enemys_array[i]
				selected.get_node("Panel").visible = true
				damage_on = true

	# DAMAGE CONTRA INIMIGO
	if selected and damage_on:
		if count_damage_time >= 100:
			if position.x - selected.position.x <= 64 and position.x - selected.position.x >= -64 and position.y - selected.position.y <= 64 and position.y - selected.position.y >= -64:
				if wood_mana <= mana:
					$ManaBar._on_health_updated(mana,wood_mana)
					get_parent().get_node("lifeball").fireballGo(position, selected.position)
					selected.damage = true
					selected.damage_amount = dano
					count_damage_time = 0
					if weapon == "wood-wand":
						mana -= 2
					elif magic == "fire":
						mana -= 10
		else:
			selected.damage = false
	
	# CONTADOR DAMAGE CONTRA INIMIGO
	if count_damage_time < 100:
		count_damage_time += 1
		damage_on = false
	else:
		count_damage_time = 100
		damage_on = true
	
	# CONTADOR DAMAGE CONTRA INIMIGO
	if count_damage_time_magic < time_magic:
		count_damage_time_magic += 1
		damage_on_magic = false
	else:
		count_damage_time_magic = time_magic
		$magias/AnimationPlayer.play("wait")
		damage_on_magic = true
		
	if mana < fireball_mana:
		$magias/icon_fireball.visible = false
	else:
		$magias/icon_fireball.visible = true
	
	## DANO DO PERSONAGEM ( PLAYER )
	if damage:
		damageFunc(2)
		damage = false
	
	## MOVIMENTAÇÃO
	if ray.is_colliding():
		position = last_position
		target_position = last_position
	else:
		position += speed * movedir * delta
		
	if position.distance_to(last_position) >= tile_size - speed * delta:
		position = target_position
		
	if position == target_position:
		get_movedir()
		if movedir.x == -1:
			$AnimationPlayer.play("walk_esquerda")
			temp = 'esquerda'
		elif movedir.x == 1:
			$AnimationPlayer.play("walk_direita")
			temp = 'direita'
		elif movedir.y == -1:
			$AnimationPlayer.play("walk_cima")
			temp = 'cima'
		elif movedir.y == 1:
			$AnimationPlayer.play("walk_baixo")
			temp = 'baixo'
		
		else:
			$AnimationPlayer.play("idle_" + temp)
			
		last_position = position
		target_position += movedir * tile_size
		
		if Input.is_action_just_pressed("magia_simples"):
			if selected:
				if count_damage_time_magic >= time_magic:
					if position.x - selected.position.x <= 32*3 and position.x - selected.position.x >= -32*3 and position.y - selected.position.y <= 32*3 and position.y - selected.position.y >= -32*3:
						if mana >= fireball_mana:
							selected.damage = true
							selected.damage_amount = 10
							count_damage_time_magic = 0
							$magias/AnimationPlayer.play("on")
							sendFireBall()
			

func get_movedir():
	var RIGHT = Input.is_action_pressed("ui_right")
	var LEFT = Input.is_action_pressed("ui_left")
	var DOWN = Input.is_action_pressed("ui_down")
	var UP = Input.is_action_pressed("ui_up")
	
	movedir.x = -int(LEFT) + int(RIGHT)
	movedir.y = -int(UP) + int(DOWN)
	
	if movedir.x != 0 && movedir.y != 0:
		movedir = Vector2.ZERO

	if movedir != Vector2.ZERO:
		ray.cast_to = movedir * tile_size

# ENTRAR AREA DE COLISAO PLAYER
func _on_Damage_body_entered(body):
	if body != self:
		$Panel.visible = true
		if colider.find(body) == -1:
			colider.append(body)
				
# SAIR AREA DE COLISAO PLAYER
func _on_Damage_body_exited(body):
	if body != self:
		$Panel.visible = false
		if colider.find(body) != -1:
			colider.remove(colider.find(body))

# area de visao do personagem  ( player )
func _on_Area2D_body_entered(body):
	if body.get_name() != 'Mage':
		if enemys_array.find(body) == -1:
			enemys_array.append(body)
			body.visao = true

# area de saida da visao do persongem ( player )
func _on_Area2D_body_exited(body):
	if hud_enemy_names.find(str(body)):
		#print(str(body).replace(":",""))
		if has_node(str(body).replace(":","")):
			get_node(str(body).replace(":","")).queue_free()
			hud_enemy_names.remove(hud_enemy_names.find(body))
		
	if enemys_array.find(body) != -1:
		body.visao = false
	enemys_array.remove(enemys_array.find(body))

## FUNÇÃO DE DANO DO PLAYER
func damageFunc(time):
	randomize()
	damage_amount_shuffer = rand_range(damage_amount - damage_amount, damage_amount)
	var result = damage_amount_shuffer - def
	if result <= 0:
		result = 0
		life -= int(result)
	else:
		life -= int(result)
	$LifeBar._on_health_updated(life,1)
	get_parent().get_node("Life_Text").damagePlayer(int(-result), position, Color(0.6,0.0,0.0,1.0))

# up de vida e mana do personagem
func _on_up_life_mana_timeout():
	if mana <= mana_full:
		mana += 4
		if mana > mana_full:
			mana = mana_full
		$ManaBar._on_health_updated(mana,1)
	if life <= life_full:
		life += 2
		if life > life_full:
			life = life_full
		$LifeBar._on_health_updated(life,1)
		
func sendFireBall():
	var fireball_instance = fireball_load.instance()
	if selected and mana > 10:
		fireball_instance.position = selected.position
		mana -= 10
		$ManaBar._on_health_updated(mana,1)
		get_parent().add_child(fireball_instance)

var enemy

func hudEnemyShow(eny_name,posicao,number):
	enemy = hud_enemy_load.instance()
	enemy.position = posicao
	enemy.name = eny_name
	enemy.get_node("text").text = str(number)
	get_node(".").add_child(enemy)
