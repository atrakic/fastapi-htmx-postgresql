#!/usr/bin/env python

import os
import requests

url = os.getenv("URL", "http://127.0.0.1:3000/healthcheck")
print(requests.get(url, timeout=10).json())
