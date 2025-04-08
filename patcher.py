import os

BASE_RAM = 0x8800000
EBOOT_BASE = 0x8801A4C

def patch_binary(base_path, address, input_path=None, input_bytes=None, output_path='patched.bin'):
    if input_bytes is None and input_path is None:
        raise ValueError("you should provide input_path or input_bytes.")

    with open(base_path, 'rb') as f:
        base_data = bytearray(f.read())

    if input_bytes is not None:
        patch_data = input_bytes
    else:
        with open(input_path, 'rb') as f:
            patch_data = f.read()

    if address + len(patch_data) > len(base_data):
        raise ValueError("Input does not fit!")

    base_data[address:address+len(patch_data)] = patch_data

    with open(output_path, 'wb') as f:
        f.write(base_data)


def patch(eboot_file):
    patch_binary(eboot_file, 0x0891E430 - EBOOT_BASE, input_path="bin/GATHERING_NODES_JP.bin", input_bytes=None, output_path='temp.bin')
    patch_binary("temp.bin", 0x00045C94 + BASE_RAM - EBOOT_BASE, input_bytes=b'\x0C\x79\x24\x0A', output_path=f'temp.bin')
    patch_binary("temp.bin", 0x00045C98 + BASE_RAM - EBOOT_BASE, input_bytes=b'\x00\x00\x00\x00', output_path=f"patched_{eboot_file}")
    os.remove("temp.bin")

if __name__ == "__main__":
    eboot_file = ""
    for filename in os.listdir():
        if filename.lower().endswith('.bin'):
            eboot_file  = filename
    print(f"Patching {eboot_file}...")
    try:
        patch(eboot_file)
        print(f"Done")
    except Exception as e:
        print(f"Error while patching: {e}")

    