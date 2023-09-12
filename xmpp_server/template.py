import sys
import os

with open(sys.argv[1], "r") as file:
    content = file.read()

for key, value in os.environ.items():
    # print(key, value)
    content = content.replace(f"{{{{{key}}}}}", value)

# print(content)

with open(sys.argv[2], "w") as file:
    file.write(content)
