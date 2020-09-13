extends Node

class_name StemGenerator

var patterns = [
	{
		'axiom': 'X',
		'iterations': 7,
		'yaw_delta': 25.7 * PI / 180,
		'roll_delta': 31.2 * PI / 180,
		'pitch_delta': 25.7 * PI / 180,
		'X': 'F[+X][/X][\\X][-X]FX',
		'F': 'FF'
	},
	{
		'axiom': 'X',
		'iterations': 1,
		'yaw_delta': 22.5 * PI / 180,
		'roll_delta': 45 * PI / 180,
		'pitch_delta': 22.5 * PI / 180,
		'X': '[&FL!X]/////[&FL!X]///////[&FL!X]',
		'F': 'S/////F',
		'S': 'FL'
	},
	{
		'axiom': 'F',
		'F': 'FF-[/-F+F+F]+[&+F-F-F]',
		'iterations': 4,
		'yaw_delta': 22.5 * PI / 180,
		'roll_delta': 22.5 * PI / 180,
		'pitch_delta': 22.5 * PI / 180
	},
	{
		'axiom': 'X',
		'iterations': 5,
		'yaw_delta': 22.5 * PI / 180,
		'roll_delta': 22.5 * PI / 180,
		'pitch_delta': 22.5 * PI / 180,
		'X': 'F-[[//X]&+X]+F[\\+FX]^-X',
		'F': 'FF'
	},
	{
		'axiom': 'F',
		'iterations': 5,
		'yaw_delta': 25.7 * PI / 180,
		'roll_delta': 45 * PI / 180,
		'pitch_delta': 25.7 * PI / 180,
		'F': 'F[&+F]&F[/-F]/F'
	},
	{
		'axiom': 'X',
		'iterations': 7,
		'yaw_delta': 25.7 * PI / 180,
		'roll_delta': 25.7 * PI / 180,
		'pitch_delta': 25.7 * PI / 180,
		# 'F[+X][-X]FX'
		'X': 'X-[+F]&X[/+F]-X',
		'F': 'FF'
	},
	{
		'axiom': 'X',
		'iterations': 6,
		'yaw_delta': 60 * PI / 180,
		'roll_delta': 60 * PI / 180,
		'pitch_delta': 60 * PI / 180,
		'X': 'F+X+F',
		'F': 'X-F-X'
	},
	{
		'axiom': 'F-F-F-F',
		'iterations': 2,
		'yaw_delta': 90 * PI / 180,
		'roll_delta': 90 * PI / 180,
		'pitch_delta': 90 * PI / 180,
		'F': 'F+FF-FF-F-F+F+FF-F-F+F+FF+FF-F'
	},
	{
		'axiom': '-F',
		'iterations': 4,
		'yaw_delta': 90 * PI / 180,
		'roll_delta': 90 * PI / 180,
		'pitch_delta': 90 * PI / 180,
		'F': 'F+F-F-F+F'
	},
	{
		'axiom': 'F-F-F-F',
		'iterations': 4,
		'yaw_delta': 90 * PI / 180,
		'roll_delta': 90 * PI / 180,
		'pitch_delta': 90 * PI / 180,
		'F': 'FF-F--F-F'
	},
	{
		'axiom': 'F',
		'iterations': 3,
		'yaw_delta': 30 * PI / 180,
		'roll_delta': 30 * PI / 180,
		'pitch_delta': 30 * PI / 180,
		'F': 'F[+F&[/++F]F]F[/-F[+F][&--F[+F]-F]F[F]-F]F[+F]F'
	},
]

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func apply_rules_to_sentence(pattern, sentence: String) -> String:
	var new_sentence = ''
	for c in sentence:
		if (pattern.has(c)):
			new_sentence += pattern[c]
		else:
			new_sentence += c
	return new_sentence

func get_path_specs(index):
	var pattern = patterns[index]

	var sentence = pattern.axiom
	for _i in range(pattern.iterations):
		sentence = apply_rules_to_sentence(pattern, sentence)
	return { 'sentence': sentence, 'pattern': pattern }
