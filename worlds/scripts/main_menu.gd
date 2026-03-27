extends Control

@export var initial_scene: StringName = &"" # uid

func start_game() -> void:
	SceneLoader.load_scene(initial_scene)
