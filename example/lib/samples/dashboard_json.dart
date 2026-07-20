// JSON definitions for the dynamic dashboard example screen.

/// A responsive analytics dashboard rendered entirely from JSON.
///
/// Demonstrates: heading, responsive grid (mobile=1 / tablet=2 / desktop=4),
/// cards with stat tiles, and a two-column row.
const List<Map<String, dynamic>> dashboardJson = [
  {
    "id": "header",
    "type": "row",
    "style": {"crossAxis": "center", "mainAxis": "spaceBetween"},
    "children": [
      {
        "id": "title",
        "type": "heading",
        "label": "Dashboard",
      },
      {
        "id": "subtitle",
        "type": "text",
        "label": "Q1 2026",
        "style": {"fontSize": 13, "color": "#666666"},
      },
    ],
  },
  {
    "id": "stats",
    "type": "grid",
    "props": {
      "mobileColumns": 1,
      "tabletColumns": 2,
      "desktopColumns": 4,
      "spacing": 12,
    },
    "children": [
      {
        "id": "stat1",
        "type": "card",
        "children": [
          {"id": "s1label", "type": "text", "label": "Total Revenue",
            "style": {"fontSize": 12, "color": "#666666"}},
          {"id": "s1value", "type": "heading", "label": "Rp 2.4M",
            "style": {"fontSize": 26}},
          {"id": "s1delta", "type": "text", "label": "↑ 12% vs last month",
            "style": {"fontSize": 11, "color": "#8EC302"}},
        ],
      },
      {
        "id": "stat2",
        "type": "card",
        "children": [
          {"id": "s2label", "type": "text", "label": "Active Users",
            "style": {"fontSize": 12, "color": "#666666"}},
          {"id": "s2value", "type": "heading", "label": "1,847",
            "style": {"fontSize": 26}},
          {"id": "s2delta", "type": "text", "label": "↑ 8% vs last month",
            "style": {"fontSize": 11, "color": "#8EC302"}},
        ],
      },
      {
        "id": "stat3",
        "type": "card",
        "children": [
          {"id": "s3label", "type": "text", "label": "Conversion",
            "style": {"fontSize": 12, "color": "#666666"}},
          {"id": "s3value", "type": "heading", "label": "3.6%",
            "style": {"fontSize": 26}},
          {"id": "s3delta", "type": "text", "label": "↓ 0.4% vs last month",
            "style": {"fontSize": 11, "color": "#C0392B"}},
        ],
      },
      {
        "id": "stat4",
        "type": "card",
        "children": [
          {"id": "s4label", "type": "text", "label": "Avg. Order",
            "style": {"fontSize": 12, "color": "#666666"}},
          {"id": "s4value", "type": "heading", "label": "Rp 320K",
            "style": {"fontSize": 26}},
          {"id": "s4delta", "type": "text", "label": "↑ 5% vs last month",
            "style": {"fontSize": 11, "color": "#8EC302"}},
        ],
      },
    ],
  },
  {
    "id": "divider1",
    "type": "divider",
    "style": {"gap": 24},
  },
  {
    "id": "content_row",
    "type": "grid",
    "props": {
      "mobileColumns": 1,
      "tabletColumns": 2,
      "desktopColumns": 2,
      "spacing": 12,
    },
    "children": [
      {
        "id": "recent_orders",
        "type": "card",
        "label": "Recent Orders",
        "children": [
          {"id": "o1", "type": "text", "label": "#ORD-001  •  Rp 450K  •  Paid",
            "style": {"fontSize": 13, "paddingVertical": 4}},
          {"id": "o2", "type": "text", "label": "#ORD-002  •  Rp 120K  •  Pending",
            "style": {"fontSize": 13, "paddingVertical": 4}},
          {"id": "o3", "type": "text", "label": "#ORD-003  •  Rp 890K  •  Paid",
            "style": {"fontSize": 13, "paddingVertical": 4}},
          {"id": "o4", "type": "text", "label": "#ORD-004  •  Rp 67K  •  Refunded",
            "style": {"fontSize": 13, "paddingVertical": 4}},
        ],
      },
      {
        "id": "top_products",
        "type": "card",
        "label": "Top Products",
        "children": [
          {"id": "p1", "type": "text", "label": "1. Premium Plan  —  423 sold",
            "style": {"fontSize": 13, "paddingVertical": 4}},
          {"id": "p2", "type": "text", "label": "2. Pro Add-on  —  318 sold",
            "style": {"fontSize": 13, "paddingVertical": 4}},
          {"id": "p3", "type": "text", "label": "3. Starter Kit  —  207 sold",
            "style": {"fontSize": 13, "paddingVertical": 4}},
          {"id": "p4", "type": "text", "label": "4. Mobile License  —  156 sold",
            "style": {"fontSize": 13, "paddingVertical": 4}},
        ],
      },
    ],
  },
];
