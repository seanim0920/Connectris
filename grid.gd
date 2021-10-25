extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export (int) var width;
export (int) var height;
export (int) var x_start;
export (int) var y_start;
export (int) var offset;

var all_tiles = [];

# Called when the node enters the scene tree for the first time.
func _ready():
	all_tiles = make_2d_array();
	print(all_tiles);
	pass # Replace with function body.

func make_2d_array():
	var array = [];
	for i in width:
		array.append([]);
		for j in height:
			array[i].append(null);
	return array;

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
