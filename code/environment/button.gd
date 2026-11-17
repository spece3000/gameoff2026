extends Area2D

@onready var anim = $AnimatedSprite2D
@export var id_button := 1

func _on_body_entered(body: Node2D) -> void:
	anim.play("push")
	Events.button_push.emit(id_button)

func _on_body_exited(body: Node2D) -> void:
	anim.play("default")
	Events.button_not_push.emit(id_button)
