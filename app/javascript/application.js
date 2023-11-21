// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import "@popperjs/core"
import "bootstrap"
import "tabulator-jspdf"
import "tabulator-xlsx"
import "tabulator-jspdf-autotable"
import {TabulatorFull as Tabulator} from 'tabulator-tables';
window.Tabulator = Tabulator;
import Swal from 'sweetalert2';
window.Swal = Swal;