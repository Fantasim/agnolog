"""
Internal logging module for debugging the fake log generator itself.

NOT to be confused with the fake logs being generated - this is
for debugging and monitoring the generator's own operations.

Usage:
    from mmofakelog.logging import get_internal_logger, setup_internal_logging

    # Setup at application start
    setup_internal_logging(level="DEBUG")

    # Get logger in any module
    logger = get_internal_logger()
    logger.info("Generator started")
"""

from mmofakelog.logging.internal_logger import (
    InternalLoggerMixin,
    get_internal_logger,
    setup_internal_logging,
)

__all__ = [
    "setup_internal_logging",
    "get_internal_logger",
    "InternalLoggerMixin",
]
