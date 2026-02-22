import subprocess
import urllib.parse
from gi.repository import GObject, Nautilus


class OpenAsAdminExtension(GObject.GObject, Nautilus.MenuProvider):
    """右键菜单添加「Open as Administrator」"""

    def _open(self, _menu, path):
        admin_uri = f"admin://{urllib.parse.quote(path, safe='/')}"
        subprocess.Popen(["nautilus", admin_uri])

    def _uri_to_path(self, uri):
        return urllib.parse.unquote(uri[len("file://"):])

    def get_background_items(self, *args):
        folder = args[-1]
        path = self._uri_to_path(folder.get_uri())
        item = Nautilus.MenuItem(
            name="OpenAsAdmin::Background",
            label="Open as Administrator",
            tip="Open this folder with root privileges",
        )
        item.connect("activate", self._open, path)
        return [item]

    def get_file_items(self, *args):
        files = args[-1]
        dirs = [f for f in files if f.is_directory()]
        if not dirs:
            return []
        path = self._uri_to_path(dirs[0].get_uri())
        item = Nautilus.MenuItem(
            name="OpenAsAdmin::FileItem",
            label="Open as Administrator",
            tip="Open this folder with root privileges",
        )
        item.connect("activate", self._open, path)
        return [item]
