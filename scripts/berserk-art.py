#!/usr/bin/env python3
"""
Berserk dashboard art — Dragon Slayer sword in Braille art.
Outputs with 24-bit ANSI crimson coloring. No dependencies.
"""
import sys

BLANK = "\u2800"  # Braille blank (U+2800) — acts as transparent space

def fg(r, g, b): return f"\033[38;2;{r};{g};{b}m"
RST = "\033[0m"

ART = [
    "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
    "⠀⠀⠀⠀⠀⠀⣰⣾⠁⠀⢦⣾⣤⠆⠀⠻⣧⠀⠀⠀⠀⠀⠀",
    "⠀⠀⠀⠀⢠⣼⠏⠀⠀⠀⠀⣿⡇⠀⠀⠀⠈⢷⣄⠀⠀⠀⠀",
    "⠀⠀⢀⣸⣿⠃⠀⠀⠀⠀⠀⣿⡇⠀⠀⠀⠀⠀⢿⣧⡀⠀⠀",
    "⠀⢰⣾⣿⡁⠀⠀⠀⠀⠀⠀⣿⡇⠀⠀⠀⠀⠀⢀⣿⣿⠖⠀",
    "⠀⠀⠈⠻⣿⣦⣄⠀⠀⠀⠀⣿⡇⠀⠀⠀⢀⣴⣿⠟⠁⠀⠀",
    "⠀⠀⠀⠀⠈⠻⢿⣷⣄⡀⠀⣿⡇⠀⣠⣾⣿⠟⠁⠀⠀⠀⠀",
    "⠀⠀⠀⠀⠀⠀⠀⠙⢿⣿⣦⣿⣧⣾⣿⠟⠁⠀⠀⠀⠀⠀⠀",
    "⠀⠀⠀⠀⠀⠀⠀⠀⠀⢙⣿⣿⣿⣿⡀⠀⠀⠀⠀⠀⠀⠀⠀",
    "⠀⠀⠀⠀⠀⠀⠀⢀⣴⣿⣿⣿⣿⣿⣿⣦⡀⠀⠀⠀⠀⠀⠀",
    "⠀⠀⠀⠀⠀⢀⣴⣿⣿⠟⠁⣻⣿⠈⠙⢿⣿⣦⡀⠀⠀⠀⠀",
    "⠀⠀⠀⢀⣴⣿⡿⠋⠀⠀⠀⣽⣿⠀⠀⠀⠙⢿⣿⣦⣄⠀⠀",
    "⠀⣠⣴⣿⡿⠋⠀⠀⠀⠀⠀⢼⣿⠀⠀⠀⠀⠀⠈⢻⣿⣷⣄",
    "⠈⠙⢿⣿⣦⣄⠀⠀⠀⠀⠀⢸⣿⠀⠀⠀⠀⠀⣠⣾⣿⠟⠁",
    "⠀⠀⠀⠙⢿⣿⣷⣄⠀⠀⠀⢸⣿⠀⠀⠀⣠⣾⣿⠟⠁⠀⠀",
    "⠀⠀⠀⠀⠀⠙⢻⣿⣷⡄⠀⢸⣿⠀⠀⣼⣿⣿⠃⠀⠀⠀⠀",
    "⠀⠀⠀⠀⠀⠀⠈⠻⢿⣿⣦⣸⣿⣠⣾⣿⠟⠁⠀⠀⠀⠀⠀",
    "⠀⠀⠀⠀⠀⠀⠀⠀⠈⠙⢿⣿⣿⣿⡿⠁⠀⠀⠀⠀⠀⠀⠀",
    "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⠿⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀",
]

# Color gradient: hilt (warm gold-red) → crossguard (bright crimson) → blade (deep blood)
TOTAL = len(ART)
def line_color(i):
    # 0–6  : hilt & crossguard  → warm red
    # 7–8  : junction            → brightest
    # 9–18 : blade               → deepening blood red
    if i <= 6:
        t = i / 6
        r = int(180 + 22 * t)   # 180 → 202
        g = int(40  - 10 * t)   # 40  → 30
        b = int(20  - 10 * t)   # 20  → 10
    elif i <= 8:
        r, g, b = 231, 76, 60   # bright crimson peak
    else:
        t = (i - 9) / (TOTAL - 9)
        r = int(200 - 60 * t)   # 200 → 140
        g = int(50  - 40 * t)   #  50 → 10
        b = int(35  - 25 * t)   #  35 → 10
    return fg(r, g, b)

# Vertical padding to center in a 30-line panel
PAD_TOP = 5
output = [""] * PAD_TOP

for i, line in enumerate(ART):
    color = line_color(i)
    row = []
    for ch in line:
        if ch == BLANK or ch == " ":
            row.append(ch)
        else:
            row.append(f"{color}{ch}{RST}")
    output.append("".join(row))

sys.stdout.write("\n".join(output) + "\n")
