extends Node

const GAME_DATA_PATH = "user://game_data.json"
const GAME_DATA_TEMPLATE = {
	"energy": 500.0,
	"coins": 100,
	"health_multiplier": 1.0,
	"strength_multiplier": 1.0
}

var energy: float
var coins: int
var health_multiplier: float
var strength_multiplier: float


func _ready():
	load_game_data()


func _notification(what):
	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
		save_game_data()
		get_tree().quit()


func load_game_data():
	var f = File.new()
	
	if f.file_exists(GAME_DATA_PATH):
		f.open(GAME_DATA_PATH, File.READ)
		var raw_data = f.get_as_text()
		var parsed_data = parse_json(raw_data)
		
		energy = parsed_data["energy"]
		coins = parsed_data["coins"]
		health_multiplier = parsed_data["health_multiplier"]
		strength_multiplier = parsed_data["strength_multiplier"]
		
	else:
		f.open(GAME_DATA_PATH, File.WRITE)
		f.store_string(to_json(GAME_DATA_TEMPLATE))
		
		energy = GAME_DATA_TEMPLATE["energy"]
		coins = GAME_DATA_TEMPLATE["coins"]
		health_multiplier = GAME_DATA_TEMPLATE["health_multiplier"]
		strength_multiplier = GAME_DATA_TEMPLATE["strength_multiplier"]
	
	f.close()


func save_game_data():
	var f = File.new()
	f.open(GAME_DATA_PATH, File.WRITE)
	
	var data = {
		"energy": energy,
		"coins": coins,
		"health_multiplier": health_multiplier,
		"strength_multiplier": strength_multiplier
	}
	
	f.store_string(to_json(data))
	f.close()
