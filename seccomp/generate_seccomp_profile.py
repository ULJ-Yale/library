#!/usr/bin/env python
# encoding: utf-8

# SPDX-FileCopyrightText: 2025 QuNex development team <https://qunex.yale.edu/>
#
# SPDX-License-Identifier: GPL-3.0-or-later

"""
Generate Docker seccomp profile from strace log files.

This script reads strace log files and extracts all system calls used by the traced processes,
then generates a Docker seccomp JSON profile that allows only those system calls.
"""

import os
import re
import json
import argparse
import sys
from pathlib import Path
from typing import Set, Dict, Any


def parse_strace_log(log_file: str) -> Set[str]:
    """
    Parse an strace log file and extract all system calls.

    Args:
        log_file: Path to the strace log file

    Returns:
        Set of system call names found in the log
    """
    syscalls = set()

    # Regular expression patterns for different strace line formats
    # 1. Normal syscall: syscall_name(args) = return_value
    # 2. With PID: [pid XXX] syscall_name(args) = return_value
    # 3. Unfinished: [pid XXX] syscall_name(args <unfinished ...>
    # 4. Resumed: [pid XXX] <... syscall_name resumed> args) = return_value

    # Pattern for normal syscalls (with optional PID prefix)
    syscall_pattern = re.compile(
        r"^(?:\[pid\s+\d+\]\s+)?([a-zA-Z0-9_]+)\(.*?\)\s*=\s*.*$"
    )

    # Pattern for unfinished syscalls (with optional PID prefix)
    unfinished_pattern = re.compile(
        r"^(?:\[pid\s+\d+\]\s+)?([a-zA-Z0-9_]+)\(.*?<unfinished.*$"
    )

    # Pattern for resumed syscalls (with optional PID prefix)
    resumed_pattern = re.compile(
        r"^(?:\[pid\s+\d+\]\s+)?<\.\.\.\s+([a-zA-Z0-9_]+)\s+resumed>.*?\)\s*=\s*.*$"
    )

    try:
        with open(log_file, "r", encoding="utf-8", errors="ignore") as f:
            for line_num, line in enumerate(f, 1):
                line = line.strip()
                if not line:
                    continue

                # Skip lines that are not system calls (e.g., process info, signals, strace messages)
                if (
                    line.startswith("+++")
                    or line.startswith("---")
                    or line.startswith("strace:")
                    or line.startswith("Process ")
                    or line.startswith("attach")
                    or line.startswith("detach")
                    or "attached" in line
                    or "detached" in line
                ):
                    continue

                # Try to match resumed syscalls first
                resumed_match = resumed_pattern.match(line)
                if resumed_match:
                    syscall_name = resumed_match.group(1)
                    syscalls.add(syscall_name)
                    continue

                # Try to match unfinished syscalls
                unfinished_match = unfinished_pattern.match(line)
                if unfinished_match:
                    syscall_name = unfinished_match.group(1)
                    syscalls.add(syscall_name)
                    continue

                # Try to match regular completed syscalls
                match = syscall_pattern.match(line)
                if match:
                    syscall_name = match.group(1)
                    syscalls.add(syscall_name)

    except IOError as e:
        print(f"Error reading {log_file}: {e}", file=sys.stderr)
        return set()
    except Exception as e:
        print(f"Unexpected error parsing {log_file}: {e}", file=sys.stderr)
        return set()

    return syscalls


def get_default_seccomp_template() -> Dict[str, Any]:
    """
    Get the basic seccomp profile template with default action and architecture.

    Returns:
        Dictionary containing the base seccomp profile structure
    """
    return {
        "defaultAction": "SCMP_ACT_ERRNO",
        "archMap": [
            {
                "architecture": "SCMP_ARCH_X86_64",
                "subArchitectures": ["SCMP_ARCH_X86", "SCMP_ARCH_X32"],
            },
            {
                "architecture": "SCMP_ARCH_AARCH64",
                "subArchitectures": ["SCMP_ARCH_ARM"],
            },
            {
                "architecture": "SCMP_ARCH_MIPS64",
                "subArchitectures": ["SCMP_ARCH_MIPS", "SCMP_ARCH_MIPS64N32"],
            },
            {
                "architecture": "SCMP_ARCH_MIPS64N32",
                "subArchitectures": ["SCMP_ARCH_MIPS", "SCMP_ARCH_MIPS64"],
            },
            {
                "architecture": "SCMP_ARCH_MIPSEL64",
                "subArchitectures": ["SCMP_ARCH_MIPSEL", "SCMP_ARCH_MIPSEL64N32"],
            },
            {
                "architecture": "SCMP_ARCH_MIPSEL64N32",
                "subArchitectures": ["SCMP_ARCH_MIPSEL", "SCMP_ARCH_MIPSEL64"],
            },
            {"architecture": "SCMP_ARCH_S390X", "subArchitectures": ["SCMP_ARCH_S390"]},
        ],
        "syscalls": [],
    }


