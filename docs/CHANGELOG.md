# Changelog

All notable changes to Agnolog will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2026-02-06

### Added
- Theme-agnostic log generation engine with Lua generators and YAML data
- 8 built-in themes: MMORPG, Linux logs, macOS, Windows 11, Windows XP, crypto trading, CEX engine, Chess.com
- Multiple output formats: JSON, NDJSON, text, loghub CSV
- Standalone binary distribution for Linux, macOS, and Windows
- `--theme` flag for selecting bundled themes without specifying full path
- Configurable scheduling with recurrence-based event timing
- Merge groups for database schema design validation
- Resource validation command (`agnolog validate`)
