## 0.1.2

- Removed the screenshot regeneration notes from the README.
- Shortened the README text.

## 0.1.1

- Added a widget gallery screenshot to the pub.dev listing.
- Reworked the example app into a two-page showcase: a components gallery
  and a trading dashboard, plus an integration test that captures the
  screenshot on a simulator.

## 0.1.0

- Initial release.
- Extracted widgets: `NeuButton`, `NeuContainer`, `NeuTheme`,
  `AppFlatButton`, `GradientText`, `Indicator`, `DropdownMenuIcon` (with
  `DropdownItem`, `DropdownButtonStyle` and `DropdownStyle`),
  `AnimatedListItem`, `PercentSwitch`, `TimeRangeSwitch`, `PriceBadge` and
  `slideUpRoute`.
- Introduced `NeuTheme` with the source neumorphic shadow defaults.
- `PercentSwitch` and `TimeRangeSwitch` use `FittedBox` instead of
  `auto_size_text`.
- `NeuButton`'s outer radius now follows the resolved radius; the source
  widget pinned the outer radius to `4.0`.
- `NeuContainer` now paints its restored neumorphic shadows (previously
  commented out), themeable via `NeuTheme`.
- `PriceBadge` now follows `percentage` changes on rebuild instead of
  snapshotting the initial value.
