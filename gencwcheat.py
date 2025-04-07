from cwcheatio import CwCheatIO

file = CwCheatIO("ULJM-05500.TXT")

file.write(f"Gathering Node Indicators [1/2]")
# file.write(
#     "_L 0x20027628 0x0A24790C\n"
# )
file.write(
    "_L 0x200273BC 0x0A24790C\n"
)

# file.write(
#     "_L 0x200273BC 0x10000090\n"
# )
# file.write(
#     "_L 0x20027508 0x100000C2\n"
# )



# _L 0x088273BC 0x10000090

file.seek(0x0891E430)
file.write(f"Gathering Node Indicators [2/2]")
with open("bin/GATHERING_NODES_JP.bin", "rb") as bin:
    file.write(bin.read())

file.close()