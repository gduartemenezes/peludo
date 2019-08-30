//= require rails-ujs
//= require activestorage
//= require jquery3
//= require popper
//= require bootstrap
//= require select2.min
//= require i18n/pt-BR
//= require jquery.toast.min
//= require_tree .

function toggleButtonState(buttonId, attributes) {
  $(buttonId).attr(attributes);
}

function initializeSelectInputs() {
  $('select').select2({
    theme: 'bootstrap4',
    language: 'pt-BR',
    containerCSS: { 'display': 'block' }
  });
}

$(document).ready(function () {
  initializeSelectInputs();
});
