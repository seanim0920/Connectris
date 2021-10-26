extends Object

func load_resources_from_dir(path):
	var array = [];
	var dir = Directory.new()
	dir.open(path)
	dir.list_dir_begin()
	while true:
		var file_name = dir.get_next()
		if file_name == "":
			#break the while loop when get_next() returns ""
			break
		elif !file_name.begins_with("."):
			#get_next() returns a string so this can be used to load the images into an array.
			array.append(load(path + "/" + file_name))
	dir.list_dir_end()
	return array;
