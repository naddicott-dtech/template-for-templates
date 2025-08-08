extends Node

const SAVE_PATH := "user://save.json"

func build_snapshot() -> Dictionary:
	var snapshot: Dictionary = {
		"globals": {
			"money": Globals.money,
			"day": Globals.day
		},
		"savables": []
	}
	# gather snapshots from any node that opts in
	for n in get_tree().get_nodes_in_group("savable"):
		if "get_snapshot" in n:
			snapshot["savables"].append({
				"path": n.get_path(), #stable path is best
				"data": n.get_snapshot()
			})
	return snapshot
	
func apply_snapshot(snapshot: Dictionary) -> void:
	if snapshot.has("globals"):
		var savedGlobals = snapshot["globals"]
		if savedGlobals.has("money"):
			Globals.money = int(savedGlobals["money"])
			SignalBus.money_changed.emit(Globals.money)
		if savedGlobals.has("day"):
			Globals.day = int(savedGlobals["day"])
			SignalBus.day_ended.emit(Globals.day) #re-synch hud
	if snapshot.has("savables"):
		for entry in snapshot["savables"]:
			var node := get_node_or_null(entry.get("path",""))
			if node and "apply_snapshot" in node:
				node.apply_snapshot(entry.get("data", {}))
				
func save_game() -> bool:
	var file := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(build_snapshot(), " "))
		file.flush()
		return true
	return false
	
func load_game() -> bool:
	if not FileAccess.file_exists(SAVE_PATH):
		return false
	var file := FileAccess.open(SAVE_PATH, FileAccess.READ)
	if not file:
		return false
	var parsed : Dictionary = JSON.parse_string(file.get_as_text())
	if parsed.is_empty():
		return false
	apply_snapshot(parsed)
	return true
		
