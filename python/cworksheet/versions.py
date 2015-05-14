# I want to know what versions of stuff are being kept
# under some e.g.`tool/` folder of the plugin.
# e.g. might have an old version there, and a newer version may be
# available for download.

# At the moment, folder is:
#   cworksheet-proguard-0.2.3-SNAPSHOT
# where `0.2.3-SNAPSHOT` is the version number.
# So, I expect the format to be in form of:
#   <something>-<version>,
# where <version> *startswith* #.# (and two-four parts),
# with maybe some "-qualifier" after it.

# If the folder doesn't have a version number,
# then we don't know what version it is.
# Not sure how to work around that problem, other than
# disregarding that folder for consideration.

import re
import glob



# Grabs something which 'looks like' a version number,
# e.g. 1.0, 1.1.0, 1.2-SNAPSHOT in above examples.
version_regex = "\\d(\\.\\d)+(-\\w+)?"



# "cworksheet-1.0" -> "1.0"
# "arbitrary" -> None
def version_number_of(s):
	match = re.search(version_regex, s)

	if match != None:
		return match.group()
	else:
		return None



# `path` is a string pointing to a directory.
# e.g. <plugin_dir>/tool
#
# returns as list of (version, path) tuples.
def find_runscripts_under_folder(path, script_name="c-worksheetify-server"):
	# Python's glob is a bit limited, in that wildcards only apply to one level.
	# For now, this is fine.
	scripts = glob.glob(path + "/*/bin/" + script_name)

	return [(version_number_of(s), s) for s in scripts]



# Compare two version strings.
# Aiming for:
#   1.0 < 1.1
#   1.0 < 1.0.0
#   1.9 < 1.10
#   1.0-RC < 1.0
def compare_versions(s1, s2):
	# Normalise to (v, qualifier) where
	#  v is list of numbers [1, 0]
	#  qualifier is e.g. "SNAPSHOT", or None
	def nml(s):
		tmp = s.split("-", 1)
		v_str, qual = tmp[0], (tmp + [None])[1]
		ver = [int(i) for i in v_str.split(".")]
		return (ver, qual)

	(v1, q1) = nml(s1)
	(v2, q2) = nml(s2)

	if v1 != v2:
		return cmp(v1, v2)
	else:
		# Any non-None is greater than none, thus `-cmp` to reverse this.
		# Comparing to non-None ("qualified") versions is
		#  arbitrary, here.
		return -cmp(q1, q2)



# For finding which versions are under `tool/`,
# find the highest/latest version.
# Also allow to check "is at least higher"?
#
# `rs` is list of (version, path) tuples.
#
# returns empty string for no valid result found.
def script_with_latest_version(rs, at_least=None):
	if rs == None or len(rs) == 0:
		return ''

	d = dict(rs)
	highest_version = sorted(d.keys(), cmp=compare_versions)[-1]

	if at_least == None or compare_versions(highest_version, at_least) >= 0:
		# If don't have "at least", or
		# highest_version is eq/gt least_version,
		return d[highest_version]
	else:
		return ''
