# -*- mode: python ; coding: utf-8 -*-
# agnolog.spec — PyInstaller spec file for building standalone binary.
# Usage: pyinstaller agnolog.spec

import sys
from PyInstaller.utils.hooks import collect_all

block_cipher = None

# Collect all lupa files (including .so extensions that it discovers at runtime)
lupa_datas, lupa_binaries, lupa_hiddenimports = collect_all('lupa')

a = Analysis(
    ['agnolog/cli.py'],
    pathex=['.'],
    binaries=lupa_binaries,
    datas=[
        ('resources', 'resources'),
    ] + lupa_datas,
    hiddenimports=[
        'yaml',
        'jsonschema',
        'agnolog',
        'agnolog.core',
        'agnolog.core.config',
        'agnolog.core.constants',
        'agnolog.core.errors',
        'agnolog.core.factory',
        'agnolog.core.lua_runtime',
        'agnolog.core.lua_adapter',
        'agnolog.core.registry',
        'agnolog.core.resource_loader',
        'agnolog.core.types',
        'agnolog.formatters',
        'agnolog.generators',
        'agnolog.generators.base',
        'agnolog.logutils',
        'agnolog.output',
        'agnolog.scheduling',
    ] + lupa_hiddenimports,
    hookspath=[],
    hooksconfig={},
    runtime_hooks=[],
    excludes=[
        'tkinter',
        'matplotlib',
        'numpy',
        'scipy',
        'PIL',
        'cv2',
        'torch',
        'notebook',
        'IPython',
    ],
    win_no_prefer_redirects=False,
    win_private_assemblies=False,
    cipher=block_cipher,
    noarchive=False,
)

pyz = PYZ(a.pure, a.zipped_data, cipher=block_cipher)

exe = EXE(
    pyz,
    a.scripts,
    a.binaries,
    a.zipfiles,
    a.datas,
    [],
    name='agnolog',
    debug=False,
    bootloader_ignore_signals=False,
    strip=sys.platform != 'win32',
    upx=False,
    console=True,
    disable_windowed_traceback=False,
    argv_emulation=False,
    target_arch=None,
)
