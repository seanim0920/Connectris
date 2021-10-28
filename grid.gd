extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export (int) var columns;
export (int) var rows;
export (int) var horizontal_margin;
export (int) var y_start;

var grid_touch_start_pos = Vector2(0,0);
var controlling = false;

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
	return Vector2(x, y);
	
func pixel_to_grid(x, y):
	var column = round((x + -horizontal_margin + -(tile_size_in_pixels/2))/tile_size_in_pixels);
	var row = round((y - y_start)/-tile_size_in_pixels);
	#check if it's off the grid?
	return Vector2(column, row);
	
func is_within_grid(column, row):
	if (column >= 0 && column < columns):
		if (row >= 0 && row < rows):
			return true;
	return false;
	
#we want to grow the tile that we're touching, and highlight the tile we will swap to.
#moves can be cancelled by touching outside the grid maybe. but that'll make swapping boundary pieces difficult.

func touch_input():
	if Input.is_action_just_pressed("ui_touch"):
		var touch_pos = get_global_mouse_position();
		grid_touch_start_pos = pixel_to_grid(touch_pos.x, touch_pos.y);
		if is_within_grid(grid_touch_start_pos.x, grid_touch_start_pos.y):
			controlling = true;
	if Input.is_action_just_released("ui_touch"):
		if controlling:
			var touch_pos = get_global_mouse_position();
			var grid_touch_end_pos = pixel_to_grid(touch_pos.x, touch_pos.y);
			
			#figure out the direction vector
			var direction = calc_cardinal_direction(grid_touch_end_pos, grid_touch_start_pos);
			
			swap_tiles(grid_touch_start_pos.x, grid_touch_start_pos.y, direction);
			controlling = false; 

func calc_cardinal_direction(end_pos, start_pos):
	print("start pos is at ", start_pos)
	print("end pos is at ", end_pos)
	var direction = (end_pos - start_pos).normalized();
	if (direction.abs().x >= direction.abs().y):
		return Vector2(round(direction.x), 0);
	else:
		return Vector2(0, round(direction.y));
			
func swap_tiles(column, row, direction):
	if (!is_within_grid(column + direction.x, row + direction.y)):
		return;
	var firstTile = all_tiles[column][row];
	var otherTile = all_tiles[column + direction.x][row + direction.y];
	all_tiles[column][row] = otherTile;
	all_tiles[column + direction.x][row + direction.y] = firstTile;
	firstTile.position = grid_to_pixel(column + direction.x, row + direction.y);
	otherTile.position = grid_to_pixel(column, row);	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#delta could speed up the tween animation? with a tight min and max speed ofc.
	touch_input();
