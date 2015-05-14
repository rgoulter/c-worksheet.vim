import hashlib
import glob
import json
import os
import stat
import urllib
import urllib2
import zipfile

from cworksheet.versions import compare_versions

# Repo is at rgoulter/c-worksheet-instrumentor
gh_api = "https://api.github.com"
repo_owner = "rgoulter"
repo = "c-worksheet-instrumentor"



def get_releases():
	s = gh_api + ("/repos/%s/%s/releases" % (repo_owner, repo))
	req = urllib2.Request(s)
	resp = urllib2.urlopen(req)
	resp_body = resp.read()
	resp_json = json.loads(resp_body)

	return resp_json



def get_latest_release():
	s = gh_api + ("/repos/%s/%s/releases/latest" % (repo_owner, repo))
	req = urllib2.Request(s)
	resp = urllib2.urlopen(req)
	resp_body = resp.read()
	resp_json = json.loads(resp_body)

	return resp_json



def is_asset_zip(asset):
	return asset["content_type"] == "application/zip"



def get_latest_release_with_zip():
	all_releases = get_releases()

	if len(all_releases) == 0:
		return None

	has_zip_asset = lambda r : any(map(is_asset_zip, r["assets"]))
	releases_with_zips = filter(has_zip_asset, all_releases)

	d = dict((version_of_release(r), r) for r in releases_with_zips)
	highest_version = sorted(d.keys(), cmp=compare_versions)[-1]

	return d[highest_version]



# GitHub tag_name of a release.
# As string. e.g. "v0.2.3", "v0.2.3-SNAPSHOT"
def version_of_release(release):
	return release["tag_name"]



def get_browser_url_of_smallest_zip(release):
	assets = release["assets"]

	zip_assets = filter(is_asset_zip, assets)

	if len(zip_assets) == 0:
		return None

	(sz, url) = min((a["size"], a["browser_download_url"]) for a in zip_assets)

	return url



# If the user doesn't have any (up-to-date) version of C Worksheet tool,
# this function can:
#  1) get latest version from GitHub releases
#  2) download the zip
#  3) unzip the archive into a suitable location
def install_latest_version(into_folder):
	release = get_latest_release_with_zip()
	if release == None:
		return

	url = get_browser_url_of_smallest_zip(release)
	if url == None:
		return

	archive_name = url.split("/")[-1]
	archive = os.path.join(into_folder, archive_name)

	print "CWorksheet: Downloading %s" % url
	urllib.urlretrieve(url, archive)

	print "CWorksheet: Unzipping archive.."
	with zipfile.ZipFile(archive) as z:
		z.extractall(into_folder)

	# The unzipped files aren't executable.
	scripts = glob.glob(into_folder + "/*/bin/*")
	for script in scripts:
		os.chmod(script, stat.S_IRUSR | stat.S_IWUSR | stat.S_IXUSR)

	print "CWorksheet: Installed!"
