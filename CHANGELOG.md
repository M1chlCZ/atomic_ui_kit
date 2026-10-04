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
