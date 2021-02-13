// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

// import Rails from "@rails/ujs"
import "@hotwired/turbo-rails"
import * as ActiveStorage from "@rails/activestorage"
import "channels"


// import the application.scss we created for the bootstrap CSS (if you are not using assets stylesheet)
// import "../stylesheets/application"
// import "../src/style.scss"
// If you are using `import` syntax
// import '@client-side-validations/client-side-validations'
// import the bootstrap javascript module
// import "bootstrap"
import "jquery"
import "@nathanvda/cocoon"

// Rails.start()
ActiveStorage.start()

import "controllers"

// $(document).on("ajax:error", "form", function(e, data, status, xhr) {
//     $(this).replaceWith(data.responseText);
//     Turbolinks.dispatch("turbolinks:load");
//     $(".field_with_errors input:first").focus();
// });
// $(document).on('turbolinks:load', function() {
//     Rails.refreshCSRFTokens();
// });

// $(document).on('turbolinks:load', function() {
//     // Rails.refreshCSRFTokens();
//     alert('reloaded');
// });
// $( document ).on('ready turbolinks:load', function() {
//     alert('reloaded');
// })

// document.addEventListener("turbolinks:load", function () {
//     alert('reloaded');
// });