extends AnimatableBody2D

@export var id_door := 1
var is_button_push := false
@onready var start_positon := position.y

func _ready() -> void:
	Events.button_push.connect(open)
	Events.button_not_push.connect(close)

func _physics_process(delta: float) -> void:
	if is_button_push and start_positon - 200 <= position.y:
		position.y -= 50 * delta
	elif !is_button_push and position.y != start_positon:
		position.y += 50 * delta
	


func open(id_button):
	if id_button == id_door:
		is_button_push = true
		
func close(id_button):
	if id_button == id_door:
		is_button_push = false
