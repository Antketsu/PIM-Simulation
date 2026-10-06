"""Helpers for reading numeric gem5 configuration parameters from the host environment."""

import os


def int_env(name: str, *, minimum: int | None = None) -> int:
    """Read a required integer parameter and validate its optional lower bound."""
    raw_value = os.environ.get(name)
    if raw_value is None:
        raise ValueError(f"Required environment variable {name} is not set")
    try:
        value = int(raw_value)
    except ValueError as exc:
        raise ValueError(f"Environment variable {name} must be an integer, got {raw_value!r}") from exc
    if minimum is not None and value < minimum:
        raise ValueError(f"Environment variable {name} must be at least {minimum}, got {value}")
    return value
