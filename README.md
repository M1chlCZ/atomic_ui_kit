# atomic_ui_kit

A small kit of domain-free Flutter widgets: neumorphic buttons and
containers, gradient text, a dropdown menu icon, percent and time range
switches, price badges, and more. The widgets depend only on Flutter and
`decimal`; they know nothing about app models, state management or platform
plugins.

## Widgets

| Widget | Description |
| --- | --- |
| `NeuButton` | Neumorphic button with an ink splash and optional gradient. |
| `NeuContainer` | Neumorphic container that paints the neu shadows. |
| `NeuTheme` | `ThemeExtension` with the shared neu shadows, background color and radius. |
| `AppFlatButton` | Flat, optionally bordered button with an ink splash. |
| `GradientText` | Text painted with a `Gradient` through a `ShaderMask`. |
| `Indicator` | Colored shape followed by a bold label. |
| `DropdownMenuIcon` | Button that opens an overlay menu and reports the selected item. |
| `AnimatedListItem` | List item that scales and tilts into place when it is first built. |
| `PercentSwitch` | Row of 25 %, 50 %, 75 % and MAX options. |
| `TimeRangeSwitch` | Row of 1Y, 1M, 1W and 1D options. |
| `PriceBadge` | Price change badge, green when positive and red otherwise. |
| `slideUpRoute` | `Route` that slides a page up from the bottom of the screen. |

## Install

`atomic_ui_kit` is not published on pub.dev yet. Depend on it with a path:

```yaml
dependencies:
  atomic_ui_kit:
    path: packages/atomic_ui_kit
```

## Usage

### NeuButton and NeuTheme

Register `NeuTheme` on the ambient `ThemeData` to restyle every neu widget in
the subtree, then use `NeuButton`:

```dart
MaterialApp(
  theme: ThemeData(
    extensions: const [
      NeuTheme(
        keyBackgroundColor: Color(0xFF252F45),
        borderRadius: 12,
      ),
    ],
  ),
  home: Center(
    child: NeuButton(
      height: 56,
      width: 200,
      onTap: () {},
      child: const Text('Buy'),
    ),
  ),
);
```

### PercentSwitch

```dart
PercentSwitch(
  onChanged: (percent) {
    // `percent` is 0.25, 0.5, 0.75 or 1.0.
  },
);
```

### TimeRangeSwitch

```dart
TimeRangeSwitch(
  onChanged: (range) {
    // `range` is one of TimeRangeSwitchValue.day, .week, .month or .year.
  },
);
```

### DropdownMenuIcon

```dart
DropdownMenuIcon<String>(
  currentIndex: 0,
  items: const [
    DropdownItem<String>(value: 'one', child: Text('One')),
    DropdownItem<String>(value: 'two', child: Text('Two')),
  ],
  onChange: (value, index) {
    // `value` is the selected DropdownItem value.
  },
  child: const Text('Choose'),
);
```

## Platforms

`atomic_ui_kit` is pure Flutter with no native code or platform plugins, so it
runs on Android, iOS, web, macOS, Windows and Linux.
