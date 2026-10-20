## [0.2.0] - 2026-10-20

- Added `AtomicTheme`, a `ThemeExtension` with the shared base color, light
  and dark shadow colors, depth and radius, plus `AtomicTheme.of(context)`.
- Added the `NeumorphicCard` and `NeumorphicProgress` components.
- `NeuButton`, `NeuContainer`, `NeumorphicCard` and `NeumorphicProgress`
  resolve each value from the explicit argument, then `NeuTheme`, then
  `AtomicTheme`, then the built-in defaults.
- `depth` is the shadow offset and the blur radius is `depth * 4`, so the
  default depth of `1` reproduces the previous shadows.

## 0.1.4

- Documentation and internal cleanup.

## 0.1.3

- Rewrite the README for a shorter pub.dev listing.

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
