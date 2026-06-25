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
];
