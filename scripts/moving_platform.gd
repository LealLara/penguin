extends AnimatableBody2D

 
func _ready() -> void:
	var origem =  global_position
	var destino = origem
	destino.y = 100
	var tween  =  create_tween()
	tween.set_trans(Tween.TRANS_QUAD)
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self, "global_position", destino, 1)
	tween.tween_property(self, "global_position", origem, 1)
	tween.set_loops()
	
 
