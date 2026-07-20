// Reference content for the in-app documentation screen.
//
// Each [DocSection] becomes a collapsible card in the Reference screen. Code
// blocks render in a monospace surface with a copy button. This mirrors the
// markdown in doc/DYNAMIC_UI.md so the app is self-contained — a user can
// learn the full schema without leaving the demo.

class DocSection {
  final String title;
  final String summary;
  final List<DocBlock> blocks;

  const DocSection({
    required this.title,
    required this.summary,
    required this.blocks,
  });
}

/// A block of content inside a section. Either annotated prose or a
/// copyable code snippet.
class DocBlock {
  final String? text;
  final String? code;
  final String? language;

  const DocBlock.text(this.text)
      : code = null,
        language = null;

  const DocBlock.code(this.code, {this.language = 'json'})
      : text = null;
}

const quickStart = DocSection(
  title: 'Quick Start',
  summary: 'Render UI dari JSON dalam 3 langkah.',
  blocks: [
    DocBlock.text(
        'Coflui mengubah JSON menjadi widget Flutter. Daftarkan builder '
        'bawaan sekali saat app start, lalu render komponen apa pun.'),
    DocBlock.code(
      '''import 'package:coflui/coflui.dart';

void main() {
  DynamicUIBootstrap.registerDefaults();
  runApp(const MyApp());
}

// Di widget:
final controller = CofluiFormController()..loadFromJson(json);

@override
Widget build(BuildContext context) {
  return ListView(
    children: [
      for (final c in controller.components)
        DynamicUIWidget(c, controller: controller),
    ],
  );
}''',
      language: 'dart',
    ),
    DocBlock.text(
        'Setiap komponen root di-render via DynamicUIWidget. Container '
        '(column/row/grid/card) otomatis merender children-nya secara '
        'rekursif — tak terbatas kedalaman.'),
  ],
);

const baseNode = DocSection(
  title: 'Base Node',
  summary: 'Struktur dasar setiap komponen JSON.',
  blocks: [
    DocBlock.code(
      '''{
  "id": "unique_key",
  "type": "text",
  "label": "Teks tampilan",
  "value": "nilai awal",
  "props": {},
  "style": {},
  "children": []
}''',
    ),
    DocBlock.text('Field utama:'),
    DocBlock.text('• id — kunci unik; dipakai sebagai key nilai controller. '
        'Auto-generated bila kosong.'),
    DocBlock.text('• type — salah satu dari 15 tipe komponen (lihat bawah).'),
    DocBlock.text('• label — teks tampilan (judul card, label field, teks tombol).'),
    DocBlock.text('• value — nilai awal (string/int/double/bool/list/map).'),
    DocBlock.text('• props — konfigurasi spesifik per tipe.'),
    DocBlock.text('• style — lihat section Style.'),
    DocBlock.text('• children — hanya untuk container; array node lain.'),
  ],
);

const containers = DocSection(
  title: 'Containers',
  summary: 'column, row, grid, card, section.',
  blocks: [
    DocBlock.text('Container memiliki children dan bisa bersarang tak terhingga.'),
    DocBlock.text('▸ column — tumpukan vertikal. cross-axis default stretch.'),
    DocBlock.code(
      '''{ "type": "column", "style": { "gap": 12 }, "children": [...] }''',
    ),
    DocBlock.text('▸ row — baris horizontal. Setiap child otomatis dibungkus '
        'Flexible/Expanded. Set props.flex pada child untuk Expanded.'),
    DocBlock.code(
      '''{
  "type": "row", "style": { "gap": 12 }, "children": [
    { "type": "button", "label": "Batal", "props": { "flex": 1 } },
    { "type": "button", "label": "Simpan", "props": { "flex": 2 } }
  ]
}''',
    ),
    DocBlock.text('▸ grid — grid responsif. Jumlah kolom dari breakpoint.'),
    DocBlock.code(
      '''{
  "type": "grid",
  "props": { "mobileColumns": 1, "tabletColumns": 2, "desktopColumns": 3 },
  "children": [...]
}''',
    ),
    DocBlock.text('▸ card — surface bergaya; label jadi judul card.'),
    DocBlock.text('▸ section — alias card untuk pengelompokan form.'),
  ],
);

const display = DocSection(
  title: 'Display',
  summary: 'text, heading, divider.',
  blocks: [
    DocBlock.text('▸ text — teks body; pakai value atau label.'),
    DocBlock.text('▸ heading — teks besar & bold.'),
    DocBlock.text('▸ divider — garis pemisah; style.gap = tinggi.'),
    DocBlock.code(
      '''[
  { "id": "h", "type": "heading", "label": "Judul" },
  { "id": "t", "type": "text", "value": "Paragraf isi." },
  { "id": "d", "type": "divider", "style": { "gap": 16 } }
]''',
    ),
  ],
);

