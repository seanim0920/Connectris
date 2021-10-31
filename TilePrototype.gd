extends Node2D

export (TileType.COLOR) var color;
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var move_tween = $move_tween;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func move(target_position):
	move_tween.interpolate_property(self, "position", position, target_position, 0.25, Tween.TRANS_BACK, Tween.EASE_OUT)
	move_tween.start();
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
