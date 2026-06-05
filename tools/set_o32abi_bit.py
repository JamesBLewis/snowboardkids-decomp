#!/usr/bin/env python3
import argparse
import struct
import sys


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("file", help="ELF object to update")
    args = parser.parse_args()

    with open(args.file, "r+b") as f:
        magic = struct.unpack(">I", f.read(4))[0]
        if magic != 0x7F454C46:
            print("Error: Not an ELF file")
            return 1

        f.seek(36)
        flags = struct.unpack(">I", f.read(4))[0]
        flags |= 0x00001000
        f.seek(36)
        f.write(struct.pack(">I", flags))

    return 0


if __name__ == "__main__":
    sys.exit(main())
