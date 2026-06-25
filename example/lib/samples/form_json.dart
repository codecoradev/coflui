// JSON definitions for the dynamic form example screen.

/// A complete employee-leave form rendered entirely from JSON.
///
/// Demonstrates: heading, textfield (various keyboards), dropdown, switch,
/// datepicker, and submit/reset buttons.
const List<Map<String, dynamic>> formJson = [
  {
    "id": "title",
    "type": "heading",
    "label": "Form Pengajuan Izin",
  },
  {
    "id": "section_employee",
    "type": "card",
    "label": "Data Karyawan",
    "children": [
      {
        "id": "employee_name",
        "type": "textfield",
        "label": "Nama Lengkap",
        "props": {"hint": "Masukkan nama lengkap", "required": true},
      },
      {
        "id": "employee_id",
        "type": "textfield",
        "label": "NIP / ID Karyawan",
        "props": {"hint": "Contoh: 12345", "keyboard": "number", "required": true},
      },
      {
        "id": "email",
        "type": "textfield",
        "label": "Email",
        "props": {"hint": "nama@perusahaan.com", "keyboard": "email"},
      },
      {
        "id": "phone",
        "type": "textfield",
        "label": "No. Telepon",
        "props": {"hint": "08xx...", "keyboard": "phone"},
      },
    ],
  },
  {
    "id": "section_leave",
    "type": "card",
    "label": "Detail Izin",
    "children": [
      {
        "id": "leave_type",
        "type": "dropdown",
        "label": "Jenis Izin",
        "props": {
          "hint": "Pilih jenis izin",
          "options": [
            {"label": "Izin Tahunan", "value": "annual"},
            {"label": "Sakit", "value": "sick"},
            {"label": "Menikah", "value": "marriage"},
            {"label": "Lainnya", "value": "other"},
          ],
        },
      },
      {
        "id": "start_date",
        "type": "datepicker",
        "label": "Tanggal Mulai",
        "props": {"hint": "Pilih tanggal"},
      },
      {
        "id": "is_half_day",
        "type": "switch",
        "label": "Setengah Hari",
      },
      {
        "id": "need_coverage",
        "type": "checkbox",
        "label": "Saya sudah mengatur penanganan pekerjaan",
      },
      {
        "id": "reason",
        "type": "textfield",
        "label": "Keterangan",
        "value": "",
        "props": {
          "hint": "Jelaskan alasan pengajuan izin...",
          "multiline": true,
          "maxLines": 4,
          "maxLength": 500,
        },
        "style": {"paddingVertical": 8},
      },
    ],
  },
  {
    "id": "section_buttons",
    "type": "row",
    "style": {"gap": 12},
    "children": [
      {
        "id": "reset_btn",
        "type": "button",
        "label": "Reset",
        "props": {
          "variant": "outline",
          "action": "reset",
          "icon": "reset",
          "flex": 1
        },
      },
      {
        "id": "submit_btn",
        "type": "button",
        "label": "Kirim Pengajuan",
        "props": {
          "variant": "primary",
          "action": "submit",
          "icon": "send",
          "widthInfinity": true,
          "flex": 2
        },
      },
    ],
  },
];
