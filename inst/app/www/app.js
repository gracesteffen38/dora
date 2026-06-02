// Track if save menu has been bound
var saveMenuBound = false;

// Keyboard shortcuts
$(document).on('keydown', function(e) {
  var tag = $(e.target).prop('tagName');
  var inInput = $(e.target).is('input, textarea, select, .selectize-input');

  // ARROW KEYS — participant navigation (when not in text input)
  if (!inInput) {
    if (e.which == 37) { $('#prev_id').click(); e.preventDefault(); }
    if (e.which == 39) { $('#next_id').click(); e.preventDefault(); }
    // Up/Down for event navigation
    if (e.which == 38) { $('#prev_event').click(); e.preventDefault(); }
    if (e.which == 40) { $('#next_event').click(); e.preventDefault(); }
  }

  // ALT SHORTCUTS
  if (e.altKey) {
    switch(e.which) {

      // Alt+H — Help menu
      case 72:
        e.preventDefault();
        var helpMenu = document.getElementById('help-dropdown-menu');
        if (helpMenu) {
          var isVisible = helpMenu.style.display !== 'none';
          helpMenu.style.display = isVisible ? 'none' : 'block';
          document.getElementById('save-dropdown-menu').style.display = 'none';
          document.getElementById('accessibility-dropdown-menu').style.display = 'none';
        }
        break;

      // Alt+A — Accessibility menu
      case 65:
        e.preventDefault();
        var accMenu = document.getElementById('accessibility-dropdown-menu');
        if (accMenu) {
          var isVisible = accMenu.style.display !== 'none';
          accMenu.style.display = isVisible ? 'none' : 'block';
          document.getElementById('save-dropdown-menu').style.display = 'none';
          var hm = document.getElementById('help-dropdown-menu');
          if (hm) hm.style.display = 'none';
        }
        break;

      // Alt+B — Back to data
      case 66:
        e.preventDefault();
        $('#back_data').click();
        break;

      // Alt+V — Go to visualizations
      case 86:
        e.preventDefault();
        $('#go_viz').click();
        break;

      // Alt+C — Convert data
      case 67:
        e.preventDefault();
        $('#convert_data').click();
        break;

      // Alt+P — Peek at data
      case 80:
        e.preventDefault();
        $('#peek_data').click();
        break;

      // Alt+S — Save menu
      case 83:
        e.preventDefault();
        var saveMenu = document.getElementById('save-dropdown-menu');
        if (saveMenu) {
          var isVisible = saveMenu.style.display !== 'none';
          saveMenu.style.display = isVisible ? 'none' : 'block';
          if (!isVisible && !saveMenuBound) {
            try { Shiny.bindAll(saveMenu); } catch(err) {}
            saveMenuBound = true;
          }
          document.getElementById('accessibility-dropdown-menu').style.display = 'none';
          var hm = document.getElementById('help-dropdown-menu');
          if (hm) hm.style.display = 'none';
        }
        break;

      // Alt+D — Toggle second plot
      case 68:
        e.preventDefault();
        var cb = document.getElementById('show_second_plot');
        if (cb) { cb.click(); }
        break;

      // Alt+I — Toggle step through participants
      case 73:
        e.preventDefault();
        var st = document.getElementById('step_through');
        if (st) { st.click(); }
        break;

      // Alt+M — Toggle multiple participants checkbox
      case 77:
        e.preventDefault();
        var uid = document.getElementById('use_id');
        if (uid) { uid.click(); }
        break;
    }
  }

  // CTRL SHORTCUTS
  if (e.ctrlKey) {
    // Ctrl+S — Save menu (keep original)
    if (e.which == 83) {
      e.preventDefault();
      var saveMenu = document.getElementById('save-dropdown-menu');
      if (saveMenu) {
        var isVisible = saveMenu.style.display !== 'none';
        saveMenu.style.display = isVisible ? 'none' : 'block';
        if (!isVisible && !saveMenuBound) {
          try { Shiny.bindAll(saveMenu); } catch(err) {}
          saveMenuBound = true;
        }
      }
    }
  }

  // ESCAPE — close all menus
  if (e.which == 27) {
    document.getElementById('save-dropdown-menu').style.display = 'none';
    document.getElementById('accessibility-dropdown-menu').style.display = 'none';
    var hm = document.getElementById('help-dropdown-menu');
    if (hm) hm.style.display = 'none';
  }

  // TAB — ensure focus visible (accessibility)
  if (e.which == 9) {
    document.body.classList.add('keyboard-nav');
  }
});

// Remove keyboard-nav class on mouse use
$(document).on('mousedown', function() {
  document.body.classList.remove('keyboard-nav');
});


// Save dropdown toggle
$(document).on('click', '#save-dropdown-btn', function(e) {
  e.preventDefault();
  e.stopPropagation();
  var saveMenu = document.getElementById('save-dropdown-menu');
  if (saveMenu) {
    var isVisible = saveMenu.style.display !== 'none';
    saveMenu.style.display = isVisible ? 'none' : 'block';
    if (!isVisible && !saveMenuBound) {
      try { Shiny.bindAll(saveMenu); } catch(err) {}
      saveMenuBound = true;
    }
  }
  var accMenu = document.getElementById('accessibility-dropdown-menu');
  if (accMenu) accMenu.style.display = 'none';
  var helpMenu = document.getElementById('help-dropdown-menu');
  if (helpMenu) helpMenu.style.display = 'none';

});


