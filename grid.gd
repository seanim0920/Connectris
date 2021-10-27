extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export (int) var columns;
export (int) var rows;
export (int) var horizontal_margin;
export (int) var y_start;

var tile_size_in_pixels;

var tile_prototypes;

var all_tiles = [];

const utils = preload("utils.gd");

# Called when the node enters the scene tree for the first time.
func _ready():
	tile_size_in_pixels = floor((get_viewport_rect().size.x - (horizontal_margin * 2)) / columns);
	
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
			#match checking code here
			#would be nice if we could associate the color enum with the tile prototypes
			#switch to picking a different type at random if rand results in a match
			var availableColors = TileType.COLOR.values();
			var rand = randi() % availableColors.size();
			
			while(check_for_match(i, j, availableColors[rand])):
				availableColors.remove(availableColors[rand]);
				rand = randi() % availableColors.size();
				#instead of moving to the next tile type (might not be random enough)
				#make a new array of colors and subtract the chosen color
				#pick a random color from the leftovers
				
				#in the future we may want to do away with the enum and base the logic exclusively on the contents of the tiletypes folder.
			
			var tileInstance = tile_prototypes[rand].instance();
			var scale = tile_size_in_pixels / 128; #may want to check the size of the sprite rather than hardcoding 128
			tileInstance.scale = Vector2(scale, scale);
			add_child(tileInstance);
			tileInstance.position = grid_to_pixel(i, j);
			all_tiles[i][j] = tileInstance;
			
func check_for_match(column, row, color):
	if column > 1:
		#print("checking match at ", column, ", ", row);
		#print("current color is ", color);
		#print("comparing to the left neighbor which is ", all_tiles[column - 1][row].color);
		if all_tiles[column - 1][row].color == color && all_tiles[column - 2][row].color == color:
			return true;
				
	if row > 1:
		if all_tiles[column][row - 1].color == color && all_tiles[column][row - 2].color == color:
			return true;
	
func grid_to_pixel(column, row):
	var x = horizontal_margin + (tile_size_in_pixels/2) + tile_size_in_pixels * column;
	var y = y_start + -tile_size_in_pixels * row;
	print(x);
	return Vector2(x, y);

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
