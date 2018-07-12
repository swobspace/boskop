SimpleForm.setup do |config|
  config.wrappers :horizontal_date, tag: 'div', class: 'form-group row', error_class: 'form-group-invalid', valid_class: 'form-group-valid' do |b|
    b.use :html5
    b.use :placeholder
    b.optional :pattern
    b.optional :readonly
    b.use :label, class: 'col-sm-3 form-control-label'

    b.wrapper :grid_wrapper, tag: 'div', class: 'col-sm-9' do |ba|
      ba.wrapper tag: 'div', class: 'input-group mb-2' do |bai|
        bai.use :input, class: 'form-control datepicker col-sm-3', error_class: 'is-invalid', valid_class: 'is-valid'
        bai.wrapper tag: 'div', class: 'input-group-append' do |baig|
          baig.wrapper tag: 'i', class: 'input-group-text fas fa-calendar-alt fa-2x' do |baigi|
          end
        end
      end
      ba.use :full_error, wrap_with: { tag: 'div', class: 'invalid-feedback d-block' }
      ba.use :hint, wrap_with: { tag: 'small', class: 'form-text text-muted' }
    end
  end
end
