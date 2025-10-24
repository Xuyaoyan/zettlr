# WARP.md

This file provides guidance to WARP (warp.dev) when working with code in this repository.

## Project Overview

Zettlr is a Python 3.14 free-threaded project currently in early development. The codebase uses modern Python tooling with uv/pyproject.toml for dependency management.

## Development Commands

### Running the Application
```pwsh
python main.py
```

### Python Environment
- Python version: 3.14t free-threaded (specified in `.python-version`)
- Dependencies managed via `pyproject.toml`
- Virtual environment in `.venv/` (gitignored)

### Setting up Development Environment
```pwsh
# Create virtual environment
python -m venv .venv

# Activate virtual environment (Windows PowerShell)
.\.venv\Scripts\Activate.ps1

# Install dependencies (once project.dependencies is populated)
pip install -e .
```

## Code Architecture

Currently minimal structure:
- `main.py` - Entry point with basic main() function
- `pyproject.toml` - Project configuration and dependencies
- No subdirectories or modules yet

## Development Notes

- Project requires Python >=3.14
- Uses free-threaded Python build (3.14t) for improved concurrency
- No test framework configured yet
- No linting/formatting tools configured yet
- No CI/CD configured yet
