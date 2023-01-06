import { Controller } from "@hotwired/stimulus"

import '../src/datatables-bs5'
// import '../src/datatables-bs4'
import '../src/debounce'

export default class extends Controller {
  static values = {
    simple: Boolean,
    url: String
  }

  initialize() {
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
    return `<input type="text" placeholder="search" name="idx${idx}" />`
  }

  // datatables options
  compileOptions(options) {
    // common options
    options.pagingType = "full_numbers"
    options.stateSave = false
    options.lengthMenu = [ [10, 25, 100, 250, 1000], [10, 25, 100, 250, 1000] ]
    options.columnDefs = [ { "targets": "nosort", "orderable": false },
                           { "targets": "notvisible", "visible": false },
                           { "targets": "actions", "className": "actions" } ]
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
    this.languageOptions(options)
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
    options.buttons = {
      dom: {
        button: {
          tag: 'button',
          className: 'btn btn-outline-secondary btn-sm'
        }
      },
      buttons:[ { "extend": 'excel',
	                  "exportOptions": { "search": ':applied' } },
                        { "extend": 'pdf',
	                  "orientation": 'landscape',
	                  "pageSize": 'A4',
	                  "exportOptions": { "columns": ':visible',
	                                     "search": ':applied' } },
                        { "extend": 'print'},
                        { "extend": 'colvis', "columns": ':gt(0)' } ]
    }
  }

  remoteOptions(options) {
    let token = document.head.querySelector('meta[name="csrf-token"]').getAttribute('content')
    options.searchDelay = 400
    options.processing = true
    options.serverSide = true
    options.ajax = {
      'url': this.urlValue,
      'type': 'POST',
      'beforeSend': function(request) {
        request.setRequestHeader("X-CSRF-Token", token)
      }
    }
  }

  languageOptions(options) {
    options.language = {
      "emptyTable":      "Keine Daten in der Tabelle vorhanden",
      "info":            "_START_ bis _END_ von _TOTAL_ Einträgen",
      "infoEmpty":       "0 bis 0 von 0 Einträgen",
      "infoFiltered":    "(gefiltert von _MAX_ Einträgen)",
      "infoPostFix":     "",
      "thousands":   ".",
      "lengthMenu":      "_MENU_ Einträge anzeigen",
      "loadingRecords":  "Wird geladen...",
      "processing":      "Bitte warten...",
      "search":          "Suchen",
      "zeroRecords":     "Keine Einträge vorhanden.",
      "paginate": {
          "first":       "Erste",
          "previous":    "Zurück",
          "next":        "Nächste",
          "last":        "Letzte"
      },
      "aria": {
          "sortAscending":  ": aktivieren, um Spalte aufsteigend zu sortieren",
          "sortDescending": ": aktivieren, um Spalte absteigend zu sortieren"
      }
    }
  }

  // -- immediate search for local data
  columnSearchLocal(dtable) {
    dtable.columns().every((colIdx) => {
      $('input[name=idx'+colIdx+']').on( 'keyup change', function() {
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
      $('input[name=idx'+colIdx+']').on( 'keyup change', function() {
        if ((this.value.length >= 3) || (this.value.length == 0)) {
          mysearch(this.value)
        }
      })
    })
  }
} // Controller
