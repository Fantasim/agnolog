"""
File output handlers for writing logs to files.

Supports both simple file output and rotating files.
"""

import os
from pathlib import Path
from typing import Optional

from mmofakelog.core.constants import FILE_ENCODING, FILE_ROTATION_COUNT, FILE_ROTATION_SIZE
from mmofakelog.core.errors import FileWriteError, PermissionDeniedError, DirectoryNotFoundError
from mmofakelog.logging import get_internal_logger
from mmofakelog.output.base import BaseOutputHandler


class FileOutputHandler(BaseOutputHandler):
    """
    Output handler that writes to a file.

    Features:
    - Automatic directory creation
    - Append or overwrite modes
    - Proper encoding support
    - Error handling with helpful messages

    Usage:
        handler = FileOutputHandler("logs/server.log")
        handler.write("log entry")
        handler.close()

        # Or with context manager:
        with FileOutputHandler("logs/server.log") as handler:
            handler.write("log entry")
    """

    def __init__(
        self,
        path: str,
        append: bool = True,
        encoding: str = FILE_ENCODING,
        add_newline: bool = True,
        create_dirs: bool = True,
    ) -> None:
        """
        Initialize file output handler.

        Args:
            path: Path to the output file
            append: Whether to append (True) or overwrite (False)
            encoding: File encoding (default: utf-8)
            add_newline: Whether to add newline after each write
            create_dirs: Whether to create parent directories if needed
        """
        self._path = Path(path)
        self._append = append
        self._encoding = encoding
        self._add_newline = add_newline
        self._create_dirs = create_dirs
        self._file = None
        self._logger = get_internal_logger()
        self._write_count = 0

        self._open_file()

    def _open_file(self) -> None:
        """Open the file for writing."""
        # Create parent directories if needed
        if self._create_dirs:
            try:
                self._path.parent.mkdir(parents=True, exist_ok=True)
            except PermissionError:
                raise PermissionDeniedError(str(self._path.parent), "create directory")
            except OSError as e:
                raise FileWriteError(str(self._path), f"Cannot create directory: {e}")

        # Check if parent directory exists
        if not self._path.parent.exists():
            raise DirectoryNotFoundError(str(self._path.parent))

        # Open the file
        mode = "a" if self._append else "w"
        try:
            self._file = open(self._path, mode, encoding=self._encoding)
            self._logger.debug(f"Opened file for writing: {self._path}")
        except PermissionError:
            raise PermissionDeniedError(str(self._path), "write")
        except OSError as e:
            raise FileWriteError(str(self._path), str(e))

    def write(self, content: str) -> None:
        """
        Write content to the file.

        Args:
            content: The formatted content to write
        """
        if self._file is None:
            return

        if self._add_newline and not content.endswith("\n"):
            content = content + "\n"

        try:
            self._file.write(content)
            self._write_count += 1
        except OSError as e:
            raise FileWriteError(str(self._path), str(e))

    def close(self) -> None:
        """Close the file."""
        if self._file is not None:
            try:
                self._file.flush()
                self._file.close()
                self._logger.debug(
                    f"Closed file: {self._path} ({self._write_count} writes)"
                )
            except OSError as e:
                self._logger.warning(f"Error closing file {self._path}: {e}")
            finally:
                self._file = None

    def flush(self) -> None:
        """Flush the file buffer."""
        if self._file is not None:
            self._file.flush()

    @property
    def path(self) -> Path:
        """Get the file path."""
        return self._path

    @property
    def write_count(self) -> int:
        """Get the number of writes performed."""
        return self._write_count

    def __repr__(self) -> str:
        return f"FileOutputHandler(path={self._path!r}, append={self._append})"


class RotatingFileHandler(BaseOutputHandler):
    """
    Output handler that rotates log files based on size.

    When the file exceeds max_size, it is renamed with a number
    suffix and a new file is started. Old files are deleted when
    max_files is exceeded.

    Files are named: name.log, name.log.1, name.log.2, etc.

    Usage:
        handler = RotatingFileHandler(
            "logs/server.log",
            max_size=10*1024*1024,  # 10MB
            max_files=5
        )
    """

    def __init__(
        self,
        path: str,
        max_size: int = FILE_ROTATION_SIZE,
        max_files: int = FILE_ROTATION_COUNT,
        encoding: str = FILE_ENCODING,
        add_newline: bool = True,
    ) -> None:
        """
        Initialize rotating file handler.

        Args:
            path: Base path for log files
            max_size: Maximum size in bytes before rotation
            max_files: Maximum number of backup files to keep
            encoding: File encoding
            add_newline: Whether to add newline after each write
        """
        self._base_path = Path(path)
        self._max_size = max_size
        self._max_files = max_files
        self._encoding = encoding
        self._add_newline = add_newline
        self._logger = get_internal_logger()

        self._current_size = 0
        self._write_count = 0
        self._rotation_count = 0

        # Create parent directory if needed
        self._base_path.parent.mkdir(parents=True, exist_ok=True)

        # Check existing file size
        if self._base_path.exists():
            self._current_size = self._base_path.stat().st_size

        self._file = open(self._base_path, "a", encoding=self._encoding)

    def _rotate(self) -> None:
        """Rotate log files."""
        self._logger.debug(f"Rotating log file: {self._base_path}")

        # Close current file
        self._file.close()

        # Delete oldest file if at max
        oldest = self._base_path.with_suffix(f".log.{self._max_files}")
        if oldest.exists():
            oldest.unlink()

        # Rename existing backup files
        for i in range(self._max_files - 1, 0, -1):
            old_path = self._base_path.with_suffix(f".log.{i}")
            new_path = self._base_path.with_suffix(f".log.{i + 1}")
            if old_path.exists():
                old_path.rename(new_path)

        # Rename current file to .1
        backup_path = self._base_path.with_suffix(f"{self._base_path.suffix}.1")
        self._base_path.rename(backup_path)

        # Open new file
        self._file = open(self._base_path, "w", encoding=self._encoding)
        self._current_size = 0
        self._rotation_count += 1

    def write(self, content: str) -> None:
        """
        Write content to the file, rotating if needed.

        Args:
            content: The formatted content to write
        """
        if self._add_newline and not content.endswith("\n"):
            content = content + "\n"

        content_size = len(content.encode(self._encoding))

        # Check if rotation is needed
        if self._current_size + content_size > self._max_size:
            self._rotate()

        self._file.write(content)
        self._current_size += content_size
        self._write_count += 1

    def close(self) -> None:
        """Close the file."""
        if self._file is not None:
            self._file.flush()
            self._file.close()
            self._logger.debug(
                f"Closed rotating file: {self._base_path} "
                f"({self._write_count} writes, {self._rotation_count} rotations)"
            )
            self._file = None

    def flush(self) -> None:
        """Flush the file buffer."""
        if self._file is not None:
            self._file.flush()

    @property
    def path(self) -> Path:
        """Get the base file path."""
        return self._base_path

    @property
    def rotation_count(self) -> int:
        """Get the number of rotations performed."""
        return self._rotation_count

    def __repr__(self) -> str:
        return (
            f"RotatingFileHandler(path={self._base_path!r}, "
            f"max_size={self._max_size}, max_files={self._max_files})"
        )
