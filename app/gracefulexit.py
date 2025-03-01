import signal
import threading

class GracefulExit:
    def __init__(self):
        self.handlers = []
        self.event = threading.Event()
        signal.signal(signal.SIGINT, self._exit)
        signal.signal(signal.SIGTERM, self._exit)

    def _exit(self, signum, frame):
        self.event.set()
        for handler in self.handlers:
            handler()

    def wait(self):
        self.event.wait()

    def add_handler(self, handler):
        self.handlers.append(handler)