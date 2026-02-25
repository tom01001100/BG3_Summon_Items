# BG3 Summon Items

This project provides an AutoIt helper for grabbing items from a summoned character (Mage Hand, Dryad, Azer, etc) in  **Baldur's Gate 3**.

![Video example](./bg3_summon_items_example.gif)
## Files

- `bg3_summon_items_config.au3`
  - The script to run with AutoIt
- `bg3_summon_items_config.ini`
  - External settings file for hotkeys and slot offsets.

## What This Does

1. You launch `bg3_summon_items_config.au3`.
2. Select a slot in the helper UI (Head, Cloak, Ring1, etc.).
3. Hover your mouse over the summon-item preview button in BG3.
4. Press the action hotkey (default `F8`).
5. The script:
   - Captures your current mouse position.
   - Applies the selected slot offsets from the INI file.
   - Clicks preview, moves to slot, holds mouse down, and drags slightly.
6. Now the item is on your cursor, and you can open your character inventory to drop it there, or click it on your character's equipped (same) item slot to swap.
7. Press the stop hotkey (default `F10`) to stop the script. You can also just leave it running, and it will listen for the next Action Hotkey.

## Requirements

- Windows
- AutoIt v3 (SciTE optional but useful) for running the .au3

## Quick Start

1. Keep these two files in the same folder:
   - `bg3_summon_items_config.au3`
   - `bg3_summon_items_config.ini`
2. Run `bg3_summon_items_config.au3`.
3. In BG3, open inventory for a summon or your own character for testing, and test a slot with `F8`.
4. If it misses the slot, tune offsets in the INI and test again.

## Configuration

All settings are in `bg3_summon_items_config.ini`.

### Hotkeys

```ini
[Hotkeys]
Action={F8}
Stop={F10}
```

- `Action`: hotkey that performs click/move/drag.
- `Stop`: hotkey that releases mouse and exits. Also can click the "x" in the UI window.

AutoIt hotkey format examples:
- `{F8}` = F8
- `^!s` = Ctrl+Alt+S
- `+{F9}` = Shift+F9

### Offsets

```ini
[Offsets]
HeadX=-157
HeadY=-837
...
```

Each slot uses two values:
- `<SlotName>X`
- `<SlotName>Y`

Where `<SlotName>` is one of:
- `Head`
- `Cloak`
- `Chest`
- `Gloves`
- `Boots`
- `Light`
- `MeleeMain`
- `MeleeOff`
- `Amulet`
- `Ring1`
- `Ring2`
- `Instrument`
- `RangedMain`
- `RangedOff`

## How To Calibrate Offsets

1. Start with the provided defaults.
2. Pick one slot in the helper UI.
3. Hover over preview button in BG3 and press action hotkey.
4. If target lands too far:
   - right: decrease negative X or increase positive X
   - left: increase negative X or decrease positive X
   - down: increase Y
   - up: decrease Y
5. Save INI and test again.
6. Repeat for each slot until reliable.

## Notes For Sharing

- Share both files together:
  - `bg3_summon_items_config.au3`
  - `bg3_summon_items_config.ini`
- Recipients usually only need to edit the INI, not script code.
- Different resolution/UI scale/aspect ratio setups may require different offsets.

## Safety / Limitations

- This script automates mouse movement/click/drag only.
- It is resolution and UI-layout dependent.
