extends Node2D
class_name InteractableComponent

signal interacted(cursor)

signal released

@export var is_grabbable: bool = false # Potentielement pour decider si on envoie strenght ou non

func interact(cursor):
	interacted.emit(cursor)

func release():
	released.emit()
