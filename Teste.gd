extends Node2D

var vetor = []

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in 4:
		vetor.append(i)
	print(vetor) 
			
#	print(vetor)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
