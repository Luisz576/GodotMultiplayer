extends Node
class_name Saver

const SAVE_DIR_PATH = "user://saves/"

var FILE_PATH = ""

func _setupDir():
	var dir = Directory.new()
	if !dir.dir_exists(SAVE_DIR_PATH):
		dir.make_dir_recursive(SAVE_DIR_PATH)
	pass

func _init(path):
	_setupDir()
	FILE_PATH = SAVE_DIR_PATH + path
	pass

func getData():
	var file = File.new()
	var erro = file.open(FILE_PATH, File.READ)
	var data = null
	if not erro:
		data = file.get_var()
	file.close()
	return data

func save(dados):
	var file = File.new()
	var erro = file.open(FILE_PATH, File.WRITE)
	var result = false
	if not erro:
		file.store_var(dados)
		result = true
	file.close()
	return result

func delete():
	var dir = Directory.new()
	dir.remove(FILE_PATH)
	pass

func clear():
	save(null)
	pass
