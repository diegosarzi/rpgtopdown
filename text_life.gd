extends Position2D

onready var tween = $Tween

var velocity = Vector2(50,-100)
var gravity = Vector2(0,1)
var mass = 150
var color

var text setget set_text, get_text

func _ready():
	tween.interpolate_property(self, "modulate", 
	Color(1.0,0.0,0.0,1.0),
	Color(1.0,0.0,0.0,0),
	1.5,
	Tween.TRANS_QUART,Tween.EASE_IN_OUT)
	tween.start()

func _process(delta):
	velocity += gravity * mass * delta
	position += velocity * delta

func set_text(new_text):
	$Label.text = str(new_text)
	
func get_text():
	return $Label.text


func _on_Timer_timeout():
	pass # Replace with function body.
