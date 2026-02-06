# Agnolog v{{VERSION}} - Windows Quick Start

## Running

Double-click `agnolog.exe` or run from Command Prompt:

```cmd
agnolog.exe --theme mmorpg -n 100
```

---

## Security Warning Bypass

Since this is an open-source project without a paid Microsoft certificate, Windows Defender SmartScreen will block the app.

**Fix:**
1. Click "More info"
2. Click "Run anyway"

Or add an exception in Windows Security settings.

---

## Available Themes

```cmd
agnolog.exe --list-themes
```

## Usage

```cmd
REM Generate 100 JSON logs with MMORPG theme
agnolog.exe --theme mmorpg -n 100

REM Generate text format logs
agnolog.exe --theme linux-logs -n 1000 -f text

REM Use custom resources directory
agnolog.exe --resources C:\path\to\my-theme -n 100

REM List all log types in a theme
agnolog.exe --theme mmorpg --list-types
```

---

## Verify Authenticity (Optional)

**Step 1:** Open PowerShell and run:
```powershell
Get-FileHash agnolog.exe -Algorithm SHA256
```

**Step 2:** Compare with the hash in `SHA256SUMS.txt` from the release page.

**Step 3:** To fully verify, clone and build from source:
```bash
git clone {{REPO_URL}}.git
cd logsimulator
git checkout {{COMMIT_SHA}}
pip install -e ".[dev]"
make build-binary
```

Then compare:
```powershell
Get-FileHash dist\agnolog.exe -Algorithm SHA256
```

If the checksums match, the binary is authentic and unmodified.

---

## Version Info

```cmd
agnolog.exe --version
```
