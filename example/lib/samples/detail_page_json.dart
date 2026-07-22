// Detail page template — a FULL document-detail page rendered entirely from
// the dynamic-UI engine. Clone-ready: the layout (this template) is static;
// only the data arrays change per document.
//
// Pattern to clone into another project:
//   1. Copy this template (layout stays the same).
//   2. Replace the values in [dummyApproval] with your API response.
//   3. Call [buildDetailJson(data)] → loadFromJson → render.
//
// Lists (approvers / lineItems / attachments) use the `list` component:
// the FIRST child is a template cloned per item, with `{field}` placeholders
// bound from each item's keys.

/// Builds a complete detail-page JSON tree from a data map.
///
/// [data] keys consumed:
///   docNumber, docType, status, statusVariant, createdAt, description,
///   company, division, nominal, currency, supplier,
///   approvers: [{name, role, status, statusVariant}],
///   lineItems: [{name, qty, satuan, price, total}],
///   attachments: [{name, kind}]   // kind: "pdf" | "image"
List<Map<String, dynamic>> buildDetailJson(Map<String, dynamic> d) {
  return [
    // ── Brand accent strip ────────────────────────────────────────────────
    {
      'id': 'accent',
      'type': 'gradient_bar',
      'props': {'gradient': 'accent', 'height': 6},
    },
    // ── Header: doc number + status chip ──────────────────────────────────
    {
      'id': 'header',
      'type': 'row',
      'style': {'mainAxis': 'spaceBetween', 'crossAxis': 'center'},
      'children': [
        {
          'id': 'doc_no',
          'type': 'heading',
          'label': d['docNumber'] ?? '-',
          'style': {'fontSize': 20},
        },
        {
          'id': 'status_chip',
          'type': 'chip',
          'props': {
            'label': d['status'] ?? 'Pending',
            'variant': d['statusVariant'] ?? 'warning',
            'icon': 'check_circle',
          },
        },
      ],
    },
    {
      'id': 'subtitle',
      'type': 'text',
      'label':
          '${d['docType'] ?? ''} • ${d['createdAt'] ?? ''}',
      'style': {'fontSize': 12, 'color': '#666666', 'paddingVertical': 4},
    },

    // ── Detail card ───────────────────────────────────────────────────────
    {
      'id': 'detail_card',
      'type': 'card',
      'style': {'padding': 16},
      'children': [
        {
          'id': 'dr_company',
          'type': 'detail_row',
          'props': {'icon': 'domain', 'label': 'Company', 'value': d['company'] ?? '-'},
        },
        {
          'id': 'dr_division',
          'type': 'detail_row',
          'props': {
            'icon': 'account_tree',
            'label': 'Division',
            'value': d['division'] ?? '-',
          },
        },
        {
          'id': 'dr_nominal',
          'type': 'detail_row',
          'props': {
            'icon': 'payments',
            'label': 'Amount',
            'value': '${d['nominal'] ?? '-'} (${d['currency'] ?? ''})',
            'highlight': true,
          },
        },
        {
          'id': 'dr_supplier',
          'type': 'detail_row',
          'props': {
            'icon': 'local_shipping',
            'label': 'Supplier',
            'value': d['supplier'] ?? '-',
          },
        },
        {
          'id': 'dr_date',
          'type': 'detail_row',
          'props': {
            'icon': 'calendar_today',
            'label': 'Date',
            'value': d['createdAt'] ?? '-',
          },
        },
        if ((d['description'] as String?)?.isNotEmpty == true) ...[
          {
            'id': 'dr_notes',
            'type': 'detail_row',
            'props': {
              'icon': 'description',
              'label': 'Notes',
              'value': d['description']!,
            },
          },
        ],
      ],
    },

    // ── Approvers (list — repeat list_tile template) ──────────────────────
    {
      'id': 'approver_title',
      'type': 'heading',
      'label': 'Approval Chain',
      'style': {'fontSize': 16, 'paddingVertical': 8},
    },
    {
      'id': 'approvers',
      'type': 'list',
      'props': {
        'items': d['approvers'] ?? const [],
        'direction': 'vertical',
        'spacing': 6,
        'emptyText': 'No approvers',
      },
      'children': [
        {
          'type': 'list_tile',
          'props': {
            'title': '{name}',
            'subtitle': '{role}',
            'leading': 'person',
            'trailing': '{statusIcon}',
            'action': 'view_approver',
          },
        },
      ],
    },

    // ── Line items (list — repeat a row of texts) ─────────────────────────
    {
      'id': 'items_title',
      'type': 'heading',
      'label': 'Line Items',
      'style': {'fontSize': 16, 'paddingVertical': 8},
    },
    {
      'id': 'line_items',
      'type': 'list',
      'props': {
        'items': d['lineItems'] ?? const [],
        'direction': 'vertical',
        'spacing': 4,
      },
      'children': [
        {
          'type': 'card',
          'style': {'padding': 12},
          'children': [
            {
              'type': 'row',
              'style': {'mainAxis': 'spaceBetween'},
              'children': [
                {'type': 'text', 'value': '{name}', 'style': {'fontWeight': 'bold'}},
                {'type': 'text', 'value': '{total}', 'style': {'color': '#088ECE'}},
              ],
            },
            {
              'type': 'text',
              'value': '{qty} {satuan} × {price}',
              'style': {'fontSize': 11, 'color': '#666666'},
            },
          ],
        },
      ],
    },

    // ── Attachments (list — repeat chips in a wrap) ───────────────────────
    {
      'id': 'att_title',
      'type': 'row',
      'style': {'mainAxis': 'spaceBetween', 'crossAxis': 'center', 'paddingVertical': 8},
      'children': [
        {'type': 'heading', 'label': 'Attachments', 'style': {'fontSize': 16}},
        {
          'type': 'chip',
          'props': {
            'label': '${(d['attachments'] as List?)?.length ?? 0}',
            'variant': 'info',
            'icon': 'attach_file',
          },
        },
      ],
    },
    {
      'id': 'attachments',
      'type': 'list',
      'props': {
        'items': d['attachments'] ?? const [],
        'direction': 'wrap',
        'spacing': 8,
      },
      'children': [
        {
          'id': '{name}',
          'type': 'chip',
          'props': {
            'label': '{name}',
            'variant': '{kind}',
            'icon': 'attach_file',
            'action': 'view_attachment',
          },
        },
      ],
    },

    // ── Action buttons ────────────────────────────────────────────────────
    {
      'id': 'actions',
      'type': 'row',
      'style': {'gap': 12, 'paddingVertical': 12},
      'children': [
        {
          'id': 'reject',
          'type': 'button',
          'label': 'Reject',
          'props': {'variant': 'danger', 'icon': 'close', 'action': 'reject'},
        },
        {
          'id': 'approve',
          'type': 'button',
          'label': 'Approve',
          'props': {'variant': 'primary', 'icon': 'check', 'action': 'approve', 'flex': 2},
        },
      ],
    },
  ];
}

