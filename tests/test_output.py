"""
Tests for agnolog.output module.

Tests output handlers for file and stream output.
"""

import pytest
import os
from io import StringIO
from unittest.mock import patch, MagicMock

from agnolog.output import (
    StreamOutputHandler,
    FileOutputHandler,
    RotatingFileHandler,
)


class TestStreamOutputHandler:
    """Tests for StreamOutputHandler."""

    def test_write_to_custom_stream(self):
        """Should write to custom stream."""
        custom_stream = StringIO()
        handler = StreamOutputHandler(stream=custom_stream, add_newline=False)

        handler.write("test message")

        assert "test message" in custom_stream.getvalue()

    def test_write_with_newline(self):
        """Should add newline when enabled."""
        custom_stream = StringIO()
        handler = StreamOutputHandler(stream=custom_stream, add_newline=True)

        handler.write("line1")
        handler.write("line2")

        output = custom_stream.getvalue()
        assert "line1\n" in output
        assert "line2\n" in output

    def test_write_without_newline(self):
        """Should not add newline when disabled."""
        custom_stream = StringIO()
        handler = StreamOutputHandler(stream=custom_stream, add_newline=False)

        handler.write("line1")
        handler.write("line2")

        output = custom_stream.getvalue()
        assert output == "line1line2"

    def test_close_does_not_close_stream(self):
        """Should not close the underlying stream."""
        custom_stream = StringIO()
        handler = StreamOutputHandler(stream=custom_stream)

        handler.close()

        # Stream should still be usable
        custom_stream.write("after close")
        assert "after close" in custom_stream.getvalue()

    def test_flush(self):
        """Should flush stream."""
        mock_stream = MagicMock()
        handler = StreamOutputHandler(stream=mock_stream)

        handler.flush()

        mock_stream.flush.assert_called()

    def test_auto_flush(self):
        """Should auto flush when enabled."""
        mock_stream = MagicMock()
        handler = StreamOutputHandler(stream=mock_stream, auto_flush=True)

        handler.write("test")

        mock_stream.flush.assert_called()

    def test_no_auto_flush(self):
        """Should not auto flush when disabled."""
        mock_stream = MagicMock()
        handler = StreamOutputHandler(stream=mock_stream, auto_flush=False)

        handler.write("test")

        # flush should not have been called on write
        assert mock_stream.flush.call_count == 0


class TestFileOutputHandler:
    """Tests for FileOutputHandler."""

    def test_write_to_file(self, tmp_path):
        """Should write to file."""
        output_file = tmp_path / "test.log"
        handler = FileOutputHandler(str(output_file))

        handler.write("test message")
        handler.close()

        assert output_file.exists()
        assert "test message" in output_file.read_text()

    def test_write_multiple_lines(self, tmp_path):
        """Should write multiple lines."""
        output_file = tmp_path / "test.log"
        handler = FileOutputHandler(str(output_file))

        handler.write("line1")
        handler.write("line2")
        handler.write("line3")
        handler.close()

        content = output_file.read_text()
        assert "line1" in content
        assert "line2" in content
        assert "line3" in content

    def test_creates_parent_directories(self, tmp_path):
        """Should create parent directories."""
        output_file = tmp_path / "subdir" / "nested" / "test.log"
        handler = FileOutputHandler(str(output_file))

        handler.write("test")
        handler.close()

        assert output_file.exists()

    def test_append_mode(self, tmp_path):
        """Should append when append=True."""
        output_file = tmp_path / "test.log"

        # First write (overwrite to start fresh)
        handler1 = FileOutputHandler(str(output_file), append=False)
        handler1.write("first")
        handler1.close()

        # Second write (append)
        handler2 = FileOutputHandler(str(output_file), append=True)
        handler2.write("second")
        handler2.close()

        content = output_file.read_text()
        assert "first" in content
        assert "second" in content

    def test_overwrite_mode(self, tmp_path):
        """Should overwrite when append=False."""
        output_file = tmp_path / "test.log"

        # First write
        handler1 = FileOutputHandler(str(output_file), append=False)
        handler1.write("first")
        handler1.close()

        # Second write (overwrite)
        handler2 = FileOutputHandler(str(output_file), append=False)
        handler2.write("second")
        handler2.close()

        content = output_file.read_text()
        assert "first" not in content
        assert "second" in content

    def test_context_manager(self, tmp_path):
        """Should work as context manager."""
        output_file = tmp_path / "test.log"

        with FileOutputHandler(str(output_file)) as handler:
            handler.write("test message")

        assert output_file.exists()
        assert "test message" in output_file.read_text()

    def test_encoding(self, tmp_path):
        """Should handle unicode."""
        output_file = tmp_path / "test.log"
        handler = FileOutputHandler(str(output_file), encoding="utf-8")

        handler.write("Hello \u4e16\u754c")  # "Hello World" in Chinese
        handler.close()

        content = output_file.read_text(encoding="utf-8")
        assert "\u4e16\u754c" in content


