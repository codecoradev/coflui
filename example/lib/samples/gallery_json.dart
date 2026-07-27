// JSON snippets for the Widget Gallery demos.
//
// Each entry mirrors the live native-widget demo with the equivalent dynamic-UI
// JSON. Tap "Copy JSON" in the Gallery → paste into Playground → render.
//
// Keep these in sync with the visual demos in widget_gallery_screen.dart.

const textJson = [
  {'id': 't', 'type': 'text', 'label': 'Body text (14px)'},
  {
    'id': 't2',
    'type': 'text',
    'value': 'Custom — bold 18px primary',
    'style': {'fontSize': 18, 'fontWeight': 'bold', 'color': '#596AA9'}
  },
];

const buttonJson = [
  {
    'id': 'row',
    'type': 'row',
    'style': {'gap': 12},
    'children': [
      {'id': 'b1', 'type': 'button', 'label': 'Primary',
        'props': {'icon': 'send', 'action': 'send'}},
      {'id': 'b2', 'type': 'button', 'label': 'Outline',
        'props': {'variant': 'outline', 'icon': 'download', 'action': 'dl'}},
      {'id': 'b3', 'type': 'button', 'label': 'Danger',
        'props': {'variant': 'danger', 'icon': 'delete', 'action': 'del'}},
      {'id': 'b4', 'type': 'button', 'label': 'Ghost',
        'props': {'variant': 'ghost', 'icon': 'info', 'action': 'info'}},
    ]
  },
  {
    'id': 'loading_row',
    'type': 'row',
    'style': {'gap': 12, 'paddingVertical': 8},
    'children': [
      {'id': 'lb1', 'type': 'button', 'label': 'Loading',
        'props': {'isLoading': true}},
    ]
  },
];

const textFieldJson = [
  {
    'id': 'form',
    'type': 'column',
    'style': {'gap': 8},
    'children': [
      {'id': 'name', 'type': 'textfield', 'label': 'Name',
        'props': {'hint': 'Enter your name'}},
      {'id': 'phone', 'type': 'textfield', 'label': 'Phone',
        'props': {'hint': 'Phone number', 'keyboard': 'phone'}},
      {'id': 'email', 'type': 'textfield', 'label': 'Email',
        'props': {'hint': 'you@example.com', 'keyboard': 'email'}},
    ]
  },
];

const dropdownJson = [
  {
    'id': 'd',
    'type': 'dropdown',
    'props': {
      'hint': 'Select a fruit',
      'options': [
        {'label': 'Apple', 'value': 'apple'},
        {'label': 'Banana', 'value': 'banana'},
        {'label': 'Cherry', 'value': 'cherry'},
      ]
    }
  },
];

const cardJson = [
  {
    'id': 'default',
    'type': 'card',
    'label': 'Default Card',
    'children': [
      {'id': 't', 'type': 'text',
        'value': 'Default — border + soft shadow.'}
    ]
  },
  {
    'id': 'borderless',
    'type': 'card',
    'label': 'Borderless Card',
    'props': {'borderless': true},
    'children': [
      {'id': 't2', 'type': 'text', 'value': 'borderless: true — flat.'}
    ]
  },
  {
    'id': 'gradient',
    'type': 'card',
    'props': {'gradient': 'accent'},
    'children': [
      {'id': 't3', 'type': 'text', 'value': 'gradient: "accent"',
        'style': {'color': '#FFFFFF', 'fontWeight': 'bold'}}
    ]
  },
];

const gridJson = [
  {
    'id': 'grid',
    'type': 'grid',
    'style': {'gap': 12},
    'props': {'mobileColumns': 1, 'tabletColumns': 2, 'desktopColumns': 3},
    'children': [
      {'id': 'c1', 'type': 'card', 'label': 'Stat 1',
        'children': [{'id': 'h1', 'type': 'heading', 'label': '1.2k'}]},
      {'id': 'c2', 'type': 'card', 'label': 'Stat 2',
        'children': [{'id': 'h2', 'type': 'heading', 'label': '89%'}]},
      {'id': 'c3', 'type': 'card', 'label': 'Stat 3',
        'children': [{'id': 'h3', 'type': 'heading', 'label': '+24'}]},
    ]
  },
];

