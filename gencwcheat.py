from cwcheatio import CwCheatIO


file = CwCheatIO("ULUS-10391.TXT")
file.write(f"Gathering Node Indicators [1/2]")
file.write(
    "_L 0x20045CE4 0x0A248444\n"
)
file.write(
    "_L 0x20045CE8 0x00000000\n"
)

file.seek(0x08921110)
file.write(f"Gathering Node Indicators [2/2]")
with open("bin/GATHERING_NODES_US.bin", "rb") as bin:
    file.write(bin.read())

file.close()

file = CwCheatIO("ULJM-05500.TXT")

file.write(f"Gathering Node Indicators [1/2]")
file.write(
    "_L 0x20045C94 0x0A24790C\n"
)
file.write(
    "_L 0x20045C98 0x00000000\n"
)

file.seek(0x0891E430)
file.write(f"Gathering Node Indicators [2/2]")
with open("bin/GATHERING_NODES_JP.bin", "rb") as bin:
    file.write(bin.read())

file.close()