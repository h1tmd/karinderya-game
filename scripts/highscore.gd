extends Resource
class_name HighScore

@export var normal_highscore: float = 0
@export var hard_highscore: float = 0

const SAVE_PATH: String = "user://high_score.tres"

func save():
	ResourceSaver.save(self, SAVE_PATH)

static func load() -> HighScore:
	var res: HighScore
	if FileAccess.file_exists(SAVE_PATH):
		res = load(SAVE_PATH) as HighScore
	else:
		res = HighScore.new()
	return res
