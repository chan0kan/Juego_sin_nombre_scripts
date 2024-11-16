extends ParallaxBackground

func _ready():
	var layers = self.get_children()
	var speeds = [0.1, 0.3, 0.6, 1.0]
	for i in range(layers.size()):
		if i < speeds.size():
			layers[i].motion_scale = Vector2(speeds[i], speeds[i])
