extends Area2D

@export var next_level = "forest"

func _on_body_entered(_body):
	call_deferred("load_next_scene")
	
func load_next_scene():
	get_tree().change_scene_to_file("res://scenes/" + next_level + ".tscn")
