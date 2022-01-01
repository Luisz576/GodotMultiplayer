extends Button

var data:Card = null

signal onClick
signal onDisabledClick

#READY
func _ready():
	setEnable(true)
	$card_background.scale = rect_size / $card_background.texture.get_size()
	$panel_fume.scale = rect_size / $panel_fume.texture.get_size()

func getCard()->Card:
	return data

func setCard(card:Card):
	data = card
	_rebuild_card()

func setEnable(enable):
	$panel_fume.visible = !enable

func isEnable()->bool:
	return !$panel_fume.visible

#REBUILD
func _rebuild_card():
	print("TODO: Rebuild card")
	var characterMeta = data.getMeta()
	$card_name.text = characterMeta.nome

#SIGNALS
func _on_CardBase_button_down():
	if isEnable():
		emit_signal("onClick")
	else:
		emit_signal("onDisabledClick")
