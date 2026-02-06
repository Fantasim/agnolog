# Agnolog v{{VERSION}} - Linux Quick Start

## Running

```bash
chmod +x agnolog
./agnolog --theme mmorpg -n 100
```

---

## Available Themes

```bash
./agnolog --list-themes
```

## Usage

```bash
# Generate 100 JSON logs with MMORPG theme
./agnolog --theme mmorpg -n 100

# Generate text format logs
./agnolog --theme linux-logs -n 1000 -f text

# Use custom resources directory
./agnolog --resources /path/to/my-theme -n 100

# List all log types in a theme
./agnolog --theme mmorpg --list-types
```

---

## Security Warning Bypass

Since this is an open-source project without a paid developer certificate, Linux may block execution.

**Fix:** Make the binary executable:
```bash
chmod +x agnolog
```

---

## Verify Authenticity (Optional)

**Step 1:** Run SHA256 checksum:
```bash
sha256sum agnolog
```

**Step 2:** Compare with the hash in `SHA256SUMS.txt` from the release page.

**Step 3:** To fully verify, clone and build from source:
```bash
git clone {{REPO_URL}}.git
cd agnolog
git checkout {{COMMIT_SHA}}
pip install -e ".[dev]"
make build-binary
sha256sum dist/agnolog
```

If the checksums match, the binary is authentic and unmodified.

---

## Version Info

```bash
./agnolog --version
```
