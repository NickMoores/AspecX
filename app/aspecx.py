from gracefulexit import GracefulExit
from selenium import webdriver
from selenium.webdriver.chrome.options import Options
import os

options = Options()
options.add_argument("--disable-gpu")
options.add_argument("--kiosk")
options.add_argument("--start-maximized")
options.add_argument("--start-fullscreen")
options.add_argument("--window-size=1920,1080")
options.add_argument("--window-position=0,0")
options.add_argument("--no-sandbox")
options.add_argument("--disable-dev-shm-usage")  # Overcome limited resource problems
options.add_experimental_option("excludeSwitches", ["enable-automation"])
options.add_experimental_option('useAutomationExtension', False)

driver = webdriver.Chrome(options=options)

try:
    # Navigate to webpage
    driver.get(os.environ['URL'])
    
    GracefulExit().wait()
finally:
    driver.quit()