class TestRotatingFileHandler:
    """Tests for RotatingFileHandler."""

    def test_write_to_file(self, tmp_path):
        """Should write to file."""
        output_file = tmp_path / "test.log"
        handler = RotatingFileHandler(str(output_file))

        handler.write("test message")
        handler.close()

        assert output_file.exists()
        assert "test message" in output_file.read_text()

    def test_rotation_creates_backup(self, tmp_path):
        """Should create backup file on rotation."""
        output_file = tmp_path / "test.log"
        # Small max size to trigger rotation
        handler = RotatingFileHandler(
            str(output_file),
            max_size=50,
            max_files=3,
        )

        # Write enough to trigger rotation
        for i in range(10):
            handler.write(f"Line {i}: " + "x" * 20)

        handler.close()

        # Should have created backup files
        backup_files = list(tmp_path.glob("test.log.*"))
        assert len(backup_files) > 0

    def test_max_files_limits_backups(self, tmp_path):
        """Should limit number of backup files."""
        output_file = tmp_path / "test.log"
        handler = RotatingFileHandler(
            str(output_file),
            max_size=30,
            max_files=2,
        )

        # Write enough to trigger multiple rotations
        for i in range(20):
            handler.write(f"Line {i}: " + "x" * 20)

        handler.close()

        # Should have at most max_files backup files
        backup_files = list(tmp_path.glob("test.log.*"))
        assert len(backup_files) <= 2

    def test_no_rotation_when_under_size(self, tmp_path):
        """Should not rotate when under max size."""
        output_file = tmp_path / "test.log"
        handler = RotatingFileHandler(
            str(output_file),
            max_size=10000,
            max_files=3,
        )

        handler.write("small message")
        handler.close()

        # Should not have backup files
        backup_files = list(tmp_path.glob("test.log.*"))
        assert len(backup_files) == 0


class TestOutputHandlerInterface:
    """Tests for output handler interface compliance."""

    def test_stream_handler_has_write(self):
        """StreamOutputHandler should have write method."""
        handler = StreamOutputHandler(stream=StringIO())
        assert hasattr(handler, "write")
        assert callable(handler.write)

    def test_stream_handler_has_close(self):
        """StreamOutputHandler should have close method."""
        handler = StreamOutputHandler(stream=StringIO())
        assert hasattr(handler, "close")
        assert callable(handler.close)

    def test_file_handler_has_write(self, tmp_path):
        """FileOutputHandler should have write method."""
        handler = FileOutputHandler(str(tmp_path / "test.log"))
        assert hasattr(handler, "write")
        assert callable(handler.write)
        handler.close()

    def test_file_handler_has_close(self, tmp_path):
        """FileOutputHandler should have close method."""
        handler = FileOutputHandler(str(tmp_path / "test.log"))
        assert hasattr(handler, "close")
        assert callable(handler.close)
        handler.close()
