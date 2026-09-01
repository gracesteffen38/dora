var saveMenuBound = false;
var toolsMenuBound = false;

// Utility helpers

function menuExists(menuId) {
  return $(menuId).length > 0;
}

function isMenuVisible(menuId) {
  return $(menuId).is(':visible');
}

function bindMenuIfNeeded(menuId, menuName) {
  if (!window.Shiny || !menuExists(menuId)) return;

  if (menuName === 'save' && !saveMenuBound) {
    try { Shiny.bindAll($(menuId)[0]); } catch (err) {}
    saveMenuBound = true;
  }

  if (menuName === 'tools' && !toolsMenuBound) {
    try { Shiny.bindAll($(menuId)[0]); } catch (err) {}
    toolsMenuBound = true;
  }
}

function closeToolbarMenusExcept(menuIdToKeepOpen) {
  var menus = [
    '#save-dropdown-menu',
    '#tools-dropdown-menu',
    '#help-dropdown-menu',
    '#accessibility-dropdown-menu'
  ];

  menus.forEach(function(menuId) {
    if (menuId !== menuIdToKeepOpen && menuExists(menuId)) {
      $(menuId).hide();
    }
  });
}

function closeAllToolbarMenus() {
  closeToolbarMenusExcept(null);
}

function toggleToolbarMenu(menuId, menuName) {
  if (!menuExists(menuId)) return;

  var opening = !isMenuVisible(menuId);

  closeToolbarMenusExcept(menuId);

  if (opening) {
    $(menuId).show();
    bindMenuIfNeeded(menuId, menuName);
  } else {
    $(menuId).hide();
  }
}

function sendShinyEvent(inputId) {
  if (!window.Shiny) return;

  Shiny.setInputValue(inputId, new Date().getTime(), {
    priority: 'event'
  });
}

function isTypingTarget(target) {
  return $(target).is(
    'input, textarea, select, button, .selectize-input, .selectize-control'
  );
}

// Keyboard shortcuts

$(document).on('keydown', function(e) {
  var inInput = isTypingTarget(e.target);

  // Arrow keys: participant/event navigation when not typing
  if (!inInput) {
    if (e.which === 37) {
      $('#prev_id').click();
      e.preventDefault();
    }

    if (e.which === 39) {
      $('#next_id').click();
      e.preventDefault();
    }

    if (e.which === 38) {
      $('#prev_event').click();
      e.preventDefault();
    }

    if (e.which === 40) {
      $('#next_event').click();
      e.preventDefault();
    }
  }

  // Alt shortcuts
  if (e.altKey) {
    switch (e.which) {
      // Alt+H - Help menu
      case 72:
        e.preventDefault();
        toggleToolbarMenu('#help-dropdown-menu', 'help');
        break;

      // Alt+A - Accessibility menu
      case 65:
        e.preventDefault();
        toggleToolbarMenu('#accessibility-dropdown-menu', 'accessibility');
        break;

      // Alt+B - Back to data
      case 66:
        e.preventDefault();
        $('#back_data').click();
        break;

      // Alt+V - Go to visualizations
      case 86:
        e.preventDefault();
        $('#go_viz').click();
        break;

      // Alt+C - Convert data
      case 67:
        e.preventDefault();
        sendShinyEvent('open_converter_modal');
        break;

      // Alt+P - Peek at data
      case 80:
        e.preventDefault();
        $('#peek_data').click();
        break;

      // Alt+S - Save menu
      case 83:
        e.preventDefault();
        toggleToolbarMenu('#save-dropdown-menu', 'save');
        break;

      // Alt+T - Tools menu
      case 84:
        e.preventDefault();
        toggleToolbarMenu('#tools-dropdown-menu', 'tools');
        break;

      // Alt+D - Toggle second plot
      case 68:
        e.preventDefault();
        $('#show_second_plot').click();
        break;

      // Alt+I - Toggle step-through participants
      case 73:
        e.preventDefault();
        $('#step_through').click();
        break;

      // Alt+M - Toggle multiple participants
      case 77:
        e.preventDefault();
        $('#use_id').click();
        break;
    }
  }

  // Ctrl+S - Save menu
  if (e.ctrlKey && e.which === 83) {
    e.preventDefault();
    toggleToolbarMenu('#save-dropdown-menu', 'save');
  }

  // Escape - close all menus
  if (e.which === 27) {
    closeAllToolbarMenus();
  }

  // Tab - enable visible focus styles
  if (e.which === 9) {
    document.body.classList.add('keyboard-nav');
  }
});

