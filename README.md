# PuttingGameCore

This package provides core models and progression managers for the Putting XP concept. It contains:

- Data models for shots, sessions and profiles.
- `XPManager` to calculate XP based on made putts.
- `LevelManager` with a simple XP table.
- `BadgeManager` that detects a few sample badges.

The package builds on Swift 6.1 and includes unit tests validating XP totals, level calculation and badge unlocking.

## Running Tests

```
swift test
```

