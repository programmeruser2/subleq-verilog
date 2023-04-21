X = 0x9
TMP = 0xA
CONSOLE_ADDR = 0xFF

program = [
    (X, TMP, 3),
    (TMP, CONSOLE_ADDR, 6),
    (TMP, TMP, 6),
    (ord('X'), 0)
]
