import { Controller } from "@hotwired/stimulus"
// import '../src/jquery.js'
import '../src/datatables-bs5'
import 'pivottable'

// Connects to data-controller="pivottable"
export default class extends Controller {
  static targets = [ "pivot", "input"]
  static values = {
    cols: Array,
    rows: Array,
    sum: Array
  }

  initialize() {
    let numberFormat = $.pivotUtilities.numberFormat
    let intFormat = numberFormat({digitsAfterDecimal: 0})
  }

  connect() {
    console.log(this.rowsValue)
    console.log(this.colsValue)
    console.log(this.sumValue)
    this.pivotize()
    this.mytable()
  }

  pivotize() {
    $(this.pivotTarget).pivot($(this.inputTarget), {
        rows: this.rowsValue,
        cols: this.colsValue,
        aggregator: $.pivotUtilities.aggregatorTemplates.sum(this.intFormat)(this.sumValue)
      }
    )
  }
  mytable() {
    let _this = this
    const table = $(_this.inputTarget)
    let dtable = $(table).DataTable({
      lengthMenu: [ -1],
      drawCallback: function(settings) {
        _this.pivotize()
      },
      dom: "<'row'<'col-md-6'BC><'col-md-6'f>>t<'row'<'col-md-6'ir><'col-md-6'p>>",
      buttons: {
        dom: {
          button: {
            tag: 'button',
            className: 'btn btn-outline-secondary btn-sm'
          }
        },
	buttons: [
	  {
	    extend: 'csv',
	    sheetName: 'raw',
	    filename: 'boskop-eol-matrix',
	    title: '',
	    exportOptions: {
	      selected: false,
	      columns: ':visible',
	      search: ':applied'
	    }
	  },
	  {
	    extend: 'excel',
	    sheetName: 'raw',
	    filename: 'boskop-eol-matrix',
	    title: '',
	    exportOptions: {
	      selected: false,
	      columns: ':visible',
	      search: ':applied'
	    }
	  }
	]
      }
    })


  }


}
