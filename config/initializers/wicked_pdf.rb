WickedPdf.config = {
  # Path to the wkhtmltopdf executable: This can be omitted if using the wkhtmltopdf-binary gem.
  # exe_path: '/path/to/wkhtmltopdf',

  # Layout file to be used for PDFs
  # (e.g., 'pdf.html', 'layouts/pdf.html.erb', or similar)
  # layout: 'pdf.html',

  # Use only if your external hostname is unavailable on the server.
  # root_url: 'http://localhost',

  # Additional wkhtmltopdf options, see `wkhtmltopdf --extended-help` for a full list
  # For example:
  # margin: {
  #   top: 10, # default 10 (mm)
  #   bottom: 10,
  #   left: 10,
  #   right: 10
  # },
  # header: { right: '[page] of [topage]' }
}
