"""Entry point for running mmofakelog as a module: python -m mmofakelog"""

import sys

from mmofakelog.cli import main

if __name__ == "__main__":
    sys.exit(main())
