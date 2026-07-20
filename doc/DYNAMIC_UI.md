# Dynamic UI — JSON Schema

Every screen is a JSON array (or single object) of **components**. Containers
nest children → unlimited depth.

## Base node

```json
{
  "id": "unique_key",
  "type": "text",
  "label": "Optional label",
  "value": "initial/display value",
  "props": {},
  "style": {},
  "children": []
}
```

| Field       | Purpose                                                            |
|-------------|-------------------------------------------------------------------|
| `id`        | Unique key; used as the controller value key. Auto-generated if omitted. |
| `type`      | One of the [Component types](#component-types) below.             |
| `label`     | Display label (heading text, card title, field label, button text). |
| `value`     | Initial value (string/int/double/bool/list/map).                  |
| `props`     | Type-specific config.                                              |
| `style`     | See [Style](#style).                                               |
| `children`  | For containers only — array of nodes.                             |

## Component types

### Containers (have `children`)

| type      | props                                                                 | notes |
|-----------|-----------------------------------------------------------------------|-------|
| `column`  | `mainAxisSize: "max"\|min`                                           | vertical stack; cross-axis defaults to `stretch` |
| `row`     | —                                                                     | children auto-wrapped in `Flexible`/`Expanded` (use `props.flex` on a child for `Expanded`) |
| `grid`    | `mobileColumns`, `tabletColumns`, `desktopColumns`, `spacing`, `runSpacing` | responsive; column count derived from breakpoint |
| `card`    | —                                                                     | styled surface; `label` becomes the card title |
| `section` | —                                                                     | alias of `card` for form grouping |

### Display

| type      | notes |
|-----------|-------|
| `text`    | body text; uses `value` else `label` |
| `heading` | larger bold text |
| `divider` | horizontal rule; `style.gap` = height |

### Inputs

| type         | props | value |
|--------------|-------|-------|
| `textfield`  | `hint`, `keyboard` (`number\|phone\|email\|url\|multiline`), `maxLines`, `multiline`, `maxLength`, `enabled`, `required` | string |
| `dropdown`   | `hint`, `options: [{label, value}]`, `enabled` | selected option `value` |
| `switch`     | — | bool |
| `checkbox`   | — | bool |
| `datepicker` | `hint` | `yyyy-MM-dd` string |

### Action

| type     | props | notes |
|----------|-------|-------|
| `button` | `variant` (`primary\|outline\|danger\|ghost`), `action`, `widthInfinity`, `icon` | `action` is passed to `controller.onAction` |

## Style

All dimensions are **raw logical pixels** (no scaling). Colors accept `#RGB`,
`#RRGGBB`, or `#AARRGGBB`.

```json
{
  "padding": 16,
  "paddingVertical": 8,
  "paddingHorizontal": 12,
  "gap": 12,
  "fontSize": 14,
  "fontWeight": "bold",
  "color": "#1A1A1A",
  "bgColor": "#FFFFFF",
  "borderColor": "#CCCCCC",
  "borderWidth": 1,
  "radius": 12,
  "align": "center",
  "crossAxis": "center",
  "mainAxis": "start",
  "elevation": 2,
  "expand": true,
  "maxLines": 2
}
```

| Field group   | Keys |
|---------------|------|
| spacing       | `padding`, `paddingVertical` (`py`), `paddingHorizontal` (`px`), `gap` |
| text          | `fontSize`, `fontWeight` (`bold\|w500\|700…`), `fontStyle` (`italic`), `color`, `align`, `maxLines` |
| box           | `bgColor` (`backgroundColor`), `borderColor`, `borderWidth`, `radius`, `elevation` |
| layout        | `crossAxis` (`start\|center\|end\|stretch`), `mainAxis` (`start\|center\|end\|spaceBetween\|spaceEvenly`), `expand`, `widthFactor` |

`align` accepts `left|start|right|end|center|justify`.

## Responsive grid example

```json
{
  "id": "stats",
  "type": "grid",
  "props": { "mobileColumns": 1, "tabletColumns": 2, "desktopColumns": 4, "spacing": 12 },
  "children": [
    { "id": "s1", "type": "card", "label": "Total", "children": [
      { "id": "s1v", "type": "text", "value": "12", "style": { "fontSize": 28, "fontWeight": "bold" } }
    ]}
  ]
}
```

## Reading values

```dart
final controller = CofluiFormController()..loadFromJson(json);
controller.getValue('name');               // last value for id
controller.snapshot();                      // {id: value, ...}
controller.fieldListenable('name');         // granular ValueListenable
```
