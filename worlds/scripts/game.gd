extends Node2D

var chair: PackedScene = preload(Constants.PIWWOS.Chair.scene_path)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var chair_instance = chair.instantiate()
	add_child(chair_instance)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
