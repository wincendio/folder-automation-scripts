#!/usr/bin/env python3
"""
batch_rename_mkv.py
Batch rename .mkv files in the current directory.

Default behavior: strips common release-group tags and replaces dots/underscores
in the base filename with spaces, then applies a clean "Title (Year).mkv" style.

Usage:
    cd /your/video/folder
    python3 /path/to/batch_rename_mkv.py
    python3 /path/to/batch_rename_mkv.py --dry-run   # preview only
"""

import os
import re
import argparse
from pathlib import Path


def clean_name(filename: str) -> str:
    stem = Path(filename).stem
    # Remove common release tags like [BluRay], (1080p), [x265], etc.
    stem = re.sub(r'[\[\(][^\]\)]*[\]\)]', '', stem)
    # Replace dots and underscores with spaces
    stem = re.sub(r'[._]+', ' ', stem)
    # Collapse multiple spaces
    stem = re.sub(r' +', ' ', stem).strip()
    return stem + '.mkv'


def main():
    parser = argparse.ArgumentParser(description='Batch rename .mkv files in CWD')
    parser.add_argument('--dry-run', action='store_true', help='Preview renames without applying')
    args = parser.parse_args()

    cwd = Path.cwd()
    files = sorted(cwd.glob('*.mkv'))

    if not files:
        print(f'No .mkv files found in {cwd}')
        return

    print(f'Found {len(files)} .mkv file(s) in {cwd}\n')
    renamed = 0

    for f in files:
        new_name = clean_name(f.name)
        if new_name == f.name:
            print(f'  [skip]    {f.name}')
            continue
        print(f'  [rename]  {f.name}')
        print(f'        ->  {new_name}')
        if not args.dry_run:
            f.rename(cwd / new_name)
            renamed += 1

    if args.dry_run:
        print('\n[dry-run] No files were renamed.')
    else:
        print(f'\nDone. Renamed {renamed} file(s).')


if __name__ == '__main__':
    main()
