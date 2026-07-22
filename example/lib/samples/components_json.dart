// JSON definitions showcasing the new dynamic-UI component types:
// icon, image, gradient_bar, list_tile, detail_row.
//
// Rendered by DynamicComponentsScreen via the dynamic engine — no hand-written
// widgets, just JSON + WidgetRegistry.

/// A document-style detail view built entirely from JSON.
///
/// Demonstrates the new media + content builders:
/// - `gradient_bar`  — brand accent strip
/// - `heading`       — title
/// - `detail_row`    — icon + label + value rows
/// - `icon`          — named Material icon + network image
/// - `list_tile`     — card-style rows with leading/trailing + tap action
const List<Map<String, dynamic>> componentsJson = [
  {
    "id": "accent",
    "type": "gradient_bar",
    "props": {"gradient": "accent", "height": 6},
  },
  {
    "id": "title",
    "type": "heading",
    "label": "Approval Request #APR-204",
    "style": {"paddingVertical": 8},
  },
  {
    "id": "subtitle",
    "type": "text",
    "label": "Submitted by Budi Santoso • 2 hours ago",
    "style": {"fontSize": 12, "color": "#666666"},
  },
  {
    "id": "detail_card",
    "type": "card",
    "style": {"padding": 16},
    "children": [
      {"id": "dr1", "type": "detail_row", "props": {
        "icon": "person", "label": "Requester", "value": "Budi Santoso"}},
      {"id": "dr2", "type": "detail_row", "props": {
        "icon": "calendar_today", "label": "Date", "value": "2026-07-22"}},
      {"id": "dr3", "type": "detail_row", "props": {
        "icon": "attach_money", "label": "Amount", "value": "Rp 4,500,000",
        "highlight": true}},
      {"id": "dr4", "type": "detail_row", "props": {
        "icon": "description", "label": "Purpose",
        "value": "Office supplies Q3 procurement"}},
    ],
  },
  {
    "id": "approver_header",
    "type": "heading",
    "label": "Approvers",
    "style": {"fontSize": 18, "paddingVertical": 8},
  },
  {
    "id": "tile1",
    "type": "list_tile",
    "props": {
      "title": "Andi Wijaya",
      "subtitle": "Line Manager",
      "leading": "person",
      "trailing": "check_circle",
      "action": "approve_1",
    },
  },
  {
    "id": "tile2",
    "type": "list_tile",
    "props": {
      "title": "Maya Putri",
      "subtitle": "Finance Lead",
      "leading": "person",
      "trailing": "pending",
      "action": "approve_2",
    },
  },
  {
    "id": "tile3",
    "type": "list_tile",
    "props": {
      "title": "Rian Dewa",
      "subtitle": "Director",
      "leading": "person",
      "trailing": "schedule",
      "action": "approve_3",
    },
  },
  {
    "id": "icon_row",
    "type": "row",
    "style": {"mainAxis": "spaceEvenly", "paddingVertical": 12},
    "children": [
      {"id": "ic1", "type": "icon", "props": {
        "icon": "home", "size": 32, "color": "#088ECE"}},
      {"id": "ic2", "type": "icon", "props": {
        "icon": "verified", "size": 32, "color": "#8EC302"}},
      {"id": "ic3", "type": "icon", "props": {
        "icon": "notifications", "size": 32, "color": "#FEA72C"}},
      {"id": "ic4", "type": "icon", "props": {
        "icon": "shield", "size": 32, "color": "#6A35AE"}},
    ],
  },
  {
    "id": "network_image",
    "type": "image",
    "props": {
      "src": "https://flutter.dev/assets/images/shared/brand/flutter/logo/logo-mono-61.png",
      "size": 64,
      "fit": "contain",
    },
  },
  {
    "id": "actions",
    "type": "row",
    "style": {"gap": 12, "paddingVertical": 8},
    "children": [
      {"id": "reject_btn", "type": "button", "label": "Reject", "props": {
        "variant": "danger", "icon": "close", "action": "reject"}},
      {"id": "approve_btn", "type": "button", "label": "Approve", "props": {
        "variant": "primary", "icon": "check", "action": "approve",
        "flex": 2}},
    ],
  },
];