// Remove keyboard-nav class on mouse use
$(document).on('mousedown', function() {
  document.body.classList.remove('keyboard-nav');
});

// Toolbar menu button clicks

$(document).on('click', '#save-dropdown-btn', function(e) {
  e.preventDefault();
  e.stopPropagation();
  toggleToolbarMenu('#save-dropdown-menu', 'save');
});

$(document).on('click', '#tools-dropdown-btn', function(e) {
  e.preventDefault();
  e.stopPropagation();
  toggleToolbarMenu('#tools-dropdown-menu', 'tools');
});

$(document).on('click', '#help-dropdown-btn', function(e) {
  e.preventDefault();
  e.stopPropagation();
  toggleToolbarMenu('#help-dropdown-menu', 'help');
});

$(document).on('click', '#accessibility-dropdown-btn', function(e) {
  e.preventDefault();
  e.stopPropagation();
  toggleToolbarMenu('#accessibility-dropdown-menu', 'accessibility');
});

// Prevent dropdown menus from closing when interacting inside them
$(document).on(
  'click',
  '#save-dropdown-menu, #tools-dropdown-menu, #help-dropdown-menu, #accessibility-dropdown-menu',
  function(e) {
    e.stopPropagation();
  }
);

// Close menus when clicking outside
$(document).on('click', function() {
  closeAllToolbarMenus();
});

// Save/download behavior

$(document).on('click', '#save-dropdown-menu .shiny-download-link', function() {
  setTimeout(function() {
    $('#save-dropdown-menu').hide();
  }, 500);
});

$(document).on('click', '.shiny-download-link', function() {
  var btn = $(this);
  var originalText = btn.html();

  btn
    .html('Saving...')
    .css('pointer-events', 'none')
    .css('opacity', '0.6');

  setTimeout(function() {
    btn
      .html(originalText)
      .css('pointer-events', '')
      .css('opacity', '');
  }, 4000);
});

// Sidebar/dropdown toggles

$(document).on('click', '#conversion-toggle', function(e) {
  e.preventDefault();
  $('#conversion-dropdown').slideToggle(200);
  $('#conversion-caret').toggleClass('caret-up');
});

$(document).on('click', '#labels-toggle', function(e) {
  e.preventDefault();
  $('#labels-dropdown').slideToggle(200);
  $('#labels-caret').toggleClass('caret-up');
});

$(document).on('click', '#subset-toggle', function(e) {
  e.preventDefault();
  $('#subset-dropdown').slideToggle(150);
  $('#subset-caret').toggleClass('caret-up');
});

// Tools menu actions

$(document).on('click', '#open-converter-tool', function(e) {
  e.preventDefault();
  e.stopPropagation();
  $('#tools-dropdown-menu').hide();
  sendShinyEvent('open_converter_modal');
});

$(document).on('click', '#open-structure-checker', function(e) {
  e.preventDefault();
  e.stopPropagation();
  $('#tools-dropdown-menu').hide();
  sendShinyEvent('open_structure_checker');
});

$(document).on('click', '#open-template-tool', function(e) {
  e.preventDefault();
  e.stopPropagation();
  $('#tools-dropdown-menu').hide();
  sendShinyEvent('open_template_tool');
});

$(document).on('click', '#open-missing-tool', function(e) {
  e.preventDefault();
  e.stopPropagation();
  $('#tools-dropdown-menu').hide();
  sendShinyEvent('open_missing_tool');
});

$(document).on('click', '#open-participant-summary', function(e) {
  e.preventDefault();
  e.stopPropagation();
  $('#tools-dropdown-menu').hide();
  sendShinyEvent('open_participant_summary');
});

$(document).on('click', '#open-event-summary', function(e) {
  e.preventDefault();
  e.stopPropagation();
  $('#tools-dropdown-menu').hide();
  sendShinyEvent('open_event_summary');
});

// Help menu actions

$(document).on('click', '#open-plot-presets', function(e) {
  e.preventDefault();
  e.stopPropagation();
  $('#help-dropdown-menu').hide();
  sendShinyEvent('open_plot_presets');
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
    console.warn('DORA: plot element not found for export - is a plot visible?');
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
