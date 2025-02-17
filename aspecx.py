from selenium import webdriver
from selenium.webdriver.chrome.options import Options
import time
import signal
import os

class GracefulExit:
    should_exit = False

    def __init__(self):
        signal.signal(signal.SIGINT, self.exit)
        signal.signal(signal.SIGTERM, self.exit)

    def exit(self, signum, frame):
        self.should_exit = True

exit = GracefulExit()

options = Options()
options.add_argument("--kiosk")
options.add_argument("--window-size=1920,1080")
options.add_argument("--no-sandbox")
options.add_argument("--disable-dev-shm-usage")  # Overcome limited resource problems
options.add_experimental_option("excludeSwitches", ["enable-automation"])
options.add_experimental_option('useAutomationExtension', False)

driver = webdriver.Chrome(options=options)

try:
    # Navigate to webpage
    driver.get(os.environ['URL'])
  
    # Just wait a few seconds so you can see logs
    while not exit.should_exit:
        time.sleep(1)
finally:
    driver.quit()