// Accessibility dropdown toggle
$(document).on('click', '#accessibility-dropdown-btn', function(e) {
  e.preventDefault();
  e.stopPropagation();
  var accMenu = document.getElementById('accessibility-dropdown-menu');
  if (accMenu) {
    var isVisible = accMenu.style.display !== 'none';
    accMenu.style.display = isVisible ? 'none' : 'block';
  }
  var saveMenu = document.getElementById('save-dropdown-menu');
  if (saveMenu) saveMenu.style.display = 'none';
  var helpMenu = document.getElementById('help-dropdown-menu');
  if (helpMenu) helpMenu.style.display = 'none';
});

// Handle clicks inside save menu
$(document).on('click', '#save-dropdown-menu', function(e) {
  var target = $(e.target);

  // If clicking a download button or its child, let Shiny handle it
  if (target.hasClass('shiny-download-link') || target.closest('.shiny-download-link').length) {
    setTimeout(function() {
      document.getElementById('save-dropdown-menu').style.display = 'none';
    }, 500);
    return;
  }

  // For non-download areas, prevent menu from closing
  e.stopPropagation();
});

// Show loading state on save buttons
$(document).on('click', '.shiny-download-link', function() {
  var btn = $(this);
  var originalText = btn.html();
  btn.html('Saving...').css('pointer-events', 'none').css('opacity', '0.6');
  setTimeout(function() {
    btn.html(originalText).css('pointer-events', '').css('opacity', '');
  }, 4000);
});

// Prevent accessibility menu from closing when clicking inside
$(document).on('click', '#accessibility-dropdown-menu', function(e) {
  e.stopPropagation();
});

// Data conversion toggle
$(document).on('click', '#conversion-toggle', function(e) {
  e.preventDefault();
  $('#conversion-dropdown').slideToggle(200);
  $('#conversion-caret').toggleClass('caret-up');
});

// Custom labels toggle
$(document).on('click', '#labels-toggle', function(e) {
  e.preventDefault();
  $('#labels-dropdown').slideToggle(200);
  $('#labels-caret').toggleClass('caret-up');
});



// Help dropdown toggle
$(document).on('click', '#help-dropdown-btn', function(e) {
  e.preventDefault();
  e.stopPropagation();
  var helpMenu = document.getElementById('help-dropdown-menu');
  if (helpMenu) {
    var isVisible = helpMenu.style.display !== 'none';
    helpMenu.style.display = isVisible ? 'none' : 'block';
  }
  // Close other menus
  var saveMenu = document.getElementById('save-dropdown-menu');
  var accMenu = document.getElementById('accessibility-dropdown-menu');
  if (saveMenu) saveMenu.style.display = 'none';
  if (accMenu) accMenu.style.display = 'none';
});

// Close dropdowns when clicking outside
$(document).on('click', function(e) {
  if (!$(e.target).closest('#save-dropdown-btn, #save-dropdown-menu').length) {
    var saveMenu = document.getElementById('save-dropdown-menu');
    if (saveMenu) saveMenu.style.display = 'none';
  }
  if (!$(e.target).closest('#accessibility-dropdown-btn, #accessibility-dropdown-menu').length) {
    var accMenu = document.getElementById('accessibility-dropdown-menu');
    if (accMenu) accMenu.style.display = 'none';
  }
  if (!$(e.target).closest('#help-dropdown-btn, #help-dropdown-menu').length) {
    var helpMenu = document.getElementById('help-dropdown-menu');
    if (helpMenu) helpMenu.style.display = 'none';
  }
});

// Listen for plotly zoom/pan - bind when plot renders, not on page load
$(document).on('shiny:value', function(e) {
  if (e.name == 'plot') {
    setTimeout(function() {
      var plotEl = document.getElementById('plot');
      if (plotEl && typeof plotEl.on =='function') {
        // Remove previous listener to avoid duplicates
        plotEl.removeAllListeners('plotly_relayout');
        plotEl.on('plotly_relayout', function(eventData) {
          Shiny.setInputValue('plot_relayout', eventData, {priority: 'event'});
        });
      }
    }, 200);
  }
});

// Client-side plot export
function doDownloadPlot(opts) {
  var plotEl = document.getElementById(opts.elementId);
  if (!plotEl) {
    console.warn('DORA: plot element not found for export — is a plot visible?');
    return;
  }
  Plotly.downloadImage(plotEl, {
    format:   opts.format,
    filename: opts.filename,
    width:    opts.width,
    height:   opts.height,
    scale:    opts.scale
  });
}
Shiny.addCustomMessageHandler('downloadPlot', doDownloadPlot);

$(document).ready(function() {
  // ARIA connections
  $('#file').attr('aria-describedby', 'file-help');
  $('#data_structure').attr('aria-describedby', 'data-structure-help');
  $('#viz_mode').attr('aria-describedby', 'viz-mode-help');

  // Extra descriptions toggle
  $(document).on('change', '#show_descriptions, #toolbar_show_descriptions', function() {
    if ($(this).is(':checked')) {
      $('.help-text').show();
    } else {
      $('.help-text').hide();
    }
  });
});
