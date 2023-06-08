traffic_light_garbage = list()

"""
filter garbage

arguments:
arr -- garbage filter memory list
val -- input value
sensitivity -- minimum amount of `val` in `arr` to return `val`
limit -- max length of `arr`

return value:
if `arr` contains `sensitivity` or more of any item, that item will be
returned, else None is returned
"""
def garbage_filter(arr, val, sensitivity, limit):
	if val == None: return None
	arr[:] = [None]*(limit - len(arr)) + arr
	arr.pop(0)
	arr.append(val)
	if len([x for x in arr if x == val]) >= sensitivity:
		return val
	return None

if __name__ == "__main__":
	inputs = [
		"red",
		None,
		"green",
		"green",
		None,
		"red",
		"green",
		"red",
		"red",
		None,
		None
	]
	for x in inputs:
		print(garbage_filter(traffic_light_garbage, x, 3, 4))
