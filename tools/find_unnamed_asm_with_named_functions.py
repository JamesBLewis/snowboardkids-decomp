#!/usr/bin/env python3
import argparse
import re
import sys
from pathlib import Path


UNNAMED_ASM_SEGMENT_RE = re.compile(
    r"^\s*-\s*\[\s*(0x[0-9A-Fa-f]+)\s*,\s*asm\s*\]\s*$"
)
GLABEL_RE = re.compile(r"^glabel\s+([A-Za-z_][A-Za-z0-9_]*)\b")
DEFAULT_UNNAMED_FUNC_RE = re.compile(r"^func_[0-9A-Fa-f]+(?:_[0-9A-Fa-f]+)?$")


def iter_unnamed_asm_segments(yaml_path):
    with yaml_path.open() as f:
        for line_number, line in enumerate(f, start=1):
            match = UNNAMED_ASM_SEGMENT_RE.match(line)
            if match:
                yield line_number, int(match.group(1), 16)


def read_function_labels(asm_path):
    labels = []

    with asm_path.open() as f:
        for line in f:
            match = GLABEL_RE.match(line)
            if match:
                labels.append(match.group(1))

    return labels


def format_functions(functions, max_functions):
    if max_functions is not None and len(functions) > max_functions:
        shown = ", ".join(functions[:max_functions])
        return f"{shown}, ... ({len(functions) - max_functions} more)"

    return ", ".join(functions)


def main():
    parser = argparse.ArgumentParser(
        description=(
            "Find unnamed asm subsegments in snowboardkids.yaml whose extracted "
            "asm files contain function labels that are not generic func_<addr> names."
        )
    )
    parser.add_argument(
        "yaml",
        nargs="?",
        default="snowboardkids.yaml",
        type=Path,
        help="Splat YAML file to scan (default: snowboardkids.yaml)",
    )
    parser.add_argument(
        "--asm-dir",
        default=Path("asm"),
        type=Path,
        help="Directory containing extracted asm files (default: asm)",
    )
    parser.add_argument(
        "--max-functions",
        default=None,
        type=int,
        help="Maximum number of named functions to print per segment",
    )
    parser.add_argument(
        "--show-missing",
        action="store_true",
        help="Also report unnamed asm entries whose asm file is missing",
    )
    args = parser.parse_args()

    if not args.yaml.is_file():
        print(f"error: {args.yaml} does not exist", file=sys.stderr)
        return 1

    found_count = 0
    missing_count = 0

    for line_number, offset in iter_unnamed_asm_segments(args.yaml):
        asm_path = args.asm_dir / f"{offset:X}.s"

        if not asm_path.is_file():
            missing_count += 1
            if args.show_missing:
                print(f"{args.yaml}:{line_number}: 0x{offset:X}: missing {asm_path}")
            continue

        functions = read_function_labels(asm_path)
        named_functions = [
            function
            for function in functions
            if not DEFAULT_UNNAMED_FUNC_RE.match(function)
        ]

        if named_functions:
            found_count += 1
            formatted_functions = format_functions(
                named_functions, args.max_functions
            )
            print(
                f"{args.yaml}:{line_number}: 0x{offset:X} ({asm_path}): "
                f"{formatted_functions}"
            )

    if found_count == 0:
        print("No unnamed asm entries with named function labels found.")

    if args.show_missing and missing_count:
        print(f"{missing_count} unnamed asm entries have no matching asm file.")

    return 0


if __name__ == "__main__":
    sys.exit(main())
