# Pin npm packages by running ./bin/importmap

pin "application", preload: true
pin "@hotwired/turbo-rails", to: "turbo.min.js", preload: true
pin "@hotwired/stimulus", to: "stimulus.min.js", preload: true
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js", preload: true
pin_all_from "app/javascript/controllers", under: "controllers"
pin "bootstrap", to: "bootstrap.min.js", preload: true
pin "@popperjs/core", to: "popper.js", preload: true
pin "flatpickr", to: "https://ga.jspm.io/npm:flatpickr@4.6.13/dist/esm/index.js"
pin "flatpickr/dist/l10n/pt.js", to: "https://ga.jspm.io/npm:flatpickr@4.6.13/dist/l10n/pt.js"
pin "tabulator-tables", to: "https://ga.jspm.io/npm:tabulator-tables@5.5.2/dist/js/tabulator_esm.js"
pin "sweetalert2", to: "https://ga.jspm.io/npm:sweetalert2@11.9.0/dist/sweetalert2.all.js"
pin "tabulator-jspdf", to: "jspdf.umd.min.js"
pin "tabulator-xlsx", to: "xlsx.full.min.js"
pin "tabulator-jspdf-autotable", to: "jspdf.plugin.autotable.min.js"
pin "chartkick", to: "chartkick.js"
pin "Chart.bundle", to: "Chart.bundle.js"
