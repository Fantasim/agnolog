# Agnolog v{{VERSION}} - macOS Quick Start

## Running

```bash
./agnolog --theme mmorpg -n 100
```

---

## Security Warning Bypass

Since this is an open-source project without a paid Apple Developer certificate, macOS will block the app.

**Fix:** Remove quarantine attribute:
```bash
xattr -d com.apple.quarantine agnolog
```

Or right-click the binary, select "Open", then click "Open" again in the dialog.

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

## Verify Authenticity (Optional)

**Step 1:** Run SHA256 checksum:
```bash
shasum -a 256 agnolog
```

**Step 2:** Compare with the hash in `SHA256SUMS.txt` from the release page.

**Step 3:** To fully verify, clone and build from source:
```bash
git clone {{REPO_URL}}.git
cd agnolog
git checkout {{COMMIT_SHA}}
pip install -e ".[dev]"
make build-binary
shasum -a 256 dist/agnolog
```

If the checksums match, the binary is authentic and unmodified.

---

## Version Info

```bash
./agnolog --version
```
