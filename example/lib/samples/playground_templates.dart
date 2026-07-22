// Ready-made JSON snippets for the Playground screen.
//
// Each entry is a complete, valid JSON document (either a single component
// object or an array of components). The user can load any of these into the
// editor, tweak it, and re-render instantly.

/// A preset template shown in the Playground's template chooser.
class PlaygroundTemplate {
  final String name;
  final String description;
  final String json;

  const PlaygroundTemplate({
    required this.name,
    required this.description,
    required this.json,
  });
}

const playgroundTemplates = <PlaygroundTemplate>[
  PlaygroundTemplate(
    name: 'Kartu Sederhana',
    description: 'Satu card dengan heading + paragraf.',
    json: '''[
  {
    "id": "title",
    "type": "heading",
    "label": "Selamat Datang"
  },
  {
    "id": "card",
    "type": "card",
    "label": "Coflui Demo",
    "children": [
      {
        "id": "body",
        "type": "text",
        "label": "Tulisan ini dirender murni dari JSON. Ubah teks lalu tekan Render."
      }
    ]
  }
]''',
  ),
  PlaygroundTemplate(
    name: 'Form Mini',
    description: 'Textfield + tombol submit.',
    json: '''[
  {
    "id": "form_card",
    "type": "card",
    "label": "Pendaftaran",
    "children": [
      {
        "id": "name",
        "type": "textfield",
        "label": "Nama",
        "props": { "hint": "Nama lengkap" }
      },
      {
        "id": "email",
        "type": "textfield",
        "label": "Email",
        "props": { "hint": "nama@email.com", "keyboard": "email" }
      },
      {
        "id": "submit",
        "type": "button",
        "label": "Daftar",
        "props": { "variant": "primary", "action": "submit", "icon": "send", "widthInfinity": true }
      }
    ]
  }
]''',
  ),
  PlaygroundTemplate(
    name: 'Grid Kartu',
    description: 'Grid responsif berisi 3 kartu.',
    json: '''[
  {
    "id": "grid",
    "type": "grid",
    "style": { "gap": 12 },
    "props": { "mobileColumns": 1, "tabletColumns": 2, "desktopColumns": 3 },
    "children": [
      { "id": "c1", "type": "card", "label": "Stat 1", "children": [
        { "id": "t1", "type": "heading", "label": "1.2k" }
      ]},
      { "id": "c2", "type": "card", "label": "Stat 2", "children": [
        { "id": "t2", "type": "heading", "label": "89%" }
      ]},
      { "id": "c3", "type": "card", "label": "Stat 3", "children": [
        { "id": "t3", "type": "heading", "label": "+24" }
      ]}
    ]
  }
]''',
  ),
  PlaygroundTemplate(
    name: 'Baris Tombol',
    description: 'Row dengan tombol flex 1:2 (uji layout).',
    json: '''[
  {
    "id": "buttons",
    "type": "row",
    "style": { "gap": 12 },
    "children": [
      {
        "id": "cancel",
        "type": "button",
        "label": "Batal",
        "props": { "variant": "outline", "action": "cancel", "flex": 1 }
      },
      {
        "id": "save",
        "type": "button",
        "label": "Simpan Perubahan",
        "props": { "variant": "primary", "action": "submit", "icon": "check", "widthInfinity": true, "flex": 2 }
      }
    ]
  }
]''',
  ),
  PlaygroundTemplate(
    name: 'Halaman Detail',
    description: 'Halaman approval lengkap: gradient, chip, list, detail_row.',
    json: r'''[
  { "id": "accent", "type": "gradient_bar", "props": { "gradient": "accent", "height": 6 } },
  {
    "id": "header",
    "type": "row",
    "style": { "mainAxis": "spaceBetween", "crossAxis": "center" },
    "children": [
      { "id": "doc_no", "type": "heading", "label": "SPP-2026-0048", "style": { "fontSize": 20 } },
      { "id": "status", "type": "chip", "props": { "label": "Pending", "variant": "warning", "icon": "check_circle" } }
    ]
  },
  { "id": "subtitle", "type": "text", "label": "SPP • 2026-07-22 09:15", "style": { "fontSize": 12, "color": "#666666", "paddingVertical": 4 } },
  {
    "id": "detail_card",
    "type": "card",
    "style": { "padding": 16 },
    "children": [
      { "id": "dr1", "type": "detail_row", "props": { "icon": "domain", "label": "Company", "value": "PT Pura Barutama" } },
      { "id": "dr2", "type": "detail_row", "props": { "icon": "payments", "label": "Amount", "value": "Rp 42.500.000 (IDR)", "highlight": true } },
      { "id": "dr3", "type": "detail_row", "props": { "icon": "calendar_today", "label": "Date", "value": "2026-07-22" } }
    ]
  },
  { "id": "appr_title", "type": "heading", "label": "Approval Chain", "style": { "fontSize": 16, "paddingVertical": 8 } },
  {
    "id": "approvers",
    "type": "list",
    "props": {
      "items": [
        { "name": "Andi", "role": "Manager", "icon": "check_circle" },
        { "name": "Maya", "role": "Finance", "icon": "schedule" }
      ],
      "direction": "vertical", "spacing": 6
    },
    "children": [
      { "type": "list_tile", "props": { "title": "{name}", "subtitle": "{role}", "leading": "person", "trailing": "{icon}" } }
    ]
  },
  {
    "id": "actions",
    "type": "row",
    "style": { "gap": 12, "paddingVertical": 12 },
    "children": [
      { "id": "reject", "type": "button", "label": "Reject", "props": { "variant": "danger", "icon": "close", "action": "reject" } },
      { "id": "approve", "type": "button", "label": "Approve", "props": { "variant": "primary", "icon": "check", "action": "approve", "flex": 2 } }
    ]
  }
]''',
  ),
];