const inputs = DocSection(
  title: 'Inputs',
  summary: 'textfield, dropdown, switch, checkbox, datepicker.',
  blocks: [
    DocBlock.text('▸ textfield — input teks.'),
    DocBlock.code(
      '''{
  "id": "email", "type": "textfield", "label": "Email",
  "props": { "hint": "nama@email.com", "keyboard": "email", "required": true }
}''',
    ),
    DocBlock.text('keyboard: number | phone | email | url | multiline. '
        'multiline: true + maxLines untuk area teks.'),
    DocBlock.text('▸ dropdown — pilihan dari options.'),
    DocBlock.code(
      '''{
  "id": "role", "type": "dropdown", "label": "Peran",
  "props": {
    "hint": "Pilih peran",
    "options": [ {"label":"Admin","value":"admin"}, {"label":"User","value":"user"} ]
  }
}''',
    ),
    DocBlock.text('▸ switch — toggle boolean.'),
    DocBlock.text('▸ checkbox — centang boolean.'),
    DocBlock.text('▸ datepicker — pemilih tanggal. value: string yyyy-MM-dd.'),
    DocBlock.code(
      '''{ "id": "dob", "type": "datepicker", "label": "Tanggal Lahir",
  "props": { "hint": "Pilih tanggal" } }''',
    ),
  ],
);

const action = DocSection(
  title: 'Action',
  summary: 'button.',
  blocks: [
    DocBlock.text('▸ button — tombol aksi. variant & action wajib.'),
    DocBlock.code(
      '''{
  "id": "submit", "type": "button", "label": "Kirim",
  "props": {
    "variant": "primary",
    "action": "submit",
    "icon": "send",
    "widthInfinity": true,
    "flex": 1
  }
}''',
    ),
    DocBlock.text('variant: primary | outline | danger | ghost.'),
    DocBlock.text('action dipass ke controller.onAction(action, id).'),
    DocBlock.text('icon: send | save | delete | reset | check | add | edit | close.'),
    DocBlock.text('widthInfinity: stretch ke lebar parent (default true untuk primary/danger).'),
    DocBlock.text('flex: porsi Expanded dalam row (mis. 1 vs 2).'),
  ],
);

const style = DocSection(
  title: 'Style',
  summary: 'Semua properti gaya (padding, warna, font, box).',
  blocks: [
    DocBlock.text('Semua dimensi dalam logical pixel (tanpa scaling). '
        'Warna: #RGB, #RRGGBB, atau #AARRGGBB.'),
    DocBlock.code(
      '''{
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
  "elevation": 2,
  "align": "center",
  "expand": true,
  "maxLines": 2
}''',
    ),
    DocBlock.text('▸ spacing: padding, paddingVertical (py), paddingHorizontal (px), gap.'),
    DocBlock.text('▸ text: fontSize, fontWeight (bold|w500|700), fontStyle (italic), '
        'color, align, maxLines.'),
    DocBlock.text('▸ box: bgColor (backgroundColor), borderColor, borderWidth, radius, elevation.'),
    DocBlock.text('▸ layout: crossAxis (start|center|end|stretch), '
        'mainAxis (start|center|end|spaceBetween|spaceEvenly), expand.'),
    DocBlock.text('align: left | start | right | end | center | justify.'),
  ],
);

const readingValues = DocSection(
  title: 'Reading Values',
  summary: 'Cara ambil nilai dari form via controller.',
  blocks: [
    DocBlock.code(
      '''final controller = CofluiFormController()..loadFromJson(json);

controller.getValue('name');          // nilai terakhir untuk id
controller.setValue('name', 'Budi');  // set nilai
controller.snapshot();                 // {id: value, ...}
controller.fieldListenable('name');    // ValueListenable per-field
controller.resetValues();              // kembalikan ke nilai awal JSON''',
      language: 'dart',
    ),
    DocBlock.text('setValue TIDAK memicu rebuild penuh — input self-manage via '
        'StatefulWidget sehingga efisien. snapshot() mengembalikan map semua nilai.'),
    DocBlock.text('Untuk handle aksi tombol, override onAction:'),
    DocBlock.code(
      '''class MyController extends CofluiFormController {
  @override
  void onAction(String action, String id) {
    if (action == 'submit') {
      final data = snapshot();
      // kirim ke API...
    }
  }
}''',
      language: 'dart',
    ),
  ],
);

const allSections = <DocSection>[
  quickStart,
  baseNode,
  containers,
  display,
  inputs,
  action,
  style,
  readingValues,
];
