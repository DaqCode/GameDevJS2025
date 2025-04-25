extends Control

@onready var animation_player := $AnimationPlayer

@onready var play := %Play
@onready var settings := %Settings
@onready var button_cont := %ButtonContainer

var is_setting_open : bool = false

func _ready() -> void:
	for i in button_cont.get_children():
		if i is Button:
			i.connect("pressed", Callable(self, "on_button_pressed").bind(i))
			i.connect("mouse_entered", Callable(self, "on_button_entered").bind(i))
			i.connect("mouse_exited", Callable(self, "on_button_exited").bind(i))


func on_button_pressed(button: Button) -> void:
	if button == play:
		get_tree().change_scene_to_file("res://scenes/UI/main_scene.tscn")
	elif button == settings:
		if not is_setting_open:
			is_setting_open = true
			animation_player.set_current_animation("showSetting")
			animation_player.play()
			
		elif is_setting_open:
			is_setting_open = false
			animation_player.set_current_animation("hideSetting")
			animation_player.play()

func on_button_entered(button: Button) -> void:
	button.pivot_offset = Vector2(194, 32)

	var tween = create_tween()
	tween.tween_property(button, "scale", Vector2(1.1,1.1), 0.15).set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)


func on_button_exited(button: Button) -> void:
	button.pivot_offset = Vector2(194, 32)
	var tween = create_tween()
	tween.tween_property(button, "scale", Vector2(1.0, 1.0), 0.1).set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)
	

#328, 64
# haalf is 194, 32
