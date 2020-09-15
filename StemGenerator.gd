class_name StemGenerator
	
var patterns = [
	{
		# 0
		# typical tree
		'axiom': 'X',
		'iterations': 4,
		'yaw_delta': 25.7 * PI / 90,
		'roll_delta': 31.2 * PI / 180,
		'pitch_delta': 25.7 * PI / 180,
		'X': 'F[+Xf]!////[f^X]L[&f&LXL]!L[-X]F[\\X]',
		'F': 'FF',
		'branch_length': 2,
		'branch_width': 3,
		'branch_width_dropoff': 0.707,
		'leaf_length': 1,
		'leaf_angle': 33.0 * PI / 180,
		'leaf_color': Color(.133, .55, .133)
	},
	{
		# 1
		# thin-branched bush/shrub
		'axiom': 'X',
		'iterations': 6,
		'yaw_delta': 22.5 * PI / 180,
		'roll_delta': 22.5 * PI / 180,
		'pitch_delta': 22.5 * PI / 180,
#		'X': '[&FL!Xf]/////[&FL!Xf]///////[&FL!Xf]|',
		'X': [
			{
				'sentence': '[&FL!Xf]/////[&FL!Xf]///////[&FL!Xf]|',
				'p': 0.25
			},
			{
				'sentence': '[&FLXf]///[&FLXf]/////[&FLXf]|',
				'p': 0.25
			},
			{
				'sentence': '[&FLXf]//[&FLXf]\\\\[&FLXf]|',
				'p': 0.25
			},
			{
				'sentence': '[&FLXf]',
				'p': 0.25
			}
		],
		'F': 'S/////F!',
		'S': 'F',
		'branch_length': 2,
		'branch_width': 0.3,
		'branch_width_dropoff': 0.9,
		'leaf_length': 1,
		'leaf_length_randomizer': 0.5,
		'leaf_angle': 22.5 * PI / 180,
		'leaf_color': Color(.133, .55, .133)
	},
	{
		# 2
		'axiom': 'F',
		'F': 'FF-[/-F+F+F]+[&+F-F-F]',
		'iterations': 4,
		'yaw_delta': 22.5 * PI / 180,
		'roll_delta': 22.5 * PI / 180,
		'pitch_delta': 22.5 * PI / 180,
		'branch_length': 1,
		'branch_width': 0.2,
		'branch_width_dropoff': 0.707,
	},
	{
		# 3
		'axiom': 'X',
		'iterations': 5,
		'yaw_delta': 22.5 * PI / 180,
		'roll_delta': 22.5 * PI / 180,
		'pitch_delta': 22.5 * PI / 180,
		'X': 'F-[[//X]&+X]+F[\\+FX]^-X',
		'F': 'FF'
	},
	{
		# 4
		'axiom': 'F',
		'iterations': 5,
		'yaw_delta': 25.7 * PI / 180,
		'roll_delta': 45 * PI / 180,
		'pitch_delta': 25.7 * PI / 180,
		'F': 'F[&+F]&FL[/-Ff]/F',
		'leaf_length': 1,
		'leaf_angle': 22.5 * PI / 180,
		'leaf_color': Color(.133, .55, .133)
	},
	{
		# 5
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
		# 6
		'axiom': 'X',
		'iterations': 6,
		'yaw_delta': 60 * PI / 180,
		'roll_delta': 60 * PI / 180,
		'pitch_delta': 60 * PI / 180,
		'X': 'F+X+F',
		'F': 'X-F-X'
	},
	{
		# 7
		'axiom': 'F-F-F-F',
		'iterations': 2,
		'yaw_delta': 90 * PI / 180,
		'roll_delta': 90 * PI / 180,
		'pitch_delta': 90 * PI / 180,
		'F': 'F+FF-FF-F-F+F+FF-F-F+F+FF+FF-F'
	},
	{
		# 8
		'axiom': '-F',
		'iterations': 4,
		'yaw_delta': 90 * PI / 180,
		'roll_delta': 90 * PI / 180,
		'pitch_delta': 90 * PI / 180,
		'F': 'F+F-F-F+F'
	},
	{
		# 9
		'axiom': 'F-F-F-F',
		'iterations': 4,
		'yaw_delta': 90 * PI / 180,
		'roll_delta': 90 * PI / 180,
		'pitch_delta': 90 * PI / 180,
		'F': 'FF-F--F-F'
	},
	{
		# 10
		'axiom': 'F',
		'iterations': 3,
		'yaw_delta': 30 * PI / 180,
		'roll_delta': 30 * PI / 180,
		'pitch_delta': 30 * PI / 180,
		'F': 'F[+F&[/++F]F]F[/-F[+F][&--F[+F]-F]F[F]-F]F[+F]F'
	},
	{
		# 11
		# thin plant with flowers
		'axiom': 'P',
		'iterations': 5,
		'yaw_delta': 18 * PI / 180,
		'roll_delta': 18 * PI / 180,
		'pitch_delta': 18 * PI / 180,
		'P': 'I+[P+f]--//[--L]I[++L]-[Pf]++P',
		'I': 'FS[//&&L][//^^L]FS',
		'S': 'FS',
		'branch_length': 1,
		'branch_width': 0.1,
		'branch_width_dropoff': 0.707,
		'leaf_length': 0.6,
		'leaf_angle': 22.5 * PI / 180,
		'leaf_color': Color(.133, .55, .133)
	},
	{
		# 12
		# stochastic plant
		'axiom': 'F',
		'iterations': 5,
		'yaw_delta': 25.7 * PI / 180,
		'roll_delta': 25.7 * PI / 180,
		'pitch_delta': 25.7 * PI / 180,
		'F': [
			{ 'sentence': 'F[+F]F[−F]F', 'p': 0.33 },
			{ 'sentence': 'F[+F]F', 'p': 0.33 },
			{ 'sentence': 'F[-F]F', 'p': 0.34 },
		],
		'branch_length': 1,
		'branch_width': 0.3,
		'branch_width_dropoff': 0.707,
		'leaf_length': 0.6,
		'leaf_angle': 18 * PI / 180,
		'leaf_color': Color(.133, .55, .133)
	}
]

func apply_rules_to_sentence(pattern, sentence: String) -> String:
	var new_sentence = ''
	for c in sentence:
		if pattern.has(c):
			if pattern[c] is Array:
				var r = randf()
				var i = 0
				while r >= 0 && i < pattern[c].size():
					r = r - pattern[c][i].p
					if (r <= 0):
						new_sentence += pattern[c][i].sentence
					i += 1
			else:
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
