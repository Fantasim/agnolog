"""Entry point for running agnolog as a module: python -m agnolog"""

import sys

from agnolog.cli import main

if __name__ == "__main__":
    sys.exit(main())
