import itertools
import json
from multiprocessing import Manager, Pool as ThreadPool, cpu_count, current_process
from os import system
import youtube_dl


def get_albums_info(
):
    with open("metadata.json") as metadata:
        metadata = json.load(metadata)
        albums = sorted(metadata.keys())
        return (
            albums,
            [metadata[album]["playlist_id"] for album in albums],
        )


def print_message(
        message,
        messages,
):
    messages["%s" % current_process()] = message
    full_message = "\n".join([
        "process %s: %s" % (process, msg)
        for process, msg in sorted(messages.items())
    ])
    system("clear")
    print("Processes:\n%s" % full_message)


class YDLLogger():
    def debug(self, msg):
        pass
    def warning(self, msg):
        pass
    def error(self, msg):
        pass
def download(
        album,
        playlist,
        messages,
        successes,
        errors,
):
    if isinstance(playlist, list) or playlist.startswith("http"):
        print_message(
            "Ignoring playlist ID %s for %s because not YouTube playlist" % (playlist, album),
            messages,
        )
        errors.append(album)
        return
    try:
        with youtube_dl.YoutubeDL({
                "format": "bestaudio",
                "logger": YDLLogger(),
                "outtmpl": "%s/%%(playlist_index)s %%(title)s.%%(ext)s" % album,
                "quiet": True,
        }) as dl:
            print_message("Downloading %s for %s" % (playlist, album), messages)
            dl.download(["https://www.youtube.com/playlist?list=%s" % playlist])
            print_message("Finished downloading %s for %s" % (playlist, album), messages)
            successes.append(album)
    except youtube_dl.utils.DownloadError:
        print_message("Downloading %s for %s resulted in error" % (playlist, album), messages)
        errors.append(album)


if __name__ == "__main__":
    with Manager() as manager:
        albums, playlists = get_albums_info()
        messages = manager.dict()
        successes = manager.list()
        errors = manager.list()

        pool = ThreadPool(cpu_count())
        pool.starmap(
            download,
            zip(
                albums,
                playlists,
                itertools.repeat(messages),
                itertools.repeat(successes),
                itertools.repeat(errors),
            ),
        )

        system("clear")
        print("Successful downloads:")
        print(successes)
        print("\nErrored downloads:")
        print(errors)
