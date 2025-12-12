extends Label

const MAX_MESSAGES: int = 5

var messages: Array[String] = []
# Called when the node enters the scene tree for the first time.
func add_message(message: String):
	messages.push_back(message)
	if messages.size() > MAX_MESSAGES:
		messages.pop_front()
	self.text = ""
	for msg in messages:
		self.text += msg + ("" if len(messages) == 0 else "\n")