def get_essential_syscalls() -> Set[str]:
    """
    Get a set of essential system calls that are commonly needed for container operations.
    These syscalls are often required but might not appear in strace logs if not used
    during the specific traced execution.

    Returns:
        Set of essential system call names
    """
    return {
        # Capability management (crucial for container operations)
        "capget",
        "capset",
        # Process and signal management
        "fork",
        "vfork",
        "waitid",
        "exit",
        "exit_group",
        # File operations
        "faccessat",
        "fchmod",
        "fchown",
        "flock",
        "fdatasync",
        "fsync",
        "ftruncate",
        "mkdirat",
        "mknod",
        "nanosleep",
        # Memory and process control
        "mmap2",
        "mount",
        "umount2",
        "pivot_root",
        "unshare",
        # IPC operations
        "ipc",
        "mq_open",
        "mq_unlink",
        "semctl",
        "semget",
        "sem_init",
        "semop",
        "semtimedop",
        "shmat",
        "shmctl",
        "shmdt",
        "shmget",
        # Security and capabilities
        "seccomp",
        "setgid",
        "setgroups",
        "setpgid",
        "setsid",
        "setuid",
        # Process scheduling and priority
        "getpgid",
        "getpgrp",
        "getpriority",
        "getrlimit",
        "getsid",
        "sched_setaffinity",
        # File system operations
        "pwrite64",
        "readlinkat",
        "statx",
        "clock_nanosleep_time64",
        # Pipe and polling operations
        "pipe",
        "pselect6",
        "ppoll",
        "epoll_create",
        "epoll_ctl",
        "epoll_wait",
        "epoll_pwait",
        "select",
    }


def create_seccomp_profile(
    syscalls: Set[str], include_essential: bool = True
) -> Dict[str, Any]:
    """
    Create a seccomp profile allowing the specified system calls.

    Args:
        syscalls: Set of system call names to allow
        include_essential: Whether to include essential syscalls for container operations

    Returns:
        Dictionary containing the complete seccomp profile
    """
    profile = get_default_seccomp_template()

    # Combine discovered syscalls with essential ones if requested
    all_syscalls = set(syscalls)
    if include_essential:
        essential_syscalls = get_essential_syscalls()
        all_syscalls.update(essential_syscalls)

    # Create syscall entries
    if all_syscalls:
        profile["syscalls"].append(
            {"names": sorted(list(all_syscalls)), "action": "SCMP_ACT_ALLOW"}
        )

    return profile


def find_log_files(directory: str, pattern: str = "*.log") -> list:
    """
    Find all log files in the specified directory.

    Args:
        directory: Directory to search for log files
        pattern: File pattern to match (default: "*.log")

    Returns:
        List of log file paths
    """
    directory_path = Path(directory)
    if not directory_path.exists():
        print(f"Directory {directory} does not exist", file=sys.stderr)
        return []

    if not directory_path.is_dir():
        print(f"{directory} is not a directory", file=sys.stderr)
        return []

    log_files = list(directory_path.glob(pattern))
    return [str(f) for f in log_files]


def main():
    parser = argparse.ArgumentParser(
        description="Generate Docker seccomp profile from strace log files",
        epilog="""
Example usage:
  # Generate from all .log files in current directory
  python generate_seccomp_profile.py -d .

  # Generate from specific log files
  python generate_seccomp_profile.py -f file1.log file2.log

  # Generate with custom output file
  python generate_seccomp_profile.py -d . -o custom_seccomp.json
        """,
        formatter_class=argparse.RawDescriptionHelpFormatter,
    )

    group = parser.add_mutually_exclusive_group(required=True)
    group.add_argument(
        "-d", "--directory", help="Directory containing strace log files"
    )
    group.add_argument("-f", "--files", nargs="+", help="Specific log files to process")

    parser.add_argument(
        "-o",
        "--output",
        default="seccomp_profile.json",
        help="Output file for seccomp profile (default: seccomp_profile.json)",
    )
    parser.add_argument(
        "-p",
        "--pattern",
        default="*.log",
        help="File pattern to match when using --directory (default: *.log)",
    )
    parser.add_argument(
        "-v", "--verbose", action="store_true", help="Enable verbose output"
    )
    parser.add_argument(
        "--no-essential",
        action="store_true",
        help="Do not include essential syscalls for container operations",
    )

    args = parser.parse_args()

    # Get list of log files to process
    if args.directory:
        log_files = find_log_files(args.directory, args.pattern)
        if not log_files:
            print(
                f"No log files found in {args.directory} matching pattern {args.pattern}"
            )
            sys.exit(1)
    else:
        log_files = args.files
        # Verify all files exist
        for f in log_files:
            if not os.path.exists(f):
                print(f"File {f} does not exist", file=sys.stderr)
                sys.exit(1)

    if args.verbose:
        print(f"Processing {len(log_files)} log files:")
        for f in log_files:
            print(f"  - {f}")

    # Extract system calls from all log files
    all_syscalls = set()

    for log_file in log_files:
        if args.verbose:
            print(f"Parsing {log_file}...")

        syscalls = parse_strace_log(log_file)
        if args.verbose:
            print(f"  Found {len(syscalls)} unique syscalls")

        all_syscalls.update(syscalls)

    if args.verbose:
        print(f"\nTotal unique syscalls found: {len(all_syscalls)}")
        print("System calls from logs:")
        for syscall in sorted(all_syscalls):
            print(f"  - {syscall}")

    # Generate seccomp profile (include essential syscalls unless disabled)
    include_essential = not args.no_essential
    profile = create_seccomp_profile(all_syscalls, include_essential)

    if args.verbose and include_essential:
        essential_syscalls = get_essential_syscalls()
        combined_syscalls = set(all_syscalls) | essential_syscalls
        print(f"\nTotal syscalls after adding essential ones: {len(combined_syscalls)}")
        additional_syscalls = essential_syscalls - all_syscalls
        if additional_syscalls:
            print("Additional essential syscalls added:")
            for syscall in sorted(additional_syscalls):
                print(f"  - {syscall}")

    # Write to output file
    try:
        with open(args.output, "w") as f:
            json.dump(profile, f, indent=2)

        final_count = len(profile["syscalls"][0]["names"]) if profile["syscalls"] else 0
        print(f"\nSeccomp profile written to {args.output}")
        print(f"Profile allows {final_count} system calls")

    except IOError as e:
        print(f"Error writing to {args.output}: {e}", file=sys.stderr)
        sys.exit(1)


if __name__ == "__main__":
    main()
