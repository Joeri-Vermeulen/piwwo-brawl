extends Node2D

#var piwwo: PackedScene = preload(Constants.PIWWOS.Piwwo.scene_path)
var chair: PackedScene = preload(Constants.PIWWOS.Chair.scene_path)
#var ordinary: PackedScene = preload(Constants.PIWWOS.Ordinary.scene_path)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#var piwwo_instance = piwwo.instantiate()
	var chair_instance = chair.instantiate()
	#var ordinary_instance = ordinary.instantiate()
	
	#add_child(piwwo_instance)
	add_child(chair_instance)
	#add_child(ordinary_instance)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
