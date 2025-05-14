extends Timer
class_name CustomTimer

signal completed

static func trigger(time: float):
	var timer = Utils.instanciate(ScenesHandler.customTimerScene, Ref.utils)
	timer.wait_time = time
	timer.start()
	yield(timer, "timeout")
	timer.emit_signal("completed")
	timer.queue_free()
