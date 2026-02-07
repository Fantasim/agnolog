<details><summary>See patch notes</summary>

<br />

{{CHANGELOG}}

<br />
</details>

---

## Download & Installation

Choose the archive for your platform:

| Platform | Architecture | Download |
|----------|-------------|----------|
| Linux | x86_64 | [agnolog-v{{VERSION}}-linux-amd64.tar.gz]({{REPO_URL}}/releases/download/v{{VERSION}}/agnolog-v{{VERSION}}-linux-amd64.tar.gz) |
| macOS | Apple Silicon | [agnolog-v{{VERSION}}-macos-arm64.tar.gz]({{REPO_URL}}/releases/download/v{{VERSION}}/agnolog-v{{VERSION}}-macos-arm64.tar.gz) |
| Windows | x86_64 | [agnolog-v{{VERSION}}-windows-amd64.zip]({{REPO_URL}}/releases/download/v{{VERSION}}/agnolog-v{{VERSION}}-windows-amd64.zip) |

---

## Quick Start

<details><summary><b>Linux</b></summary>

```bash
tar -xzf agnolog-v{{VERSION}}-linux-amd64.tar.gz
cd agnolog-v{{VERSION}}-linux-amd64/
chmod +x agnolog
./agnolog --theme mmorpg -n 100
```

**Security note:** Since this is an open-source project without a paid developer certificate, Linux may block execution. Fix with `chmod +x agnolog`.

</details>

<details><summary><b>macOS</b></summary>

```bash
tar -xzf agnolog-v{{VERSION}}-macos-*.tar.gz
cd agnolog-v{{VERSION}}-macos-*/
xattr -d com.apple.quarantine agnolog
./agnolog --theme mmorpg -n 100
```

**Security note:** Since this is an open-source project without a paid Apple Developer certificate, macOS will block the app. Remove quarantine with `xattr -d com.apple.quarantine agnolog`, or right-click the binary and select "Open".

</details>

<details><summary><b>Windows</b></summary>

1. Extract the ZIP archive
2. Open Command Prompt or PowerShell in the extracted folder
3. Run:
```cmd
agnolog.exe --theme mmorpg -n 100
```

**Security note:** Windows Defender SmartScreen may block the app. Click "More info" then "Run anyway".

</details>

---

## Usage

```bash
# List available themes
agnolog --list-themes

# Generate 100 JSON logs
agnolog --theme mmorpg -n 100

# Generate text format logs
agnolog --theme linux-logs -n 1000 -f text

# Output to file
agnolog --theme mmorpg -n 1000 -f text -o server.log

# Use custom external resources
agnolog --resources /path/to/my-theme -n 100
```

---

## Build Verification

<details><summary>See build verification process</summary>

<br />

**Commit:** [`{{COMMIT_SHORT}}`]({{REPO_URL}}/commit/{{COMMIT_SHA}})

You can verify these binaries are authentic by reproducing the build locally.

**Step 1:** Clone and checkout the release commit
```bash
git clone {{REPO_URL}}.git
cd agnolog
git checkout {{COMMIT_SHA}}
```

**Step 2:** Build locally
```bash
pip install -e ".[dev]"
make build-binary
```

**Step 3:** Compare SHA256 checksums

On Linux:
```bash
sha256sum dist/agnolog
```

On macOS:
```bash
shasum -a 256 dist/agnolog
```

On Windows (PowerShell):
```powershell
Get-FileHash dist\agnolog.exe -Algorithm SHA256
```

If the checksums match, the binary is authentic and unmodified.

</details>

### SHA256 Checksums
```
{{CHECKSUMS}}
```
