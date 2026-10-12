#!/usr/bin/env python3

# ruff: noqa: S603,S607
import os
import shutil
import subprocess
import sys
import time
from collections.abc import Sequence
from dataclasses import dataclass
from pathlib import Path

curr_history_filename = ".zsh_history"

HOME = Path.home()
BKP_ZSH_HISTORY_DIR = HOME / ".zsh_history_bkp"
CURR_ZSH_HISTORY = HOME / curr_history_filename


@dataclass(slots=True, frozen=True, kw_only=True)
class ZshHistoryEntry:
    timestamp: bytes
    duration: bytes
    command: bytes
    raw: bytes


def history_to_entries(raw_bytes: bytes) -> set[ZshHistoryEntry]:
    entries: set[ZshHistoryEntry] = set()
    line_start = b": "

    history_entry = b""
    for line in raw_bytes.splitlines(keepends=True):
        if line.startswith(line_start):
            if history_entry:
                entry = parse_entry(history_entry)
                if entry is not None:
                    entries.add(entry)

            history_entry = line
        else:
            history_entry += line

    if history_entry:
        entry = parse_entry(history_entry)
        if entry is not None:
            entries.add(entry)

    return entries


def parse_entry(entry: bytes) -> ZshHistoryEntry | None:
    """Parse de uma entrada ': <timestamp>:<duração>;<comando>'.

    Retorna None para entradas malformadas (ex.: linhas soltas no topo do arquivo).
    """
    line_start = b": "
    cmd_splitter = b";"
    meta_splitter = b":"
    empty_byte = b""

    try:
        meta, command = (
            entry.strip().replace(line_start, empty_byte, 1).split(cmd_splitter, 1)
        )
        timestamp, duration = meta.split(meta_splitter)
        int(timestamp)
    except ValueError:
        return None

    # Garante a quebra de linha final, senão a próxima entrada gruda nesta
    raw = entry if entry.endswith(b"\n") else entry + b"\n"

    return ZshHistoryEntry(
        timestamp=timestamp, duration=duration, command=command, raw=raw
    )


def merge_history(
    curr_history_path: Path, merge_history_bytes: bytes
) -> Sequence[ZshHistoryEntry]:
    curr_history_entries = history_to_entries(curr_history_path.read_bytes())
    merge_history_entries = history_to_entries(merge_history_bytes)
    all_entries = curr_history_entries.union(merge_history_entries)

    return sorted(all_entries, key=lambda e: int(e.timestamp))


def fetch_remote_history(sync_host: str) -> bytes | None:
    out = subprocess.run(
        ["ssh", sync_host, f"cat ~/{curr_history_filename}"],
        check=False,
        capture_output=True,
    )
    if out.returncode != 0:
        print(f"Falha ao buscar histórico de {sync_host}:", out.stderr.decode().strip())
        return None
    if not out.stdout.strip():
        print(f"Histórico remoto de {sync_host} vazio, nada a fazer.")
        return None
    return out.stdout


def merge_and_overwrite_histories(curr_history_path: Path) -> None:
    sync_host = os.environ.get("DOTFILES_HISTORY_SYNC_HOST", "")
    if not sync_host:
        print("DOTFILES_HISTORY_SYNC_HOST não definido, pulando sync remoto.")
        return

    # O histórico local já foi gravado com 'fc -W' pela função zsh que chama este script
    merge_history_bytes = fetch_remote_history(sync_host)
    if merge_history_bytes is None:
        return

    merged_history_entries = merge_history(curr_history_path, merge_history_bytes)

    BKP_ZSH_HISTORY_DIR.mkdir(exist_ok=True)
    shutil.copy2(
        curr_history_path,
        BKP_ZSH_HISTORY_DIR / f".zsh_history_BKP_{int(time.time())}",
    )

    with curr_history_path.open("wb") as curr_file_obj:
        for entry in merged_history_entries:
            curr_file_obj.write(entry.raw)


if __name__ == "__main__":
    print()
    print("ZSH History Sync starting...")
    print("Python version:", sys.version)

    merge_and_overwrite_histories(CURR_ZSH_HISTORY)

    print()
    print("ZSH History Sync...")
    print("Sync done!")
    print()
