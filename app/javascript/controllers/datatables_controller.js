import { Controller } from "@hotwired/stimulus"

import '../src/datatables-bs4'
import '../src/debounce'

export default class extends Controller {
  static values = {
    simple: Boolean,
    url: String
  }

  initialize() {
    var myTable = $.fn.dataTable;
    $.extend( true, myTable.Buttons.defaults, {
      "dom": { "button": { "className": 'btn btn-outline-secondary btn-sm' } }
    })
  }

  connect() {
    let dtOptions = {}
    this.compileOptions(dtOptions)
    if (!this.simpleValue) {
      this.setInputFields()
    }
    const table = $(this.element.querySelector('table'))

    // prepare options, optional add remote processing (not yet implemented)
    let dtable = $(table).DataTable(dtOptions)

    // process column search input
    if (this.hasUrlValue) {
      this.columnSearchRemote(dtable)
    }
    else {
      this.columnSearchLocal(dtable)
    }
  } // connect

  // search fields for each column
  setInputFields() {
    this.element.querySelectorAll("table tfoot th:not([class='nosearch'])")
        .forEach((th, idx) => {
          th.insertAdjacentHTML('afterbegin', this.searchField(idx))
        })
  }

  // single search input field
  searchField(idx) {
    return `<input type="text" placeholder="Suche" name="idx-${idx}" />`
  }

  // datatables options
  compileOptions(options) {
    // common options
    options.pagingType = "full_numbers"
    options.stateSave = false
    options.lengthMenu = [ [10, 25, 100, 250], [10, 25, 100, 250] ]
    options.columnDefs = [ { "targets": "nosort", "orderable": false },
                           { "targets": "notvisible", "visible": false },
                           { "targets": 'center', "className": "center" },
                           { "targets": 'nowrap', "className": "nowrap" },
                           { "targets": 'center_td_link_from_a', "className": "center td_link_from_a" },
                           { "targets": "actions", "className": "actions" } ]
    // language
    this.languageOptions(options)

    // with or without buttons
    if (this.simpleValue) {
      this.simpleOptions(options)
    } else {
      this.buttonOptions(options)
    }

    // remote fetch via ajax or plain html data
    if (this.hasUrlValue) {
      this.remoteOptions(options)
    }
  }

  simpleOptions(options) {
    options.dom =  "<'row'<'col-sm-12'tr>>" +
                   "<'row'<'col pt-2'l><'col'i><'col'p>>"
    options.pagingType = "numbers"
  }


  buttonOptions(options) {
    options.dom = "<'row'<'col'l><'col'B><'col'f>>" +
                    "<'row'<'col-sm-12'tr>>" +
                    "<'row'<'col'i><'col'p>>"
    options.buttons = [ { "extend": 'excel',
	                  "exportOptions": { "search": ':applied',
                                             "columns": ':not(.noexport)',
                                             "stripNewLines": false } },
                        { "extend": 'pdf',
	                  "orientation": 'landscape',
	                  "pageSize": 'A4',
	                  "exportOptions": { "columns": ':visible',
	                                     "search": ':applied' } },
                        { "extend": 'print',
                          "text": '<i class="fa fa-print fa-fw"></i>' },
                        { "extend": 'colvis',
                          "text": "Spalten ändern",
                          "columns": ':gt(0)' } ]
  }

  remoteOptions(options) {
    options.searchDelay = 400
    options.processing = true
    options.serverSide = true
    options.ajax = { "url": this.urlValue, "type": "POST" }
  }

  languageOptions(options) {
    options.language = {
      "emptyTable": "Leere Tabelle",
      "info": "_START_ bis _END_ von _TOTAL_ Einträgen",
      "infoEmpty": "keine Einträge vorhanden",
      "infoFiltered": "(gefiltert, insgesamt _MAX_ Einträge)",
      "lengthMenu": "Einträge pro Seite _MENU_",
      "search": "Suche",
      "zeroRecords": "Nichts gefunden - sorry",
      "paginate": { "first": "Anfang",
                       "last": "Ende",
                       "next": "Weiter",
                       "previous": "Zurück" }
    }
  }

  // -- immediate search for local data
  columnSearchLocal(dtable) {
    dtable.columns().every((colIdx) => {
      $('input[name=idx-'+colIdx+']').on( 'keyup change', function() {
        dtable.column(colIdx).search(this.value).draw()
      })
    })
  }

  // -- delay search on server side processing to reduce high frequent ajax calls
  columnSearchRemote(dtable) {
    dtable.columns().every((colIdx) => {
      let mysearch = $.debounce(400, function(val) {
        dtable.column(colIdx).search(val).draw()
      })
      $('input[name=idx-'+colIdx+']').on( 'keyup change', function() {
        if ((this.value.length >= 3) || (this.value.length == 0)) {
          mysearch(this.value)
        }
      })
    })
  }
} // Controller
