extends Control

func _ready() -> void:
	$GameOverScreen/TotalAshes.text = "Total ashes: %d" %GlobalPlayerScript.total_ashes_throughout

	if 0 < GlobalPlayerScript.total_ashes_throughout and GlobalPlayerScript.total_ashes_throughout < 70:
		$GameOverScreen/PersonalWords.text = "Are you serious..? How? Or is it the newbie's fault..."
	elif 71 < GlobalPlayerScript.total_ashes_throughout and GlobalPlayerScript.total_ashes_throughout < 150:
		$GameOverScreen/PersonalWords.text = "You're getting there. There can be more done, but keep going!"
	elif 151 < GlobalPlayerScript.total_ashes_throughout and GlobalPlayerScript.total_ashes_throughout  < 300:
		$GameOverScreen/PersonalWords.text = "Damn. Lived longer than we would have when the newbie tried to debug."
	elif 301 < GlobalPlayerScript.total_ashes_throughout and GlobalPlayerScript.total_ashes_throughout < 500:
		$GameOverScreen/PersonalWords.text = "You lived a lot longer than the previous longer than we would have thought. Well done flamer."
	elif 501 < GlobalPlayerScript.total_ashes_throughout and GlobalPlayerScript.total_ashes_throughout < 600:
		$GameOverScreen/PersonalWords.text = "Almost. You just had to last a little bit more longer, and you'll be the new flame-ster."
	elif GlobalPlayerScript.total_ashes_throughout > 600:
		$GameOverScreen/PersonalWords.text = "Wow. How did you get this far..? Eh, we don't have much else to say. Congradulations on your promotion."
