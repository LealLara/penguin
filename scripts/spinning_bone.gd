extends Area2D
@onready var anim: AnimatedSprite2D = $AnimatedSprite2D

var speed = 60
var direction = 1
 
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position.x += speed * delta * direction
	return 

func set_direction(skeleton_direction):
	direction = skeleton_direction
	anim.flip_h = direction < 0 
	return 


func _on_self_distruct_timer_timeout() -> void:
	queue_free()

func _on_area_entered(_area: Area2D) -> void:
	queue_free()

func _on_body_entered(_body: Node2D) -> void:
	queue_free()
