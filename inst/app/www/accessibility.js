$(document).on('change', '#high_contrast', function() {
  $('body').toggleClass(
    'high-contrast',
    $(this).is(':checked')
  );
});

$(document).on('change', '#large_text', function() {
  $('body').toggleClass(
    'large-text',
    $(this).is(':checked')
  );
});

$(document).on('change', '#large_targets', function() {
  $('body').toggleClass(
    'large-targets',
    $(this).is(':checked')
  );
});

$(document).on('change', '#reduce_motion', function() {
  $('body').toggleClass(
    'reduce-motion',
    $(this).is(':checked')
  );
});

