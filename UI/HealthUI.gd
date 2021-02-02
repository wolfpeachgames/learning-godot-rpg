extends Control

const HEART_UI_SPRITE_WIDTH = 15

var hearts: float = 4 setget set_hearts
var max_hearts: float = 4 setget set_max_hearts

onready var heartUIFull = $HeartUIFull
onready var heartUIEmpty = $HeartUIEmpty

func set_hearts(value: float):
	hearts = clamp(value, 0, max_hearts)
	if (heartUIFull != null):
		heartUIFull.rect_size.x = hearts * HEART_UI_SPRITE_WIDTH

func set_max_hearts(value: float):
	max_hearts = max(value, 1)
	self.hearts = min(hearts, max_hearts)
	if (heartUIEmpty != null):
		heartUIEmpty.rect_size.x = max_hearts * HEART_UI_SPRITE_WIDTH

func _ready():
	self.max_hearts = PlayerStats.max_health
	self.hearts = PlayerStats.health
	PlayerStats.connect("health_changed", self, "set_hearts")
	PlayerStats.connect("max_health_changed", self, "set_max_hearts")
