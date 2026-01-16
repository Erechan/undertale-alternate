extends Control

@export var next_scene : PackedScene

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("confirm") && next_scene != null:
		SceneManager.goto_scene_to_packed(next_scene)
		
