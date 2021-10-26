extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export (int) var columns;
export (int) var rows;
export (int) var x_start;
export (int) var y_start;
export (int) var tile_size_in_pixels; #this could probably be calculated instead of being a set variable

var tile_prototypes;

var all_tiles = [];

const utils = preload("utils.gd");

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize();
	var a = utils.new();
	tile_prototypes = a.load_resources_from_dir("res://Tile_Types");
	all_tiles = make_new_2d_array();
	spawn_tiles();

func make_new_2d_array():
	var array = [];
	for i in columns:
		array.append([]);
		array[i].resize(rows);
		for j in rows:
			array[i][j] = null;
	return array;
	
func spawn_tiles():
	for i in columns:
		for j in rows:
			var rand = floor(rand_range(0, tile_prototypes.size()));
			var tileInstance = tile_prototypes[rand].instance();
			add_child(tileInstance);
			tileInstance.position = grid_to_pixel(i, j);
	
func grid_to_pixel(column, row):
	var x = x_start + tile_size_in_pixels * column;
	var y = y_start + -tile_size_in_pixels * row;
	return Vector2(x, y);

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