const iconJson = [
  {
    'id': 'row',
    'type': 'row',
    'style': {'gap': 20},
    'children': [
      {'id': 'i1', 'type': 'icon', 'props': {'icon': 'home', 'size': 40}},
      {'id': 'i2', 'type': 'icon', 'props': {'source': 'assets/logo.svg', 'size': 40}},
      {'id': 'i3', 'type': 'icon', 'props': {
        'source': 'https://flutter.dev/assets/images/shared/brand/flutter/logo/logo-mono-61.png',
        'size': 40}},
      {'id': 'i4', 'type': 'icon', 'props': {
        'icon': 'star', 'size': 40, 'color': '#FEA72C'}},
    ]
  },
];

const gradientsJson = [
  {'id': 'b1', 'type': 'gradient_bar', 'props': {'gradient': 'accent', 'height': 8}},
  {'id': 'b2', 'type': 'gradient_bar', 'props': {'gradient': 'cool', 'height': 8}},
  {'id': 'b3', 'type': 'gradient_bar', 'props': {'gradient': 'warm', 'height': 8}},
  {
    'id': 'box',
    'type': 'card',
    'props': {'gradient': 'accent'},
    'children': [
      {'id': 't', 'type': 'text', 'value': 'Gradient box',
        'style': {'color': '#FFFFFF', 'fontWeight': 'bold'}}
    ]
  },
];

const listTileJson = [
  {'id': 'lt1', 'type': 'list_tile', 'props': {
    'title': 'Budi Santoso', 'subtitle': 'Senior Developer',
    'leading': 'person', 'trailing': 'chevron_right', 'action': 'open'}},
  {'id': 'lt2', 'type': 'list_tile', 'props': {
    'title': 'Siti Rahma', 'subtitle': 'Product Manager',
    'leading': 'person', 'trailing': 'chevron_right', 'action': 'open'}},
];

const detailRowJson = [
  {
    'id': 'card',
    'type': 'card',
    'children': [
      {'id': 'dr1', 'type': 'detail_row', 'props': {
        'icon': 'person', 'label': 'Name', 'value': 'Budi Santoso'}},
      {'id': 'dr2', 'type': 'detail_row', 'props': {
        'icon': 'email', 'label': 'Email', 'value': 'budi@example.com'}},
      {'id': 'dr3', 'type': 'detail_row', 'props': {
        'icon': 'check_circle', 'label': 'Status', 'value': 'Approved',
        'valueColor': '#8EC302', 'valueFontWeight': 'bold'}},
    ]
  },
];

const chipJson = [
  {
    'id': 'row',
    'type': 'row',
    'style': {'gap': 8},
    'children': [
      {'id': 'c1', 'type': 'chip', 'props': {'label': 'Approved', 'variant': 'success'}},
      {'id': 'c2', 'type': 'chip', 'props': {'label': 'Pending', 'variant': 'warning'}},
      {'id': 'c3', 'type': 'chip', 'props': {'label': 'Rejected', 'variant': 'danger'}},
      {'id': 'c4', 'type': 'chip', 'props': {'label': 'Info', 'variant': 'info'}},
      {'id': 'c5', 'type': 'chip', 'props': {'label': '3', 'variant': 'info', 'icon': 'attach_file'}},
    ]
  },
];

const dialogJson = [
  {
    'id': 'row',
    'type': 'row',
    'style': {'gap': 12},
    'children': [
      {'id': 'b1', 'type': 'button', 'label': 'Show Alert',
        'props': {'variant': 'outline', 'action': 'alert'}},
      {'id': 'b2', 'type': 'button', 'label': 'Show Confirm',
        'props': {'variant': 'outline', 'action': 'confirm'}},
    ]
  },
];