/// Sample approval document used by the example detail screen.
///
/// Mirrors the shape of a real `ApprovalModel` (from pura_e_sign) but as a
/// plain map so the template stays data-format-agnostic. Swap this for your
/// API response and the whole page re-renders.
final Map<String, dynamic> dummyApproval = {
  'docNumber': 'SPP-2026-0048',
  'docType': 'Surat Pesanan Pembelian',
  'status': 'Pending',
  'statusVariant': 'warning',
  'createdAt': '2026-07-22 09:15',
  'company': 'PT Pura Barutama',
  'division': 'DIV-PROC — Procurement',
  'nominal': 'Rp 42.500.000',
  'currency': 'IDR',
  'supplier': 'PT Maju Jaya Sentosa',
  'description': 'Q3 office supplies & raw material procurement.',
  'approvers': [
    {'name': 'Andi Wijaya', 'role': 'Line Manager', 'status': 'Approved', 'statusVariant': 'success', 'statusIcon': 'check_circle'},
    {'name': 'Maya Putri', 'role': 'Finance Lead', 'status': 'Pending', 'statusVariant': 'warning', 'statusIcon': 'schedule'},
    {'name': 'Rian Dewa', 'role': 'Director', 'status': '—', 'statusVariant': 'neutral', 'statusIcon': 'hourglass_empty'},
  ],
  'lineItems': [
    {'name': 'A4 Paper (80gsm)', 'qty': '50', 'satuan': 'rim', 'price': 'Rp 45.000', 'total': 'Rp 2.250.000'},
    {'name': 'Toner Cartridge HP', 'qty': '8', 'satuan': 'pcs', 'price': 'Rp 850.000', 'total': 'Rp 6.800.000'},
    {'name': 'Cardstock 300gsm', 'qty': '20', 'satuan': 'pack', 'price': 'Rp 120.000', 'total': 'Rp 2.400.000'},
  ],
  'attachments': [
    {'name': 'invoice.pdf', 'kind': 'pdf', 'url': 'https://africau.edu/images/default/sample.pdf'},
    {'name': 'quotation.pdf', 'kind': 'pdf', 'url': 'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf'},
    {'name': 'spec.jpg', 'kind': 'image', 'url': 'https://picsum.photos/seed/coflui/600/400'},
  ],
};
