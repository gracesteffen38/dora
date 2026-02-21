options(shiny.maxRequestSize = 100*1024^2)

ui <- fluidPage(
  tags$head(
    tags$meta(name = "viewport", content = "width=device-width, initial-scale=1"),
    tags$title("Time Series Explorer - Accessible Data Visualization"),
    tags$style(id = "accessibility-styles", HTML("")),

    tags$style(HTML("
    .toolbar {
      box-shadow: 0 2px 4px rgba(0,0,0,0.1);
      font-size: 14px;
    }

    .download-link {
      display: block;
      padding: 8px 20px;
      text-decoration: none;
      color: #333;
      font-size: 14px;
    }

    .download-link:hover {
      background-color: #f8f9fa;
      text-decoration: none;
      color: #333;
    }

    .dropdown-menu {
      border-radius: 6px;
      box-shadow: 0 4px 12px rgba(0,0,0,0.15);
    }

    .btn-group .dropdown-menu li {
      list-style: none;
    }

    /* Accessibility menu wider dropdown */
    #toolbar-accessibility .dropdown-menu {
      left: 50%;
      transform: translateX(-50%);
    }

    /* Make toolbar responsive */
    @media (max-width: 768px) {
      .toolbar {
        flex-direction: column;
        padding: 5px;
      }
      #toolbar-accessibility {
        order: 3;
        margin-top: 10px;
      }
    }

    /* Custom labels dropdown */
      .caret-up {
    display: inline-block;
    width: 0;
    height: 0;
    vertical-align: middle;
    border-bottom: 4px dashed;
    border-right: 4px solid transparent;
    border-left: 4px solid transparent;
    border-top: 0;
  }

  #labels-dropdown .form-group {
    margin-bottom: 8px;
  }

  #labels-toggle:hover {
    color: #007bff !important;
  }
  ")),

    # Bootstrap collapse JavaScript
    tags$script(src = "https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"),
    tags$script(HTML("
// Track if save menu has been bound
var saveMenuBound = false;

// Keyboard shortcuts
$(document).on('keydown', function(e) {
  // Arrow keys - only when not in input
  if (!$(e.target).is('input, textarea, select')) {
    if (e.which == 37) {
      $('#prev_id').click();
      e.preventDefault();
    } else if (e.which == 39) {
      $('#next_id').click();
      e.preventDefault();
    }
  }

  // Ctrl + S for save
  if (e.ctrlKey && e.which == 83) {
    e.preventDefault();
    var saveMenu = document.getElementById('save-dropdown-menu');
    if (saveMenu) {
      var isVisible = saveMenu.style.display !== 'none';
      saveMenu.style.display = isVisible ? 'none' : 'block';
      if (!isVisible && !saveMenuBound) {
        try { Shiny.bindAll(saveMenu); } catch(err) {}
        saveMenuBound = true;
      }
      var accMenu = document.getElementById('accessibility-dropdown-menu');
      if (accMenu) accMenu.style.display = 'none';
    }
  }

  // Alt + A for accessibility
  if (e.altKey && e.which == 65) {
    e.preventDefault();
    var accMenu = document.getElementById('accessibility-dropdown-menu');
    if (accMenu) {
      var isVisible = accMenu.style.display !== 'none';
      accMenu.style.display = isVisible ? 'none' : 'block';
      var saveMenu = document.getElementById('save-dropdown-menu');
      if (saveMenu) saveMenu.style.display = 'none';
    }
  }

  // Escape closes all
  if (e.which == 27) {
    var saveMenu = document.getElementById('save-dropdown-menu');
    var accMenu = document.getElementById('accessibility-dropdown-menu');
    if (saveMenu) saveMenu.style.display = 'none';
    if (accMenu) accMenu.style.display = 'none';
  }
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

// Prevent accessibility menu from closing when clicking inside
$(document).on('click', '#accessibility-dropdown-menu', function(e) {
  e.stopPropagation();
});

// Custom labels toggle
$(document).on('click', '#labels-toggle', function(e) {
  e.preventDefault();
  $('#labels-dropdown').slideToggle(200);
  $('#labels-caret').toggleClass('caret-up');
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

// Close help menu when clicking outside
$(document).on('click', function(e) {
  if (!$(e.target).closest('#help-dropdown-btn, #help-dropdown-menu').length) {
    var helpMenu = document.getElementById('help-dropdown-menu');
    if (helpMenu) helpMenu.style.display = 'none';
  }
});

// Listen for plotly zoom/pan events
$(document).on('shiny:connected', function() {
  document.getElementById('plot').on('plotly_relayout', function(eventData) {
    Shiny.setInputValue('plot_relayout', eventData, {priority: 'event'});
  });
});

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
")),
  ),
  shinyjs::useShinyjs(),
  # Accessibility Settings Panel page 1
  tags$div(id = "accessibility-panel", class = "panel panel-default",
           style = "margin-bottom: 15px; border-left: 4px solid #17a2b8;",

    tags$div(class = "panel-heading", style = "background-color: #f8f9fa;",
      tags$h5(class = "panel-title",
        tags$a(href = "#accessibility-controls", `data-toggle` = "collapse",
               `aria-expanded` = "false", `aria-controls` = "accessibility-controls",
               style = "text-decoration: none;",
          icon("universal-access"), " Accessibility Settings "
        )
      )
    ),

    tags$div(id = "accessibility-controls", class = "panel-collapse collapse",
      tags$div(class = "panel-body",
        fluidRow(
          column(3,
            h6("Visual"),
            checkboxInput("high_contrast", "High Contrast", FALSE),
            checkboxInput("large_text", "Large Text", FALSE),
            checkboxInput("colorblind_safe", "Colorblind-Safe", FALSE)
          ),
          column(3,
            h6("Motor"),
            checkboxInput("large_targets", "Large Targets", FALSE),
            checkboxInput("reduce_motion", "Reduce Motion", FALSE),
            checkboxInput("sticky_controls", "Sticky Nav", FALSE)
          ),
          column(3,
            h6("Cognitive"),
            checkboxInput("simplified_ui", "Simplified UI", FALSE),
            checkboxInput("show_descriptions", "Extra Help", FALSE),
            checkboxInput("confirm_actions", "Confirm Actions", FALSE)
          ),
          column(3,
            h6("Presets"),
            actionButton("preset_vision", "Vision Preset", class = "btn-sm btn-outline-primary"),
            br(), br(),
            actionButton("preset_motor", "Motor Preset", class = "btn-sm btn-outline-primary"),
            br(), br(),
            actionButton("reset_accessibility", "Reset All", class = "btn-sm btn-outline-secondary")
          )
        )
      )
    )
  ),
  titlePanel("Data Organization and Rhythm Analysis"),

  # Sticky Toolbar
  conditionalPanel(
    condition = "input.sidebar_state == 'viz'",
    tags$div(id = "sticky-toolbar", class = "toolbar",
             style = "position: fixed; top: 0; left: 0; right: 0; z-index: 1000;
           background-color: rgba(248, 249, 250, 0.95); backdrop-filter: blur(5px);
           border-bottom: 1px solid #dee2e6; padding: 5px 20px;
           display: flex; justify-content: space-between; align-items: center;",

             # Left side - Back button
             tags$div(
               actionButton("back_data", "← Back to Data Options",
                            class = "btn btn-outline-secondary", accesskey = "b",
                            title = "Back to Data Options (Alt+B)")
             ),

             # Center - Accessibility Menu on page 2
             tags$div(id = "toolbar-accessibility", style = "flex: 1; text-align: center;",
                      tags$div(class = "btn-group",
                               tags$button(id = "accessibility-dropdown-btn", class = "btn btn-outline-info btn-sm",
                                           style = "font-size: 14px; padding-right: 10px; border: 2px solid #17a2b8",  type = "button",
                                           `data-toggle` = "dropdown", `aria-haspopup` = "true", `aria-expanded` = "false",
                                           title = "Accessibility Settings (Alt+A)",
                                           icon("universal-access"), " Accessibility Settings ", tags$span(class = "caret")),
                               tags$ul(id = "accessibility-dropdown-menu", class = "dropdown-menu",
                                       style = "display: none; padding: 15px; min-width: 600px;",
                                       tags$li(
                                         fluidRow(
                                           column(4,
                                                  tags$h6("Visual", style = "font-weight: bold; margin-bottom: 10px;"),
                                                  checkboxInput("toolbar_high_contrast", "High Contrast", FALSE),
                                                  checkboxInput("toolbar_large_text", "Large Text", FALSE),
                                                  checkboxInput("toolbar_colorblind_safe", "Colorblind-Safe", FALSE)
                                           ),
                                           column(4,
                                                  tags$h6("Motor", style = "font-weight: bold; margin-bottom: 10px;"),
                                                  checkboxInput("toolbar_large_targets", "Large Targets", FALSE),
                                                  checkboxInput("toolbar_reduce_motion", "Reduce Motion", FALSE),
                                                  checkboxInput("toolbar_sticky_controls", "Sticky Nav", FALSE)
                                           ),
                                           column(4,
                                                  tags$h6("Cognitive", style = "font-weight: bold; margin-bottom: 10px;"),
                                                  checkboxInput("toolbar_simplified_ui", "Simplified UI", FALSE),
                                                  checkboxInput("toolbar_show_descriptions", "Extra Help", FALSE),
                                                  checkboxInput("toolbar_confirm_actions", "Confirm Actions", FALSE)
                                           )
                                         ),
                                         tags$hr(),
                                         fluidRow(
                                           column(6,
                                                  actionButton("toolbar_preset_vision", "Vision Preset", class = "btn-sm btn-outline-primary", style = "width: 100%;"),
                                                  br(), br(),
                                                  actionButton("toolbar_preset_motor", "Motor Preset", class = "btn-sm btn-outline-primary", style = "width: 100%;")
                                           ),
                                           column(6,
                                                  actionButton("toolbar_reset_accessibility", "Reset All", class = "btn-sm btn-outline-secondary", style = "width: 100%;")
                                           )
                                         )
                                       )
                               )
                      )
             ),

             # Save menu
             # Right side - Save menu
             tags$div(
               tags$div(class = "btn-group",
                        tags$button(id = "save-dropdown-btn", class = "btn btn-success dropdown-toggle",
                                    type = "button",
                                    title = "Save plots (Ctrl+S)",
                                    icon("download"), " Save ", tags$span(class = "caret")),
                        tags$div(id = "save-dropdown-menu",
                                 style = "display: none; position: absolute; right: 0; top: 100%;
                  min-width: 270px; background: white; border: 1px solid #ddd;
                  border-radius: 6px; box-shadow: 0 4px 12px rgba(0,0,0,0.15);
                  z-index: 2000; padding: 10px;",

                                 # Main Plot Section
                                 tags$h6(style = "font-weight: bold; margin-bottom: 8px; color: #333;", "Main Plot"),
                                 tags$div(style = "margin-bottom: 5px;",
                                          tags$a(id = "toolbar_download_plot_html", href = "", class = "btn btn-primary btn-sm shiny-download-link",
                                                 download = "", target = "_blank", style = "width: 100%; display: block; text-align: center;",
                                                 "Interactive (HTML)")
                                 ),
                                 tags$div(style = "margin-bottom: 10px;",
                                          tags$a(id = "toolbar_download_plot_png", href = "", class = "btn btn-outline-primary btn-sm shiny-download-link",
                                                 download = "", target = "_blank", style = "width: 100%; display: block; text-align: center;",
                                                 "Static Image (PNG)")
                                 ),

                                 # Both Plots Section
                                 conditionalPanel(
                                   condition = "input.show_second_plot == true",
                                   tags$hr(style = "margin: 8px 0;"),
                                   tags$h6(style = "font-weight: bold; margin-bottom: 8px; color: #333;", "Both Plots"),
                                   tags$div(style = "margin-bottom: 5px;",
                                            tags$a(id = "toolbar_download_both_html", href = "", class = "btn btn-info btn-sm shiny-download-link",
                                                   download = "", target = "_blank", style = "width: 100%; display: block; text-align: center;",
                                                   "Interactive (ZIP)")
                                   ),
                                   tags$div(style = "margin-bottom: 10px;",
                                            tags$a(id = "toolbar_download_both_png", href = "", class = "btn btn-outline-info btn-sm shiny-download-link",
                                                   download = "", target = "_blank", style = "width: 100%; display: block; text-align: center;",
                                                   "Static Images (ZIP)")
                                   )
                                 ),

                                 # Descriptive Stats Section
                                 tags$hr(style = "margin: 8px 0;"),
                                 tags$h6(style = "font-weight: bold; margin-bottom: 8px; color: #333;", "Descriptive Statistics"),
                                 tags$div(style = "margin-bottom: 5px;",
                                          tags$a(id = "toolbar_download_stats_txt", href = "", class = "btn btn-warning btn-sm shiny-download-link",
                                                 download = "", target = "_blank", style = "width: 100%; display: block; text-align: center;",
                                                 "Text File (.txt)")
                                 ),
                                 tags$div(style = "margin-bottom: 5px;",
                                          tags$a(id = "toolbar_download_stats_csv", href = "", class = "btn btn-outline-warning btn-sm shiny-download-link",
                                                 download = "", target = "_blank", style = "width: 100%; display: block; text-align: center;",
                                                 "Spreadsheet (.csv)")
                                 ),

                                 # Save Everything Section
                                 tags$hr(style = "margin: 8px 0;"),
                                 tags$div(
                                   tags$a(id = "toolbar_download_all", href = "", class = "btn btn-success btn-sm shiny-download-link",
                                          download = "", target = "_blank", style = "width: 100%; display: block; text-align: center;",
                                          "Save Everything (ZIP)")
                                 )
                        )
               )
             ),
             # Help button - add after the save menu div
             tags$div(
               tags$div(class = "btn-group",
                        tags$button(id = "help-dropdown-btn",
                                    class = "btn btn-outline-secondary btn-sm",
                                    type = "button",
                                    title = "Help",
                                    style = "border-radius: 50%; width: 36px; height: 36px;
                         padding: 0; font-size: 16px; border: 2px solid #6c757d;",
                                    HTML("&#9432;")),  # circled i character
                        tags$div(id = "help-dropdown-menu",
                                 style = "display: none; position: absolute; right: 0; top: 100%;
                      min-width: 220px; background: white; border: 1px solid #ddd;
                      border-radius: 6px; box-shadow: 0 4px 12px rgba(0,0,0,0.15);
                      z-index: 2000; padding: 8px 0;",
                                 tags$a(href = paste0("mailto:dorashinyapp@gmail.com",
                                                      "?subject=", utils::URLencode("DORA Bug Report"),
                                                      "&body=", utils::URLencode("Describe the bug:\n\nSteps to reproduce:\n\nExpected behaviour:\n\nActual behaviour:")),
                                        style = "display: block; padding: 8px 16px; color: #333;
                      text-decoration: none; font-size: 14px;",
                                        icon("bug"), " Report a bug...")
                        )
               )
             )
             )
  ),

  # Add spacing so content doesn't hide under toolbar
  conditionalPanel(
    condition = "input.sidebar_state == 'viz'",
    tags$div(style = "height: 5px;")  # Spacer
  ),

  sidebarLayout(
    sidebarPanel(

      # DATA OPTIONS
      conditionalPanel(
        condition = "input.sidebar_state == 'data'",

        h4("Step 1: Upload Data"),

        # Demo dropdown first
        selectInput("demo_choice", "Select a demo dataset",
                    choices = c("None" = "",
                                "Infant Object Play" = "demo1",
                                "Daily Music Bouts" = "demo2",
                                "Mother-Child Interactions" = "demo3"),
                    selected = "demo1"),  # default to first demo

        tags$div(style = "text-align: center; padding: 8px; color: #666; font-weight: bold;",
                 "— OR —"
        ),

        fileInput("file", "Upload your own CSV", accept = ".csv"),

        tags$div(
          style = "padding: 8px; background-color: #e8f4f8; border-left: 3px solid #17a2b8;
           border-radius: 4px; font-size: 0.9em; margin-top: 8px;",
          textOutput("active_dataset_name")
        ),
        #
        # conditionalPanel(
        #   condition = "input.data_source != 'upload'",
        #   tags$div(
        #     style = "padding: 8px; background-color: #f8f9fa; border-radius: 4px; font-size: 0.9em; color: #666;",
        #     "Demo data loaded. Switch to 'Upload your own CSV' to use your own data."
        #   )
        # ),
        tags$div(id = "file-help", class = "help-text", style = "font-size: 0.9em; color: #666; display: none;",
                 "Upload a CSV file containing your time-series data"),
        conditionalPanel(
          condition = "output.hasData",
          actionButton("peek_data", "Peek at data",
                       class = "btn-sm btn-outline-info",
                       icon = icon("table"),
                       style = "margin-top: 5px;")
        ),
        conditionalPanel(
          condition = "output.hasData",
          hr(),
          h4("Data Format Conversion"),
          checkboxInput("is_interval_data", "Data has start time and end time or duration columns", FALSE),
          conditionalPanel(
            condition = "input.is_interval_data",
            uiOutput("interval_conversion_ui"),
            actionButton("convert_data", "Convert to Continuous Format", class = "btn-success",
                         accesskey = "c", title = "Convert Data (Alt+C)"),
            br(), br(),
            textOutput("conversion_status"),
            conditionalPanel(
              condition = "output.conversionDone",
              downloadButton("download_converted", "Download Converted Data (.csv)",
                             class = "btn-sm btn-outline-success",
                             style = "margin-top: 8px;")
            )
          )
        ),

        conditionalPanel(
          condition = "output.hasData",
          hr(),
          h4("Step 2: Describe Dataset"),

          selectInput("data_structure", "Primary data type",
                      c("Continuous time series", "Binary / event-coded", "Mixed (continuous + events)")),
          tags$div(id = "data-structure-help", class = "help-text", style = "font-size: 0.9em; color: #666; display: none;",
                   "Continuous: numeric measurements over time. Binary: 0/1 event data. Mixed: both types."),

          checkboxInput("use_id", "Multiple participants", FALSE),

          conditionalPanel(
            condition = "input.use_id",
            uiOutput("idvar_ui")
          ),

          br(),
          actionButton("go_viz", "Go to Visualizations", class = "btn-primary", accesskey = "v",
                       title = "Go to Visualizations (Alt+V)")
        )
      ),

      # VISUALIZATIONS
      conditionalPanel(
        condition = "input.sidebar_state == 'viz'",

        h4("Step 3: Visualization"),

        selectInput("viz_mode", "Visualization type",
                    c("Raw time series", "Event + Continuous Overlay", "Event-locked average",
                      "Event-locked single event", "Event durations (barcode)")),
        tags$div(id = "viz-mode-help", class = "help-text", style = "font-size: 0.9em; color: #666; display: none;",
                 "Choose how to display your data: line plots, event overlays, or event-triggered averages"),

        # Participant controls
        conditionalPanel(
          condition = "input.use_id == true",
          h4("Participants"),
          checkboxInput("step_through", "Step through participants", FALSE),

          conditionalPanel(
            condition = "input.step_through == false && input.viz_mode != 'Event-locked single event'",
            uiOutput("id_select_ui")
          ),

          conditionalPanel(
            condition = "input.step_through == true",
            fluidRow(
              column(6, actionButton("prev_id", "Previous Participant",
                                     title = "Previous Participant (← Left Arrow)", icon = icon("arrow-left"))),
              column(6, actionButton("next_id", "Next Participant",
                                     title = "Next Participant (→ Right Arrow)", icon = icon("arrow-right")))
            ),
            textOutput("current_participant")
          )
        ),

        # Event-level controls
        conditionalPanel(
          condition = "input.viz_mode == 'Event-locked single event'",
          hr(),
          fluidRow(
            column(6, actionButton("prev_event", "Previous Event")),
            column(6, actionButton("next_event", "Next Event"))
          ),
          textOutput("current_event"),
          textOutput("event_onset_time")
        ),

        hr(),

        conditionalPanel(
          condition = "input.viz_mode == 'Raw time series'",
          uiOutput("var_ui"),
          selectInput("plot_type", "Plot type", c("Line", "Scatter"))
        ),

        conditionalPanel(
          condition = "input.viz_mode == 'Event + Continuous Overlay'",
          uiOutput("overlay_ui")
        ),

        conditionalPanel(
          condition = "input.viz_mode == 'Event durations (barcode)'",
          uiOutput("barcode_ui")
        ),

        conditionalPanel(
          condition = "input.viz_mode == 'Event-locked average' || input.viz_mode == 'Event-locked single event'",
          uiOutput("event_ui"),
          numericInput("pre", "Seconds before event", 5, min = 1),
          numericInput("post", "Seconds after event", 5, min = 1)
        ),

        conditionalPanel(
          condition = "input.viz_mode == 'Event-locked average'",
          checkboxInput(
            "overlay_events",
            "Overlay individual events",
            FALSE
          ),
          checkboxInput(
            "show_se_ribbon",
            "Show SE ribbon",
            FALSE
          )
        ),
        # Custom labels dropdown
        tags$div(class = "panel panel-default", style = "margin-bottom: 10px;",
                 tags$div(class = "panel-heading", style = "padding: 8px 12px; background-color: #f8f9fa;",
                          tags$a(id = "labels-toggle", href = "#", style = "text-decoration: none; color: #333;",
                                 icon("tags"), " Add Custom Labels ",
                                 tags$span(id = "labels-caret", class = "caret")
                          )
                 ),
                 tags$div(id = "labels-dropdown", style = "display: none; padding: 10px;",
                          textInput("custom_title", "Plot Title", placeholder = "Auto-generated"),
                          textInput("custom_xlab", "X-Axis Label", placeholder = "Variable name"),
                          textInput("custom_ylab", "Y-Axis Label", placeholder = "Variable name"),
                          conditionalPanel(
                            condition = "input.viz_mode == 'Raw time series' || input.viz_mode == 'Event + Continuous Overlay'",
                            textInput("custom_legend", "Legend Title", placeholder = "Auto-generated")
                          ) )),

        hr(),
        h4("Second Plot (Optional)"),
        checkboxInput("show_second_plot", "Show second plot below main plot", FALSE),

        conditionalPanel(
          condition = "input.show_second_plot == true",
          uiOutput("second_plot_ui")
        ),
      ),
      shinyjs::hidden(textInput("sidebar_state", "", value = "data"))
    ),

    mainPanel(
      conditionalPanel(
        condition = "input.sidebar_state == 'viz'",
        tags$div(id = "plot-description", class = "help-text",
                 style = "margin-bottom: 15px; padding: 10px; background-color: #f8f9fa; border-left: 4px solid #007bff; border-radius: 4px; display: none;",
                 textOutput("plot_description"))
      ),

      plotly::plotlyOutput("plot", height = "550px"),

      conditionalPanel(
        condition = "input.show_second_plot == true",
        tags$div(class = "help-text",
                 style = "margin-top: 15px; margin-bottom: 15px; padding: 10px; background-color: #f8f9fa; border-left: 4px solid #007bff; border-radius: 4px; display: none;",
                 textOutput("plot2_description")),

        plotly::plotlyOutput("plot2", height = "400px")
      ),

      uiOutput("stats_section")
    )
  )
)


server <- function(input, output, session){
  # Store main plot, secondary plot, and stats for saving
  plot_store  <- reactiveVal(NULL)
  plot2_store <- reactiveVal(NULL)
  stats_store <- reactiveVal(NULL)

  last_data_source <- reactiveVal("demo")  # default to demo

  last_data_source <- reactiveVal("demo")

  # File upload wins when a new file is chosen
  observeEvent(input$file, {
    last_data_source("file")
    updateSelectInput(session, "demo_choice", selected = "")
  }, ignoreInit = TRUE)

  # Demo wins when a new demo is chosen
  observeEvent(input$demo_choice, {
    if (isTruthy(input$demo_choice) && input$demo_choice != "") {
      last_data_source("demo")
    }
  }, ignoreInit = FALSE)  # FALSE here so demo1 loads on startup

  file_is_newer <- reactive({
    last_data_source() == "file"
  })

  accessibility <- reactiveValues(
    high_contrast   = FALSE,
    large_text      = FALSE,
    colorblind_safe = FALSE,
    large_targets   = FALSE,
    reduce_motion   = FALSE,
    sticky_controls = FALSE,
    simplified_ui   = FALSE,
    show_descriptions = FALSE,
    confirm_actions = FALSE
  )
  # Helper function to save plotly as PNG
  save_plotly_png <- function(p, file, width = 1200, height = 700) {
    # Method 1: Try orca/kaleido via plotly
    success <- tryCatch({
      plotly::save_image(p, file, width = width, height = height)
      file.exists(file)
    }, error = function(e) {
      message("save_image failed: ", e$message)
      FALSE
    })

    if (isTRUE(success)) return(invisible(file))

    # Method 2: Try webshot2
    success <- tryCatch({
      tmpdir <- tempfile()
      dir.create(tmpdir)
      tmphtml <- file.path(tmpdir, "plot.html")

      htmlwidgets::saveWidget(
        widget = p,
        file = tmphtml,
        selfcontained = TRUE
      )

      webshot2::webshot(
        url = tmphtml,
        file = file,
        vwidth = width,
        vheight = height,
        delay = 1,
        cliprect = "viewport"
      )

      unlink(tmpdir, recursive = TRUE)
      file.exists(file)
    }, error = function(e) {
      message("webshot2 failed: ", e$message)
      FALSE
    })

    if (isTRUE(success)) return(invisible(file))

    stop("PNG export failed. Please install kaleido (reticulate::py_install('kaleido')) or Chrome for webshot2.")
  }



  # Helper function to get font sizes based on accessibility settings
  get_plot_fonts <- function() {
    if (isTRUE(accessibility$large_text)) {
      list(title_size = 24, axis_title_size = 20, axis_text_size = 16, legend_size = 16)
    } else {
      list(title_size = 16, axis_title_size = 14, axis_text_size = 12, legend_size = 12)
    }
  }

  # Helper function to get plot margins based on accessibility settings
  get_plot_margins <- function() {
    if (isTRUE(accessibility$large_text)) {
      list(t = 80, b = 60, l = 60, r = 40)
    } else {
      list(t = 50, b = 50, l = 50, r = 40)
    }
  }

  # Accessibility Settings Management
  accessibility_css <- reactiveVal("")

  show_confirmation <- function(message, action_id) {
    if (isTRUE(accessibility$confirm_actions)) {
      showModal(modalDialog(
        title = "Confirm Action",
        message,
        footer = tagList(
          modalButton("Cancel"),
          actionButton(paste0("confirm_", action_id), "Confirm", class = "btn-primary")
        )
      ))
      return(FALSE)
    }
    return(TRUE)
  }

  # Get current plot selection for descriptive stats
  visible_range <- reactive({
    relayout <- input$plot_relayout

    # If no zoom has happened or axis was reset, return NULL (show all data)
    if (is.null(relayout)) return(NULL)

    x_min <- relayout[["xaxis.range[0]"]]
    x_max <- relayout[["xaxis.range[1]"]]

    # autorange means the user reset/unzoomed
    if (!is.null(relayout[["xaxis.autorange"]]) &&
        isTRUE(relayout[["xaxis.autorange"]])) return(NULL)

    if (is.null(x_min) || is.null(x_max)) return(NULL)

    list(min = x_min, max = x_max)
  })

  # Update CSS based on accessibility settings
  observeEvent(
    list(accessibility$high_contrast, accessibility$large_text, accessibility$colorblind_safe,
         accessibility$large_targets, accessibility$reduce_motion, accessibility$sticky_controls,
         accessibility$simplified_ui, accessibility$show_descriptions, accessibility$confirm_actions), {
    css_rules <- ""

    # High Contrast Mode
    if (isTRUE(accessibility$high_contrast)) {
      css_rules <- paste0(css_rules, "
      body { background-color: #000000 !important; color: #ffffff !important; }
      .well { background-color: #1a1a1a !important; color: #ffffff !important; border: 2px solid #ffffff !important; }
      .form-control { background-color: #2d2d2d !important; color: #ffffff !important; border: 2px solid #ffffff !important; }
      .btn-primary { background-color: #ffff00 !important; color: #000000 !important; border: 2px solid #000000 !important; }
      .btn-success { background-color: #00ff00 !important; color: #000000 !important; }
      .panel { background-color: #1a1a1a !important; border: 2px solid #ffffff !important; }
      .selectize-input { background-color: #2d2d2d !important; color: #ffffff !important; }
    ")
    }

    # Large Text
    if (isTRUE(accessibility$large_text)) {
      css_rules <- paste0(css_rules, "
    body { font-size: 18px !important; }
    .form-control { font-size: 16px !important; }
    h1 { font-size: 3rem !important; }
    h4 { font-size: 1.8rem !important; }
    h5 { font-size: 1.5rem !important; }
    h6 { font-size: 1.3rem !important; }
    .plotly .gtitle { font-size: 24px !important; }
    .plotly .xtitle { font-size: 20px !important; }
    .plotly .ytitle { font-size: 20px !important; }
    .plotly .legend { font-size: 16px !important; }
    .plotly .tick text { font-size: 14px !important; }

    /* Fix button and accessibility text */
    .btn { font-size: 16px !important; }
    .toolbar { font-size: 16px !important; }
    .toolbar .btn { font-size: 16px !important; }
    .dropdown-menu { font-size: 16px !important; }
    .checkbox label { font-size: 16px !important; }
    #current_participant { font-size: 18px !important; }
    #current_event { font-size: 18px !important; }

    #plot-description {
      margin-bottom: 25px !important;
      padding: 12px !important;
      line-height: 1.6 !important;
      font-size: 18px !important;
    }
    .plotly {
      margin-top: 15px !important;
    }
  ")
    }

      # Large Click Targets
    if (isTRUE(accessibility$large_targets)) {
      css_rules <- paste0(css_rules, "
    .btn {
      min-height: 50px !important;
      min-width: 50px !important;
      font-size: 16px !important;
      padding: 12px 20px !important;
      margin: 5px 2px !important;
    }
    .form-control {
      min-height: 50px !important;
      font-size: 16px !important;
      margin: 5px 0 !important;
    }
    .selectize-input {
      min-height: 50px !important;
      margin: 5px 0 !important;
    }
    .checkbox {
      margin: 15px 0 !important;
      padding-left: 30px !important;
    }
    .checkbox input[type='checkbox'] {
      transform: scale(1.5) !important;
      margin-right: 15px !important;
      margin-left: -30px !important;
      position: relative !important;
    }
    .checkbox label {
      margin-left: 10px !important;
      line-height: 24px !important;
    }
    .radio {
      margin: 15px 0 !important;
      padding-left: 30px !important;
    }
    .radio input[type='radio'] {
      transform: scale(1.5) !important;
      margin-right: 15px !important;
      margin-left: -30px !important;
      position: relative !important;
    }
    .radio label {
      margin-left: 10px !important;
      line-height: 24px !important;
    }
  ")
    }

    # Reduce Motion
    if (isTRUE(accessibility$reduce_motion)) {
      css_rules <- paste0(css_rules, "
      * { transition: none !important; animation: none !important; }
      .plotly .traces { transition: none !important; }
    ")
    }

    # Sticky Navigation
    if (isTRUE(accessibility$sticky_controls)) {
      css_rules <- paste0(css_rules, "
      .col-sm-4 { position: sticky !important; top: 20px !important; }
    ")
    }

    # Simplified UI - work in progress
    if (isTRUE(accessibility$simplified_ui)) {
      css_rules <- paste0(css_rules, "
    .well { border: 3px solid #007bff !important; }
  ")
    }

    # Extra Descriptions
    if (isTRUE(accessibility$show_descriptions)) {
      css_rules <- paste0(css_rules, "
    .help-text {
      display: block !important;
      font-weight: bold !important;
      background-color: #e7f3ff !important;
      padding: 8px !important;
      border-radius: 4px !important;
      margin-top: 5px !important;
      border-left: 3px solid #007bff !important;
    }
  ")
    } else {
      css_rules <- paste0(css_rules, "
    .help-text { display: none !important; }
  ")
    }

    accessibility_css(css_rules)
  })

  # Apply CSS to page
  observeEvent(accessibility_css(), {
    shinyjs::runjs(sprintf("document.getElementById('accessibility-styles').innerHTML = `%s`;", accessibility_css()))
  }, ignoreInit = TRUE)


  # Sync toolbar accessibility controls with main controls
  observeEvent(input$high_contrast,      { accessibility$high_contrast     <- input$high_contrast })
  observeEvent(input$large_text,         { accessibility$large_text        <- input$large_text })
  observeEvent(input$colorblind_safe,    { accessibility$colorblind_safe   <- input$colorblind_safe })
  observeEvent(input$large_targets,      { accessibility$large_targets     <- input$large_targets })
  observeEvent(input$reduce_motion,      { accessibility$reduce_motion     <- input$reduce_motion })
  observeEvent(input$sticky_controls,    { accessibility$sticky_controls   <- input$sticky_controls })
  observeEvent(input$simplified_ui,      { accessibility$simplified_ui     <- input$simplified_ui })
  observeEvent(input$show_descriptions,  { accessibility$show_descriptions <- input$show_descriptions })
  observeEvent(input$confirm_actions,    { accessibility$confirm_actions   <- input$confirm_actions })

  # Toolbar inputs write to shared state
  observeEvent(input$toolbar_high_contrast,     { accessibility$high_contrast     <- input$toolbar_high_contrast })
  observeEvent(input$toolbar_large_text,        { accessibility$large_text        <- input$toolbar_large_text })
  observeEvent(input$toolbar_colorblind_safe,   { accessibility$colorblind_safe   <- input$toolbar_colorblind_safe })
  observeEvent(input$toolbar_large_targets,     { accessibility$large_targets     <- input$toolbar_large_targets })
  observeEvent(input$toolbar_reduce_motion,     { accessibility$reduce_motion     <- input$toolbar_reduce_motion })
  observeEvent(input$toolbar_sticky_controls,   { accessibility$sticky_controls   <- input$toolbar_sticky_controls })
  observeEvent(input$toolbar_simplified_ui,     { accessibility$simplified_ui     <- input$toolbar_simplified_ui })
  observeEvent(input$toolbar_show_descriptions, { accessibility$show_descriptions <- input$toolbar_show_descriptions })
  observeEvent(input$toolbar_confirm_actions,   { accessibility$confirm_actions   <- input$toolbar_confirm_actions })

  # Shared state syncs both UIs
  observe({
    updateCheckboxInput(session, "high_contrast",              value = accessibility$high_contrast)
    updateCheckboxInput(session, "toolbar_high_contrast",      value = accessibility$high_contrast)
    updateCheckboxInput(session, "large_text",                 value = accessibility$large_text)
    updateCheckboxInput(session, "toolbar_large_text",         value = accessibility$large_text)
    updateCheckboxInput(session, "colorblind_safe",            value = accessibility$colorblind_safe)
    updateCheckboxInput(session, "toolbar_colorblind_safe",    value = accessibility$colorblind_safe)
    updateCheckboxInput(session, "large_targets",              value = accessibility$large_targets)
    updateCheckboxInput(session, "toolbar_large_targets",      value = accessibility$large_targets)
    updateCheckboxInput(session, "reduce_motion",              value = accessibility$reduce_motion)
    updateCheckboxInput(session, "toolbar_reduce_motion",      value = accessibility$reduce_motion)
    updateCheckboxInput(session, "sticky_controls",            value = accessibility$sticky_controls)
    updateCheckboxInput(session, "toolbar_sticky_controls",    value = accessibility$sticky_controls)
    updateCheckboxInput(session, "simplified_ui",              value = accessibility$simplified_ui)
    updateCheckboxInput(session, "toolbar_simplified_ui",      value = accessibility$simplified_ui)
    updateCheckboxInput(session, "show_descriptions",          value = accessibility$show_descriptions)
    updateCheckboxInput(session, "toolbar_show_descriptions",  value = accessibility$show_descriptions)
    updateCheckboxInput(session, "confirm_actions",            value = accessibility$confirm_actions)
    updateCheckboxInput(session, "toolbar_confirm_actions",    value = accessibility$confirm_actions)
  })

  observeEvent(list(input$preset_vision, input$toolbar_preset_vision), {
    req(input$preset_vision > 0 || input$toolbar_preset_vision > 0)
    accessibility$high_contrast   <- TRUE
    accessibility$large_text      <- TRUE
    accessibility$colorblind_safe <- TRUE
    accessibility$reduce_motion   <- TRUE
    showNotification("Vision preset applied", type = "message", duration = 5)
  }, ignoreInit = TRUE)

  observeEvent(list(input$preset_motor, input$toolbar_preset_motor), {
    req(input$preset_motor > 0 || input$toolbar_preset_motor > 0)
    accessibility$large_targets   <- TRUE
    accessibility$sticky_controls <- TRUE
    accessibility$reduce_motion   <- TRUE
    accessibility$confirm_actions <- TRUE
    showNotification("Motor preset applied", type = "message", duration = 5)
  }, ignoreInit = TRUE)

  observeEvent(list(input$reset_accessibility, input$toolbar_reset_accessibility), {
    req(input$reset_accessibility > 0 || input$toolbar_reset_accessibility > 0)
    accessibility$high_contrast     <- FALSE
    accessibility$large_text        <- FALSE
    accessibility$colorblind_safe   <- FALSE
    accessibility$large_targets     <- FALSE
    accessibility$reduce_motion     <- FALSE
    accessibility$sticky_controls   <- FALSE
    accessibility$simplified_ui     <- FALSE
    accessibility$show_descriptions <- FALSE
    accessibility$confirm_actions   <- FALSE
    showNotification("All accessibility settings reset", type = "message", duration = 3)
  }, ignoreInit = TRUE)

  # Colorblind-safe palette generator
  get_accessible_palette <- function(n) {
    if (isTRUE(accessibility$colorblind_safe)) {
      colors <- c("#440154", "#31688e", "#35b779", "#fde725", "#ff6a00", "#c42503", "#a50026", "#762a83")
      if (n <= length(colors)) return(colors[1:n])
      return(colorRampPalette(colors)(n))
    } else {
      if (n <= 8) return(RColorBrewer::brewer.pal(max(3, n), "Set2")[1:n])
      return(colorRampPalette(RColorBrewer::brewer.pal(8, "Set2"))(n))
    }
  }
  # Sidebar navigation
  observeEvent(input$go_viz,{
    # Check if we have data
    if (is.null(data_reactive()) || nrow(data_reactive()) == 0) {
      showNotification("Please upload a data file before creating visualizations.",
                       type = "error", duration = 8)
      return()
    }

    # Check ID variable with better messaging
    if (input$use_id) {
      if (is.null(input$idvar) || input$idvar == "") {
        showNotification("Please select a participant ID variable to identify different participants in your data.",
                         type = "error", duration = 8)
        return()
      }

      err <- validate_id_variable(data_reactive(), input$idvar)
      if (!is.null(err)) {
        showNotification(paste("ID Variable Issue:", err,
                               "\n\nTip: Choose a column that has the same value for all rows belonging to the same participant."),
                         type = "error", duration = 12)
        return()
      }
    }

    updateTextInput(session, "sidebar_state", value = "viz")

    # Determine which visualizations are allowed based on data structure
    allowed_choices <- switch(input$data_structure,
                              "Continuous time series" = c("Raw time series"),
                              "Binary / event-coded"   = c("Event durations (barcode)"),
                              "Mixed (continuous + events)" = c(
                                "Raw time series",
                                "Event + Continuous Overlay",
                                "Event-locked average",
                                "Event-locked single event",
                                "Event durations (barcode)"
                              )
    )

    updateSelectInput(session, "viz_mode",
                      choices = allowed_choices,
                      selected = allowed_choices[1])
  })

  observeEvent(input$back_data,{
    updateTextInput(session,"sidebar_state",value="data")
  })

  output$hasData <- reactive({
    last_data_source() == "demo" && isTruthy(input$demo_choice) ||
      last_data_source() == "file" && !is.null(input$file)
  })
  outputOptions(output, "hasData", suspendWhenHidden = FALSE)
  # Store both original and converted data
  data_original <- reactive({

    df <- if (last_data_source() == "file") {
      req(input$file)
      readr::read_csv(input$file$datapath, show_col_types = FALSE)

    } else {
      req(isTruthy(input$demo_choice) && input$demo_choice != "")
      demo_file <- switch(input$demo_choice,
                          "demo1" = system.file("extdata", "demo_data_1.csv", package = "dora"),
                          "demo2" = system.file("extdata", "demo_data_2.csv", package = "dora"),
                          "demo3" = system.file("extdata", "demo_data_3.csv", package = "dora")
      )
      if (demo_file == "") stop("Demo file not found. Try reinstalling the package.")
      readr::read_csv(demo_file, show_col_types = FALSE)
    }

    # Datetime parsing unchanged
    for (col in names(df)) {
      if (is.character(df[[col]])) {
        if (any(grepl("\\d{4}-\\d{2}-\\d{2}", df[[col]][1:min(10, nrow(df))]), na.rm = TRUE) ||
            any(grepl("\\d{2}:\\d{2}:\\d{2}", df[[col]][1:min(10, nrow(df))]), na.rm = TRUE)) {
          parsed <- suppressWarnings(
            lubridate::parse_date_time(df[[col]],
                                       orders = c("ymd HMS", "ymd HM", "dmy HMS", "dmy HM",
                                                  "mdy HMS", "mdy HM", "HMS", "HM",
                                                  "ymd", "dmy", "mdy"),
                                       quiet = TRUE)
          )
          if (sum(!is.na(parsed)) > 0.5 * length(parsed)) {
            df[[col]] <- parsed
          }
        }
      }
    }
    df
  }) |> bindCache(input$file$datapath) # check on exactly what this does - got idea from https://engineering-shiny.org/optimizing-shiny-code.html

  data_converted <- reactiveVal(NULL)
  conversion_done <- reactiveVal(FALSE)

  data_reactive <- reactive({
    if (conversion_done() && !is.null(data_converted())) {
      data_converted()
    } else {
      data_original()
    }
  })

  # observeEvent(input$file, {
  #   data_converted(NULL)
  #   conversion_done(FALSE)
  #   updateCheckboxInput(session, "is_interval_data", value = FALSE)
  # })
  observeEvent(list(input$demo_choice, input$file), {
    data_converted(NULL)
    conversion_done(FALSE)
    updateCheckboxInput(session, "is_interval_data", value = FALSE)
  })

  diagnostics <- reactive({
    df <- data_reactive()
    req(!is.null(df) && nrow(df) > 0)
    detect_dataset(df)
  }) #|> bindCache(data_reactive())

  # output$diagnostics <- renderPrint({
  #   d <- diagnostics()
  #   cat(
  #     "Rows:", d$n_rows, "\n",
  #     "Columns:", d$n_cols, "\n\n",
  #     "Numeric variables:\n", paste(d$numeric, collapse=", "), "\n\n",
  #     "Binary/event variables:\n", paste(d$binary, collapse=", "), "\n\n",
  #     "Candidate time variables:\n", paste(d$time, collapse=", ")
  #   )
  # })
  output$active_dataset_name <- renderText({
    if (last_data_source() == "file" && !is.null(input$file)) {
      paste("Currently using:", input$file$name)
    } else if (isTruthy(input$demo_choice) && input$demo_choice != "") {
      label <- switch(input$demo_choice,
                      "demo1" = "Infant Object Play",
                      "demo2" = "Daily Music Bouts",
                      "demo3" = "Mother-Child Interactions"
      )
      paste("Currently using:", label)
    } else {
      "No dataset selected"
    }
  })
  # Interval data conversion UI
  output$interval_conversion_ui <- renderUI({
    df <- data_reactive() #previously data_original() - does not update with new selection...
    all_vars <- names(df)

    tagList(
      radioButtons("interval_format", "Input Data Format:",
                   choices = c("Start Time + End Time" = "start_end",
                               "Start Time + Duration" = "start_dur"),
                   inline = TRUE),

      selectInput("start_time_col", "Start time column", all_vars),

      conditionalPanel(
        condition = "input.interval_format == 'start_end'",
        selectInput("end_time_col", "End time column", all_vars)
      ),

      conditionalPanel(
        condition = "input.interval_format == 'start_dur'",
        fluidRow(
          column(8, selectInput("duration_col", "Duration column", all_vars)),
          column(4, selectInput("duration_unit_input", "Unit",
                                choices = c("Seconds" = 1, "Minutes" = 60, "Hours" = 3600),
                                selected = 1))
        )
      ),

      #hr(),
      # Independent Participant control for this step
      checkboxInput("conv_has_id", "Dataset contains multiple participants", FALSE),

      conditionalPanel(
        condition = "input.conv_has_id",
        selectInput("conv_id_col", "Participant ID Variable", all_vars)
      ),

      selectInput("event_var_col", "Event/Activity variable", all_vars),
      numericInput("time_unit_val", "Output Time Step (resolution in seconds)", 1, min = 0.001, step = 0.1)
    )
  })

  output$conversion_status <- renderText({
    if (conversion_done()) {
      paste("✓ Data converted successfully! New dataset has", nrow(data_converted()), "rows.")
    } else {
      ""
    }
  })

  output$conversionDone <- reactive({ conversion_done() })
  outputOptions(output, "conversionDone", suspendWhenHidden = FALSE)
  output$download_converted <- downloadHandler(
    filename = function() {
      paste0("converted_data_", Sys.Date(), ".csv")
    },
    content = function(file) {
      df <- data_converted()
      if (is.null(df)) {
        write.csv(data.frame(Note = "No converted data available"), file, row.names = FALSE)
      } else {
        write.csv(df, file, row.names = FALSE)
      }
    }
  )
  do_convert <- function() {
    req(input$start_time_col, input$event_var_col, input$time_unit_val)

    if (input$interval_format == "start_end") req(input$end_time_col)
    if (input$interval_format == "start_dur") req(input$duration_col)

    # VALIDATION: Check ID variable if selected
    # Performed OUTSIDE tryCatch to ensure it stops execution visibly
    if (input$conv_has_id) {
      req(input$conv_id_col)
      df <- data_original()
      err <- validate_id_variable(df, input$conv_id_col)
      if (!is.null(err)) {
        showNotification(err, type = "error", duration = 10)
        return() # Stop conversion immediately
      }
    }

    tryCatch({
      df <- data_original()

      # PRE-PROCESSING FOR DURATION FORMAT
      target_end_col <- input$end_time_col

      if (input$interval_format == "start_dur") {
        s_time <- df[[input$start_time_col]]
        if (is.character(s_time)) {
          s_time <- parse_date_time(s_time, orders = c("ymd HMS", "ymd HM", "HMS", "HM", "ymd"), quiet = TRUE)
        }

        dur_val <- suppressWarnings(as.numeric(df[[input$duration_col]]))
        multiplier <- as.numeric(input$duration_unit_input)
        df$calculated_end_time <- s_time + (dur_val * multiplier)
        target_end_col <- "calculated_end_time"
        df[[input$start_time_col]] <- s_time
      }

      # STANDARD EXPANSION
      df_to_process <- df

      # Use the ID selection from THIS step (Step 1)
      if (input$conv_has_id && !is.null(input$conv_id_col)) {
        chosen_id <- input$conv_id_col
        # Auto-update Step 2 UI settings
        updateCheckboxInput(session, "use_id", value = TRUE)
      } else {
        df_to_process$temp_id <- 1
        chosen_id <- "temp_id"
        updateCheckboxInput(session, "use_id", value = FALSE)
      }

      converted <- expand_timeseries(
        data = df_to_process,
        id_var = chosen_id,
        var_name = input$event_var_col,
        start_time_var = input$start_time_col,
        end_time_var = target_end_col,
        time_unit = input$time_unit_val
      )

      data_converted(converted)
      conversion_done(TRUE)

    }, error = function(e) {
      # UPDATED ERROR MESSAGE HERE
      showNotification(
        paste0("Conversion Failed: ", e$message, "\n Please check your variable selections and try again."),
        type = "error",
        duration = 15
      )
    })
  }
  observeEvent(data_reactive(), {
    selected_time(NULL)
    selected_signal(NULL)
    selected_event(NULL)
  }, ignoreInit = TRUE)

  observeEvent(input$peek_data, {
    df <- data_reactive()
    showModal(modalDialog(
      title = paste("Data Preview —", nrow(df), "rows,", ncol(df), "columns"),
      size = "l",
      easyClose = TRUE,
      footer = modalButton("Close"),
      renderTable({
        head(df, 10)
      })
    ))
  })
  # Convert interval data
  observeEvent(input$convert_data, {
    if (!show_confirmation("This will convert your interval data to continuous format. Continue?", "convert")) {
      return()
    }
    do_convert()
  })

  observeEvent(input$confirm_convert, {
    removeModal()
    do_convert()
  })

  # Participant handling
  output$idvar_ui <- renderUI({
    df <- data_reactive()
    # FIX: Use isTRUE() to safely handle cases where the conversion UI (input$conv_has_id) is NULL/hidden
    sel <- if(isTRUE(input$conv_has_id) && !is.null(input$conv_id_col)) input$conv_id_col else NULL

    selectInput("idvar", "Participant ID variable", names(df), selected = sel)
  })

  all_ids <- reactive({
    req(input$idvar)
    unique(data_reactive()[[input$idvar]])
  })

  id_index <- reactiveVal(1)
  event_index <- reactiveVal(1)

  # Persistent variable selections
  selected_time <- reactiveVal(NULL)
  selected_signal <- reactiveVal(NULL)
  selected_event <- reactiveVal(NULL)

  observeEvent(input$viz_mode, {
    if (input$viz_mode == "Event-locked single event") {
      updateCheckboxInput(session, "step_through", value = TRUE)
    }
  })

  observeEvent(input$next_id,{
    id_index(ifelse(id_index() == length(all_ids()), 1, id_index() + 1))
    event_index(1)
  })
  observeEvent(input$prev_id,{
    id_index(ifelse(id_index() == 1, length(all_ids()), id_index() - 1))
    event_index(1)
  })

  observeEvent(input$next_event,{
    event_index(event_index() + 1)
  })
  observeEvent(input$prev_event,{
    event_index(max(1, event_index() - 1))
  })

  output$current_participant <- renderText({
    paste("Participant:", all_ids()[id_index()])
  })

  output$current_event <- renderText({
    paste("Event:", event_index())
  })

  output$event_onset_time <- renderText({
    req(input$viz_mode == "Event-locked single event")
    df <- data_reactive()

    if (isTRUE(input$use_id)) {
      df <- df[df[[input$idvar]] == all_ids()[id_index()], ]
    }

    req(input$event_var)
    windows <- extract_event_windows_idx(df[[input$event_var]])

    if (nrow(windows) > 0 && event_index() <= nrow(windows)) {
      d <- diagnostics()
      if (length(d$time) > 0) {
        time_var <- d$time[1]
        onset_time <- df[[time_var]][windows$start[event_index()]]

        if (inherits(onset_time, c("POSIXct", "POSIXt", "POSIXlt"))) {
          paste("Event onset time:", format(onset_time, "%Y-%m-%d %H:%M:%S"))
        } else if (is.numeric(onset_time)) {
          paste("Event onset time:", round(onset_time, 2), "seconds")
        } else {
          paste("Event onset time:", as.character(onset_time))
        }
      } else {
        paste("Event onset index:", windows$start[event_index()])
      }
    }
  })

  output$id_select_ui <- renderUI({
    selectInput(
      "selected_ids",
      "Select participant(s)",
      choices = all_ids(),
      selected = all_ids(),
      multiple = TRUE
    )
  })

  # Variable selection
  output$var_ui <- renderUI({
    data_reactive()
    d <- diagnostics()
    tagList(
      selectInput("xvar", "Time (x) variable", d$time, selected = selected_time()),
      selectInput("yvar", "Signal (y) variable", d$numeric, selected = selected_signal(), multiple = T)
    )
  })

  output$event_ui <- renderUI({
    data_reactive()
    d <- diagnostics()
    tagList(
      selectInput("event_var", "Event variable (0/1)", d$binary, selected = selected_event()),
      selectInput("signal_var", "Signal variable", d$numeric, selected = selected_signal())
    )
  })

  output$second_plot_ui <- renderUI({
    data_reactive()
    d <- diagnostics()

    tagList(
      selectInput("second_plot_type", "Second plot type",
                  c("Raw Variable" = "raw",
                    "Allan Factor (event data)" = "allan_factor",
                    "Allan Deviation (continuous)" = "allan_deviation")),

      # Raw variable selection
      conditionalPanel(
        condition = "input.second_plot_type == 'raw'",
        selectInput("second_yvar", "Variable", d$numeric, multiple = FALSE)
      ),

      # Allan Factor options
      conditionalPanel(
        condition = "input.second_plot_type == 'allan_factor'",
        selectInput("af_var", "Event variable (binary 0/1)", d$binary),
        numericInput("af_binwidth", "Bin width (seconds)", value = 1, min = 0.001, step = 0.1),
        numericInput("af_base", "Base", value = 4, min = 2, max = 10, step = 1),
        numericInput("af_powers", "Max power", value = 10, min = 3, max = 20, step = 1),
        numericInput("af_start", "Start power", value = 2, min = 1, max = 10, step = 1),
        checkboxInput("af_show_shuffled", "Show shuffled comparison", TRUE)
      ),

      # Allan Deviation options
      conditionalPanel(
        condition = "input.second_plot_type == 'allan_deviation'",
        selectInput("ad_var", "Continuous variable", d$numeric),
        numericInput("ad_rate", "Sampling rate (Hz)", value = 1, min = 0.001, step = 0.1),
        selectInput("ad_type", "Input type",
                    c("Frequency data" = "frequency",
                      "Phase data" = "phase")),
        checkboxInput("ad_show_variance", "Show variance instead of deviation", FALSE)
      )
    )
  })

  output$overlay_ui <- renderUI({
    data_reactive()
    d <- diagnostics()
    df <- data_reactive()

    # Identify categorical/event-like variables
    all_vars <- names(df)
    cat_vars <- all_vars[sapply(df, function(x) {
      is.factor(x) || is.character(x) ||
        (is.numeric(x) && length(unique(na.omit(x))) <= 20)
    })]

    tagList(
      selectInput("time_overlay", "Time variable", d$time, selected = selected_time()),
      selectInput("signal_overlay", "Continuous signal(s)", d$numeric, selected = selected_signal(), multiple = TRUE),

      # CHANGE: Added multiple = TRUE so you can pick "Freezing" AND "Tremor"
      selectInput("event_overlay", "Event variable(s)", cat_vars,
                  selected = selected_event(), multiple = TRUE)
    )
  })

  output$barcode_ui <- renderUI({
    data_reactive()
    d <- diagnostics()
    df <- data_reactive()

    all_vars <- names(df)
    cat_vars <- all_vars[sapply(df, function(x) {
      is.factor(x) || is.character(x) ||
        (is.numeric(x) && length(unique(na.omit(x))) <= 20)
    })]

    prev_sel <- selected_event()
    if (!is.null(prev_sel)) {
      valid_sel <- prev_sel[prev_sel %in% cat_vars]
      if (length(valid_sel) == 0) valid_sel <- NULL
    } else {
      valid_sel <- NULL
    }

    tagList(
      selectInput("barcode_time", "Time variable", d$time, selected = selected_time()),
      selectInput("barcode_var", "Event variable(s)", cat_vars,
                  selected = valid_sel, multiple = TRUE),
      radioButtons("barcode_layout", "Layout:",
                   choices = c("Stacked rows" = "stacked",
                               "Overlaid (single row)" = "overlay"),
                   selected = "stacked", inline = TRUE)
    )
  })

  observeEvent(input$xvar, { selected_time(input$xvar) }, ignoreNULL = TRUE)
  observeEvent(input$time_overlay, { selected_time(input$time_overlay) }, ignoreNULL = TRUE)
  observeEvent(input$barcode_time, { selected_time(input$barcode_time) }, ignoreNULL = TRUE)
  observeEvent(input$yvar, { selected_signal(input$yvar) }, ignoreNULL = TRUE)
  observeEvent(input$signal_var, { selected_signal(input$signal_var) }, ignoreNULL = TRUE)
  observeEvent(input$signal_overlay, { selected_signal(input$signal_overlay) }, ignoreNULL = TRUE)
  observeEvent(input$event_var, { selected_event(input$event_var) }, ignoreNULL = TRUE)
  observeEvent(input$event_overlay, { selected_event(input$event_overlay) }, ignoreNULL = TRUE)
  observeEvent(input$barcode_var, { selected_event(input$barcode_var) }, ignoreNULL = TRUE)
  filtered_data <- reactive({
    df <- data_reactive()
    if (!isTRUE(input$use_id)) return(df)
    req(input$idvar)
    if (isTRUE(input$step_through)) {
      df[df[[input$idvar]] == all_ids()[id_index()], ]
    } else {
      req(input$selected_ids)
      df[df[[input$idvar]] %in% input$selected_ids, ]
    }
  })
  # Plot
  output$plot <- plotly::renderPlotly({
    fonts <- get_plot_fonts()
    margins <- get_plot_margins()

    req(input$sidebar_state == "viz")
    validate(
      need(input$viz_mode, "Please select a visualization type"),
      need(data_reactive(), "Please upload data to create visualizations"),
      need(nrow(data_reactive()) > 0, "The uploaded data appears to be empty")
    )

    req(input$viz_mode)

    # Add mode-specific validation
    if (input$viz_mode == "Raw time series") {
      validate(
        need(input$xvar, "Please select a time variable (X-axis)"),
        need(input$yvar, "Please select at least one signal variable (Y-axis)")
      )
    }

    # This function grabs the user input or falls back to the default
    get_labels <- function(default_title, default_x, default_y, default_legend) {
      list(
        title = if(isTruthy(input$custom_title)) input$custom_title else default_title,
        x = if(isTruthy(input$custom_xlab)) input$custom_xlab else default_x,
        y = if(isTruthy(input$custom_ylab)) input$custom_ylab else default_y,
        legend = if(isTruthy(input$custom_legend)) input$custom_legend else default_legend
      )
    }

    # Raw time series
    if (input$viz_mode == "Raw time series") {
      req(input$xvar, input$yvar)
      is_single_view <- !isTRUE(input$use_id) || isTRUE(input$step_through)
      time_vec <- filtered_data()[[input$xvar]]
      # Get Labels
      labs <- get_labels(
        default_title = paste("Raw Time Series"),
        default_x = input$xvar,
        default_y = "Value",
        default_legend = if(is_single_view) "Variable" else "Participant"
      )

      p <- plotly::plot_ly()

      if (is_single_view) {
        for (var in input$yvar) {
          p <- plotly::add_trace(p, x = filtered_data()[[input$xvar]], y = filtered_data()[[var]], name = var,
                         type = "scatter", mode = ifelse(input$plot_type == "Line", "lines", "markers"))
        }
      } else {
        for (var in input$yvar) {
          p <- plotly::add_trace(p, x = filtered_data()[[input$xvar]], y = filtered_data()[[var]],
                         name = paste(filtered_data()[[input$idvar]], "-", var),
                         type = "scatter", mode = ifelse(input$plot_type == "Line", "lines", "markers"))
        }
      }

      p <- p |> plotly::layout(
        title = list(text = labs$title, font = list(size = fonts$title_size)),
        xaxis =  get_datetime_axis(time_vec, labs$x, fonts),
        yaxis = list(
          title = list(text = labs$y, font = list(size = fonts$axis_title_size)),
          tickfont = list(size = fonts$axis_text_size)
        ),
        legend = list(
          title = list(text = labs$legend, font = list(size = fonts$legend_size)),
          font = list(size = fonts$legend_size)
        ),
        margin = margins
      )
      plot_store(p)

      return(p)
    }

    # Event + Continuous Overlay
    if (input$viz_mode == "Event + Continuous Overlay") {
      req(input$time_overlay, input$signal_overlay, input$event_overlay)

      time_vec <- filtered_data()[[input$time_overlay]]

      # Calculate y-axis range for the rectangles
      all_vals <- unlist(lapply(input$signal_overlay, function(v) filtered_data()[[v]]))
      y_min <- min(all_vals, na.rm = TRUE)
      y_max <- max(all_vals, na.rm = TRUE)

      # We build a list of "targets" to plot.
      # Each target has: Column Name, Value to match, Color, and Label.

      plot_targets <- list()

      # Helper for colors - replace with colorblind friendly??
      get_palette <- function(n) {
        if(n <= 8) RColorBrewer::brewer.pal(max(3, n), "Set2")[1:n]
        else colorRampPalette(RColorBrewer::brewer.pal(8, "Set2"))(n)
      }

      # 1. Analyze selected columns to determine total colors needed
      total_items <- 0
      for(col in input$event_overlay){
        vals <- na.omit(unique(filtered_data()[[col]]))
        # If binary (0/1), we count it as 1 item (the "1" state)
        if(all(vals %in% c(0,1))) {
          total_items <- total_items + 1
        } else {
          # If categorical, we count the unique values (excluding 0)
          vals <- vals[vals != "0" & vals != 0]
          total_items <- total_items + length(vals)
        }
      }

      # 2. Generate Palette
      master_pal <- get_accessible_palette(total_items)
      color_idx <- 1

      # 3. Build Targets
      for(col in input$event_overlay){
        raw_vals <- filtered_data()[[col]]
        unique_vals <- unique(raw_vals[!is.na(raw_vals)])

        # Check if strictly binary 0/1
        is_binary <- all(unique_vals %in% c(0,1))

        if(is_binary) {
          # CASE: Binary Column (e.g. "Freezing") -> One color
          plot_targets[[length(plot_targets)+1]] <- list(
            col = col,
            val = 1,
            color = master_pal[color_idx],
            label = col # Label is just the column name
          )
          color_idx <- color_idx + 1
        } else {
          # CASE: Categorical Column (e.g. "Activity") -> Multiple colors
          unique_vals <- sort(unique_vals)
          unique_vals <- unique_vals[unique_vals != 0 & unique_vals != "0"]

          for(uv in unique_vals){
            plot_targets[[length(plot_targets)+1]] <- list(
              col = col,
              val = uv,
              color = master_pal[color_idx],
              label = paste(col, "-", uv) # Label is "Col - Value"
            )
            color_idx <- color_idx + 1
          }
        }
      }

      hex_to_rgba <- function(hex, alpha = 0.2) {
        rgb_vals <- col2rgb(hex)
        paste0("rgba(", rgb_vals[1], ",", rgb_vals[2], ",", rgb_vals[3], ",", alpha, ")")
      }

      shapes <- list()
      legend_traces <- list() # To store info for dummy legend entries

      for(target in plot_targets) {
        # Extract binary vector for this specific target
        vec <- filtered_data()[[target$col]]
        is_active <- vec == target$val
        # Handle NAs as false
        is_active[is.na(is_active)] <- FALSE
        is_active <- as.numeric(is_active)

        windows <- extract_event_windows_idx(is_active)

        if (nrow(windows) > 0) {
          rgba_col <- hex_to_rgba(target$color, alpha = 0.2)

          # Create rectangles
          for (i in seq_len(nrow(windows))) {
            shapes[[length(shapes) + 1]] <- list(
              type = "rect",
              x0 = time_vec[windows$start[i]],
              x1 = time_vec[windows$end[i]],
              y0 = y_min,
              y1 = y_max,
              fillcolor = rgba_col,
              line = list(width = 0),
              layer = "below"
            )
          }

          # Add to legend list (so we only add one legend entry per event type)
          legend_traces[[length(legend_traces)+1]] <- target
        }
      }

      # Get Labels
      labs <- get_labels(
        default_title = paste("Event Overlay"),
        default_x = input$time_overlay,
        default_y = "Value",
        default_legend = "Legend"
      )

      p <- plotly::plot_ly()

      # 1. Add Continuous Lines
      for (var in input$signal_overlay) {
        p <- plotly::add_trace(p, x = time_vec, y = filtered_data()[[var]], name = var, type = "scatter", mode = "lines")
      }

      # 2. Add Dummy Legend Entries
      for (tr in legend_traces) {
        p <- plotly::add_trace(p,
                       x = time_vec[1],
                       y = y_min,
                       type = "scatter",
                       mode = "markers",
                       marker = list(color = tr$color, symbol = "square"),
                       name = tr$label,
                       visible = "legendonly"
        )
      }



      p <- p |> plotly::layout(
        title = list(text = labs$title, font = list(size = fonts$title_size)),
        xaxis = get_datetime_axis(time_vec, labs$x, fonts),
        yaxis = list(
          title = list(text = labs$y, font = list(size = fonts$axis_title_size)),
          tickfont = list(size = fonts$axis_text_size)
        ),
        legend = list(
          title = list(text = labs$legend, font = list(size = fonts$legend_size)),
          font = list(size = fonts$legend_size)
        ),
        shapes = shapes,
        margin = margins
      )
      plot_store(p)
      return(p)
    }

    # Event-locked single event
    if (input$viz_mode == "Event-locked single event") {
      req(input$event_var, input$signal_var)
      windows <- extract_event_windows_idx(filtered_data()[[input$event_var]])
      req(nrow(windows) > 0)
      time_vec <- filtered_data()[[input$xvar]]
      i <- min(event_index(), nrow(windows))
      d <- diagnostics()
      time_vec <- filtered_data()[[input$xvar]]
      # Logic to extract time/y (kept same as before)
      x_vals <- NULL
      y_vals <- NULL

      if (length(d$time) > 0) {
        time_var <- d$time[1]
        time_vals <- filtered_data()[[time_var]]
        onset_time <- time_vals[windows$start[i]]
        win_idx <- (windows$start[i] - input$pre):(windows$start[i] + input$post)
        win_idx <- win_idx[win_idx > 0 & win_idx <= nrow(filtered_data())]
        y_vals <- filtered_data()[[input$signal_var]][win_idx]

        if (inherits(time_vals, c("POSIXct", "POSIXt", "POSIXlt"))) {
          x_vals <- as.numeric(difftime(time_vals[win_idx], onset_time, units = "secs"))
        } else {
          x_vals <- time_vals[win_idx] - onset_time
        }
      } else {
        win <- (-input$pre):input$post
        idx <- windows$start[i] + win
        idx <- idx[idx > 0 & idx <= nrow(filtered_data())]
        y_vals <- filtered_data()[[input$signal_var]][idx]
        x_vals <- win[seq_along(y_vals)]
      }

      # Get Labels
      labs <- get_labels(
        default_title = paste("Event", i, "Trajectory"),
        default_x = "Time relative to event (s)",
        default_y = input$signal_var,
        default_legend = ""
      )
      p <- plotly::plot_ly(x = x_vals, y = y_vals, type = "scatter", mode = "lines", name = "Trajectory")



      return(
        p |>
          plotly::layout(
            title = list(text = labs$title, font = list(size = fonts$title_size)),
            xaxis =  get_datetime_axis(time_vec, labs$x, fonts),
            yaxis = list(
              title = list(text = labs$y, font = list(size = fonts$axis_title_size)),
              tickfont = list(size = fonts$axis_text_size)
            ),
            legend = list(
              title = list(text = labs$legend, font = list(size = fonts$legend_size)),
              font = list(size = fonts$legend_size)
            ),
            margin = margins,
            shapes = list(list(type = "line", x0=0, x1=0, y0=0, y1=1, yref="paper", line=list(color="red", dash="dash")))
          )
      )
    }
    # Event-locked average
    if (input$viz_mode == "Event-locked average") {
      req(input$event_var, input$signal_var)
      windows <- extract_event_windows_idx(filtered_data()[[input$event_var]])
      req(nrow(windows) > 0)

      win <- (-input$pre):input$post
      extract_event <- function(i){
        idx <- windows$start[i] + win
        idx <- idx[idx > 0 & idx <= nrow(filtered_data())]
        filtered_data()[[input$signal_var]][idx]
      }
      mat <- do.call(rbind, lapply(seq_len(nrow(windows)), extract_event))
      avg <- colMeans(mat, na.rm = TRUE)

      # Get Labels
      labs <- get_labels(
        default_title = paste("Average Trajectory:", input$event_var),
        default_x = "Time relative to event",
        default_y = input$signal_var,
        default_legend = ""
      )

      p <- plotly::plot_ly(x = win, y = avg, type = "scatter", mode = "lines",
                   name = "Mean", line = list(width = 3, color = "blue"))

      # SE ribbon
      if (isTRUE(input$show_se_ribbon)) {
        n_events <- nrow(mat)
        se <- apply(mat, 2, sd, na.rm = TRUE) / sqrt(n_events)
        upper <- avg + se
        lower <- avg - se

        # Upper bound (invisible line, serves as ribbon top)
        p <- plotly::add_trace(p,
                       x = win, y = upper,
                       type = "scatter", mode = "lines",
                       line = list(color = "transparent"),
                       showlegend = FALSE,
                       name = "Upper SE"
        )

        # Lower bound with fill to the upper trace
        p <- plotly::add_trace(p,
                       x = win, y = lower,
                       type = "scatter", mode = "lines",
                       fill = "tonexty",
                       fillcolor = "rgba(0, 0, 255, 0.15)",
                       line = list(color = "transparent"),
                       showlegend = TRUE,
                       name = "± 1 SE"
        )
      }

      # Overlay individual events
      if (isTRUE(input$overlay_events)) {
        for (i in seq_len(nrow(mat))) {
          p <- add_lines(p, x = win, y = mat[i, ],
                         opacity = 0.3, line = list(color = "gray"),
                         showlegend = FALSE)
        }
      }
      fonts <- get_plot_fonts()
      margins <- get_plot_margins()
      p <- p |> plotly::layout(
        title = list(text = labs$title, font = list(size = fonts$title_size)),
        xaxis = list(
          title = list(text = labs$x, font = list(size = fonts$axis_title_size)),
          tickfont = list(size = fonts$axis_text_size)
        ),
        yaxis = list(
          title = list(text = labs$y, font = list(size = fonts$axis_title_size)),
          tickfont = list(size = fonts$axis_text_size)
        ),
        legend = list(
          title = list(text = labs$legend, font = list(size = fonts$legend_size)),
          font = list(size = fonts$legend_size)
        ),
        margin = margins
      )
      plot_store(p)

      return(p)
    }

    # event durations (barcode)
    if (input$viz_mode == "Event durations (barcode)") {
      req(input$barcode_time, input$barcode_var)

      event_cols <- input$barcode_var
      time_col <- input$barcode_time

      df_clean <- filtered_data()[!is.na(filtered_data()[[time_col]]), ]
      req(nrow(df_clean) > 0)

      time_vec <- df_clean[[time_col]]

      # If the column came in as character or factor, try to parse it
      if (is.character(time_vec) || is.factor(time_vec)) {
        time_vec_char <- as.character(time_vec)
        parsed <- tryCatch(
          lubridate::parse_date_time(time_vec_char, orders = c(
            "ymd HMS", "ymd HM", "ymd",
            "mdy HMS", "mdy HM", "mdy",
            "dmy HMS", "dmy HM", "dmy",
            "ymd_HMS", "ymd_HM",
            "HMS", "HM"
          ), quiet = TRUE),
          error = function(e) NULL
        )
        if (!is.null(parsed) && sum(!is.na(parsed)) > 0.5 * length(parsed)) {
          time_vec <- parsed
        }
      }

      # If the column is numeric and looks like Unix epoch seconds, convert
      if (is.numeric(time_vec) && !inherits(time_vec, c("POSIXct", "POSIXt", "Date"))) {
        rng <- range(time_vec, na.rm = TRUE)
        if (rng[1] > 9e8 && rng[2] < 2.5e9) {
          time_vec <- as.POSIXct(time_vec, origin = "1970-01-01", tz = "UTC")
        }
      }

      is_datetime <- inherits(time_vec, c("POSIXct", "POSIXt", "Date"))

      if (is_datetime) {
        numeric_time <- as.numeric(time_vec)

        # Detect overnight wraps: if time jumps backwards by more than
        # a small tolerance, assume a day boundary was crossed
        diffs <- diff(numeric_time)
        wrap_indices <- which(diffs < -60)

        if (length(wrap_indices) > 0) {
          offset <- rep(0, length(numeric_time))
          for (wi in wrap_indices) {
            offset[(wi + 1):length(offset)] <- offset[(wi + 1):length(offset)] + 86400
          }
          numeric_time <- numeric_time + offset
          tv_tz <- attr(time_vec, "tzone")
          if (is.null(tv_tz)) tv_tz <- "UTC"
          time_vec_plot <- as.POSIXct(numeric_time, origin = "1970-01-01", tz = tv_tz)
        } else {
          time_vec_plot <- time_vec
        }

        x_positions <- time_vec_plot
      } else {
        x_positions <- seq_len(nrow(df_clean))
      }

      plot_targets <- list()

      for (col in event_cols) {
        col_data <- df_clean[[col]]
        unique_vals <- sort(unique(col_data[!is.na(col_data)]))
        is_binary <- all(unique_vals %in% c(0, 1))

        if (is_binary) {
          plot_targets[[length(plot_targets) + 1]] <- list(
            col = col, val = 1, label = col, is_binary = TRUE
          )
        } else {
          for (uv in unique_vals) {
            if (uv != 0 & uv != "0") {
              plot_targets[[length(plot_targets) + 1]] <- list(
                col = col, val = uv,
                label = if (length(event_cols) > 1) paste(col, "-", uv) else as.character(uv),
                is_binary = FALSE
              )
            }
          }
        }
      }

      n_targets <- length(plot_targets)
      req(n_targets > 0)

      pal <- get_accessible_palette(n_targets)

      use_stacked <- isTRUE(input$barcode_layout == "stacked") && n_targets > 1

      hex_to_rgba <- function(hex, alpha = 0.3) {
        rgb_vals <- col2rgb(hex)
        paste0("rgba(", rgb_vals[1], ",", rgb_vals[2], ",", rgb_vals[3], ",", alpha, ")")
      }

      p <- plotly::plot_ly()

      if (use_stacked) {
        row_height <- 1 / n_targets

        for (t_idx in seq_along(plot_targets)) {
          target <- plot_targets[[t_idx]]
          col_data <- df_clean[[target$col]]
          active_idx <- which(col_data == target$val)

          if (length(active_idx) == 0) next

          y_bottom <- 1 - (t_idx * row_height)
          y_top <- 1 - ((t_idx - 1) * row_height)
          y_gap <- row_height * 0.05
          y_bottom <- y_bottom + y_gap
          y_top <- y_top - y_gap

          # Use datetime or numeric x-positions
          active_x <- x_positions[active_idx]
          n_events <- length(active_x)

          x_vals <- rep(active_x, each = 3)
          y_vals <- rep(c(y_bottom, y_top, NA), times = n_events)

          # Build hover text
          if (is_datetime) {
            hover_text <- rep(paste0(target$label, "<br>",
                                     format(time_vec[active_idx], "%Y-%m-%d %H:%M:%S")), each = 3)
          } else {
            hover_text <- rep(paste0(target$label, "<br>", time_vec[active_idx]), each = 3)
          }

          p <- plotly::add_trace(p,
                         x = x_vals, y = y_vals,
                         type = "scatter", mode = "lines",
                         line = list(color = pal[t_idx], width = 1),
                         name = target$label,
                         showlegend = TRUE,
                         hoverinfo = "text",
                         text = hover_text
          )
        }

        tick_vals_y <- sapply(seq_along(plot_targets), function(i) {
          y_bottom <- 1 - (i * row_height)
          y_top <- 1 - ((i - 1) * row_height)
          (y_bottom + y_top) / 2
        })
        tick_labels_y <- sapply(plot_targets, function(t) t$label)

        y_axis_config <- list(
          title = list(text = ""),
          range = c(0, 1),
          showgrid = FALSE,
          zeroline = FALSE,
          tickmode = "array",
          tickvals = tick_vals_y,
          ticktext = tick_labels_y,
          tickfont = list(size = fonts$axis_text_size)
        )

      } else {
        for (t_idx in seq_along(plot_targets)) {
          target <- plot_targets[[t_idx]]
          col_data <- df_clean[[target$col]]
          active_idx <- which(col_data == target$val)

          if (length(active_idx) == 0) next

          # Use datetime or numeric x-positions
          active_x <- x_positions[active_idx]
          n_events <- length(active_x)

          x_vals <- rep(active_x, each = 3)
          y_vals <- rep(c(0, 1, NA), times = n_events)

          if (is_datetime) {
            hover_text <- rep(paste0(target$label, "<br>",
                                     format(time_vec[active_idx], "%Y-%m-%d %H:%M:%S")), each = 3)
          } else {
            hover_text <- rep(paste0(target$label, "<br>", time_vec[active_idx]), each = 3)
          }

          p <- plotly::add_trace(p,
                         x = x_vals, y = y_vals,
                         type = "scatter", mode = "lines",
                         line = list(color = hex_to_rgba(pal[t_idx], 0.5), width = 1),
                         name = target$label,
                         showlegend = TRUE,
                         hoverinfo = "text",
                         text = hover_text
          )
        }

        y_axis_config <- list(
          title = list(text = ""),
          range = c(0, 1),
          showgrid = FALSE,
          zeroline = FALSE,
          showticklabels = FALSE
        )
      }

      labs <- get_labels(
        default_title = paste("Event Barcode:", paste(event_cols, collapse = ", ")),
        default_x = time_col,
        default_y = "",
        default_legend = "Events"
      )



      if (use_stacked) margins$l <- max(margins$l, 80)
      margins$b <- max(margins$b, 80)

      if (is_datetime) {
        time_range_secs <- as.numeric(difftime(
          max(x_positions, na.rm = TRUE),
          min(x_positions, na.rm = TRUE),
          units = "secs"
        ))

        if (time_range_secs < 3600) {
          tick_fmt <- "%H:%M:%S"
        } else if (time_range_secs < 86400) {
          tick_fmt <- "%H:%M"
        } else {
          tick_fmt <- "%m-%d %H:%M"
        }

        x_axis_config <- list(
          title = list(text = labs$x, font = list(size = fonts$axis_title_size)),
          tickfont  = list(size = fonts$axis_text_size),
          type      = "date",
          tickformat = tick_fmt,
          nticks    = 10,
          tickangle = -45
        )
      } else {
        x_axis_config <- list(
          title = list(text = labs$x, font = list(size = fonts$axis_title_size)),
          tickfont = list(size = fonts$axis_text_size)
        )
      }
      p <- p |> plotly::layout(
        title = list(text = labs$title, font = list(size = fonts$title_size)),
        xaxis = x_axis_config,
        yaxis = y_axis_config,
        legend = list(
          title = list(text = labs$legend, font = list(size = fonts$legend_size)),
          font = list(size = fonts$legend_size)
        ),
        margin = margins
      )

      plot_store(p)
      return(p)
    }
  })

  # Dynamic stats section container
  output$stats_section <- renderUI({
    req(input$viz_mode)
    should_show <- FALSE

    if (input$viz_mode == "Raw time series") {
      if (isTruthy(input$yvar)) should_show <- TRUE
    } else if (input$viz_mode == "Event durations (barcode)") {
      if (isTruthy(input$barcode_var)) should_show <- TRUE
    } else if (input$viz_mode == "Event + Continuous Overlay") {
      if (isTruthy(input$signal_overlay) && isTruthy(input$event_overlay)) should_show <- TRUE
    } else if (grepl("Event-locked", input$viz_mode)) {
      if (isTruthy(input$signal_var)) should_show <- TRUE
    }

    if (should_show) {
      tagList(hr(), h4("Descriptive Statistics"), verbatimTextOutput("desc_stats"))
    } else {
      NULL
    }
  })

  # Descriptive statistics
  output$desc_stats <- renderPrint({
      req(input$viz_mode)
      df <- data_reactive()
      ids_to_process <- list()

      # Determine which IDs to process
      if (isTRUE(input$use_id)) {
        req(input$idvar)
        if (isTRUE(input$step_through)) {
          ids_to_process <- all_ids()[id_index()]
        } else {
          ids_to_process <- input$selected_ids
        }
      } else {
        ids_to_process <- "All Data"
        df$temp_id <- "All Data"
      }

      id_col <- if (isTRUE(input$use_id)) input$idvar else "temp_id"

      # Filter for current plot
      range <- visible_range()
      zoom_active <- !is.null(range)
      range_label <- NULL

      if (zoom_active) {
        # Determine which time column to filter on
        time_col <- switch(input$viz_mode,
                           "Raw time series"            = input$xvar,
                           "Event + Continuous Overlay" = input$time_overlay,
                           "Event durations (barcode)"  = input$barcode_time,
                           diagnostics()$time[1]  # fallback for event-locked modes
        )
        if (!is.null(time_col) && time_col %in% names(df)) {
          time_vals <- df[[time_col]]

          # Handle both datetime and numeric x values from plotly
          if (inherits(time_vals, c("POSIXct", "POSIXt"))) {
            x_min <- as.POSIXct(as.numeric(range$min) / 1000, origin = "1970-01-01", tz = "UTC")
            x_max <- as.POSIXct(as.numeric(range$max) / 1000, origin = "1970-01-01", tz = "UTC")
            df <- df[!is.na(time_vals) & time_vals >= x_min & time_vals <= x_max, ]
            range_label <- paste("From", format(x_min, "%H:%M:%S"),
                                 "to", format(x_max, "%H:%M:%S"))
          } else {
            x_min <- as.numeric(range$min)
            x_max <- as.numeric(range$max)
            df <- df[!is.na(time_vals) & time_vals >= x_min & time_vals <= x_max, ]
            range_label <- paste("From", round(x_min, 2), "to", round(x_max, 2), "seconds")
          }
        }
      }
      # Initialize variables to hold selection names
      cont_vars <- NULL
      event_vars <- NULL
      calc_type <- NULL

      # 1. Determine Calculation Type based on Viz Mode
      if (input$viz_mode == "Event + Continuous Overlay") {
        req(input$signal_overlay, input$event_overlay)
        cont_vars <- input$signal_overlay
        event_vars <- input$event_overlay
        calc_type <- "both"

      } else if (input$viz_mode == "Raw time series") {
        req(input$yvar)
        cont_vars <- input$yvar
        calc_type <- "continuous"

      } else if (input$viz_mode == "Event durations (barcode)") {
        req(input$barcode_var)
        event_vars <- input$barcode_var
        calc_type <- "event"

      } else if (grepl("Event-locked", input$viz_mode)) {
        req(input$signal_var)
        cont_vars <- input$signal_var
        calc_type <- "continuous"
      }

      if (is.null(calc_type) || length(ids_to_process) == 0) {
        cat("No statistics available for this view.")
        return()
      }
      txt <- capture.output({
      # 2. Print General Header
      cat(paste(rep("=", 60), collapse = ""), "\n")
      if (calc_type == "both") {
        cat("  Comparison: Continuous Signals vs Event Variables\n")
      } else if (calc_type == "continuous") {
        cat("  Continuous Signal Statistics\n")
      } else if (calc_type == "event") {
        cat("  Event Statistics (Burstiness)\n")
      }
      cat(paste(rep("=", 60), collapse = ""), "\n\n")

      # 3. Loop through Participants
      for (id in ids_to_process) {
        sub_df <- df[df[[id_col]] == id, ]

        cat(paste("Participant:", id, "\n"))
        cat(paste(rep("-", 40), collapse = ""), "\n")

        if (calc_type == "both") {

          # NESTED LOOPS: Loop through every selected Event AND every selected Signal
          for(e_var in event_vars) {

            # Calculate Event Stats for this specific event variable
            e_vals <- sub_df[[e_var]]

            # Check if strictly binary (0/1) or categorical
            unique_e <- unique(na.omit(e_vals))
            is_binary <- all(unique_e %in% c(0, 1))

            b_str <- "N/A"
            note_str <- ""

            if(is_binary) {
              b <- get_burstiness(e_vals)
              b_str <- if(is.na(b)) "NA" else sprintf("%.4f", b)
              note_str <- ""
            } else {
              clean_vals <- e_vals[e_vals != 0 & e_vals != "0"]
              n_types <- length(unique(na.omit(clean_vals)))
              note_str <- paste("(Categorical:", n_types, "types)")
            }

            # Pair with continuous variables
            for(c_var in cont_vars) {
              c_vals <- sub_df[[c_var]]
              m <- mean(c_vals, na.rm = TRUE)
              s <- sd(c_vals, na.rm = TRUE)

              cat(sprintf("Signal: %-25s Event: %-20s\n", c_var, e_var))
              cat(sprintf("  Mean: %-24.4f  Burstiness: %s\n", m, b_str))
              cat(sprintf("  SD:   %-24.4f %s\n", s, note_str))
              cat("\n")
            }
          }

        } else if (calc_type == "continuous") {

          for (var_name in cont_vars) {
            vals <- sub_df[[var_name]]
            m <- mean(vals, na.rm = TRUE)
            s <- sd(vals, na.rm = TRUE)

            cat(paste("  Variable:", var_name, "\n"))
            cat(sprintf("    Mean: %.4f,  SD: %.4f\n", m, s))
          }
          cat("\n")

        } else if (calc_type == "event") {

          for(e_var in event_vars){
            vals <- sub_df[[e_var]]
            b <- get_burstiness(vals)

            cat(paste("  Variable:", e_var, "\n"))

            if (is.na(b)) {
              clean_vals <- na.omit(vals)
              if (!all(unique(clean_vals) %in% c(0, 1))) {
                cat("    Burstiness: NA (Categorical/Multiclass)\n")
              } else if (sum(clean_vals == 1) < 2) {
                cat("    Burstiness: NA (<2 events detected)\n")
              } else {
                cat("    Burstiness: NA\n")
              }
            } else {
              cat(sprintf("    Burstiness: %.4f\n", b))
            }
          }
          cat("\n")
        }
      }

    })

      lines <- character(0)
      lines <- c(lines, paste(rep("=", 60), collapse = ""))

      if (zoom_active && !is.null(range_label)) {
        lines <- c(lines, paste(" Showing zoomed view:", range_label))
        lines <- c(lines, paste(rep("=", 60), collapse = ""))
      } else {
        lines <- c(lines, " Showing full dataset")
        lines <- c(lines, paste(rep("=", 60), collapse = ""))
      }
      stats_store(paste(txt, collapse = "\n"))
      cat(txt, sep = "\n")
  })

  output$plot2 <- plotly::renderPlotly({
    req(input$show_second_plot)
    req(input$second_plot_type)

    df <- data_reactive()

    # Apply ID filtering
    if (isTRUE(input$use_id)) {
      req(input$idvar)
      if (isTRUE(input$step_through)) {
        df <- df[df[[input$idvar]] == all_ids()[id_index()], ]
      } else {
        df <- df[df[[input$idvar]] %in% input$selected_ids, ]
      }
    }

    fonts <- get_plot_fonts()
    margins <- get_plot_margins()

    # additional time series
    if (input$second_plot_type == "raw") {
      req(input$second_yvar)
      labs <- get_labels(
        default_title = paste("Raw Time Series"),
        default_x = input$xvar,
        default_y = "Value",
        default_legend = if(is_single_view) "Variable" else "Participant"
      )

      time_var <- selected_time()
      req(time_var)
      time_vec <- df[[input$xvar]]
      p2 <- plotly::plot_ly(df, x = df[[time_var]], y = df[[input$second_yvar]],
                    type = "scatter", mode = "lines",
                    name = input$second_yvar)

      p2 <- p2 |> plotly::layout(
        title = list(text = paste("Secondary Plot:", input$second_yvar), font = list(size = fonts$title_size)),
        xaxis = get_datetime_axis(time_vec, labs$x, fonts),
        yaxis = list(
          title = list(text = input$second_yvar, font = list(size = fonts$axis_title_size)),
          tickfont = list(size = fonts$axis_text_size)
        ),
        margin = margins
      )

      plot2_store(p2)
      return(p2)
    }

    # Allan factor
    if (input$second_plot_type == "allan_factor") {
      req(input$af_var, input$af_binwidth, input$af_base, input$af_powers, input$af_start)

      event_data <- df[[input$af_var]]
      req(length(event_data) > 0)

      validate(
        need(all(na.omit(unique(event_data)) %in% c(0, 1)),
             "Allan Factor requires binary (0/1) event data"),
        # need(input$af_base^input$af_start >= 10,
        #      "base^start must be >= 10"),
        need(input$af_base^input$af_powers < length(event_data),
             paste0("base^powers must be < data length (", length(event_data), "). Try reducing max power to ",
                    floor(log(length(event_data)) / log(input$af_base))))
      )

      if (input$af_base^input$af_start < 10) {
        showNotification(
          "Warning: base^start < 10. Allan Factor estimates may be unreliable at small divisions.",
          type = "warning", duration = 5
        )
      }
      af_result <- compute_allan_factor_curve(
        fin = event_data,
        binwidth = input$af_binwidth,
        base = input$af_base,
        powers = input$af_powers,
        start = input$af_start,
        include_shuffled = isTRUE(input$af_show_shuffled)
      )

      validate(need(!is.null(af_result) && length(af_result$actual) > 0,
                    "Could not compute Allan Factor. Try adjusting parameters."))

      # Build plot
      p2 <- plotly::plot_ly()

      p2 <- plotly::add_trace(p2,
                      x = af_result$abcis, y = af_result$actual,
                      type = "scatter", mode = "lines+markers",
                      name = "Actual",
                      line = list(color = "red"),
                      marker = list(color = "red", symbol = "circle")
      )

      if (isTRUE(input$af_show_shuffled) && !is.null(af_result$shuffled)) {
        p2 <- plotly::add_trace(p2,
                        x = af_result$abcis_shuffled, y = af_result$shuffled,
                        type = "scatter", mode = "lines+markers",
                        name = "Shuffled",
                        line = list(color = "blue", dash = "dash"),
                        marker = list(color = "blue", symbol = "triangle-up")
        )
      }

      # Add reference line at AF = 1
      p2 <- plotly::add_trace(p2,
                      x = range(af_result$abcis), y = c(1, 1),
                      type = "scatter", mode = "lines",
                      name = "AF = 1 (Poisson)",
                      line = list(color = "gray", dash = "dot", width = 1),
                      showlegend = TRUE
      )

      slope_text <- if (!is.null(af_result$slope)) {
        "Allan Factor"
        #paste0("Allan Factor (slope = ", round(af_result$slope, 3), ")")
      } else {
        "Allan Factor"
      }

      # Generate clean tick values based on data range
      x_range <- range(af_result$abcis, na.rm = TRUE)
      y_all <- af_result$actual
      if (isTRUE(input$af_show_shuffled) && !is.null(af_result$shuffled)) {
        y_all <- c(y_all, af_result$shuffled)
      }
      y_range <- range(y_all, na.rm = TRUE)

      # Generate log-spaced tick values for x-axis
      x_log_min <- floor(log10(x_range[1]))
      x_log_max <- ceiling(log10(x_range[2]))
      x_ticks <- unlist(lapply(x_log_min:x_log_max, function(p) {
        c(1, 3) * 10^p
      }))
      x_ticks <- x_ticks[x_ticks >= x_range[1] * 0.5 & x_ticks <= x_range[2] * 2]

      # Generate log-spaced tick values for y-axis
      y_log_min <- floor(log10(max(y_range[1], 0.1)))
      y_log_max <- ceiling(log10(y_range[2]))
      y_ticks <- unlist(lapply(y_log_min:y_log_max, function(p) {
        c(1, 3) * 10^p
      }))
      y_ticks <- y_ticks[y_ticks >= y_range[1] * 0.5 & y_ticks <= y_range[2] * 2]
      # Always include 1 for reference
      if (!1 %in% y_ticks) y_ticks <- sort(c(y_ticks, 1))

      p2 <- p2 |> plotly::layout(
        title = list(text = slope_text, font = list(size = fonts$title_size)),
        xaxis = list(
          title = list(text = "Window Size T (sec)", font = list(size = fonts$axis_title_size)),
          tickfont = list(size = fonts$axis_text_size),
          type = "log",
          tickmode = "array",
          tickvals = x_ticks,
          ticktext = as.character(x_ticks),
          showgrid = TRUE,
          gridcolor = "lightgray",
          gridwidth = 0.5,
          dtick = NULL
        ),
        yaxis = list(
          title = list(text = "Allan Factor A(T)", font = list(size = fonts$axis_title_size)),
          tickfont = list(size = fonts$axis_text_size),
          type = "log",
          tickmode = "array",
          tickvals = y_ticks,
          ticktext = as.character(y_ticks),
          showgrid = TRUE,
          gridcolor = "lightgray",
          gridwidth = 0.5,
          dtick = NULL
        ),
        legend = list(font = list(size = fonts$legend_size)),
        margin = margins,
        plot_bgcolor = "white"
      )

      plot2_store(p2)
      return(p2)
    }

    # Allan deviation
    if (input$second_plot_type == "allan_deviation") {
      req(input$ad_var, input$ad_rate, input$ad_type)

      cont_data <- df[[input$ad_var]]
      req(length(cont_data) > 10)

      ad_result <- compute_allan_deviation(
        data = cont_data,
        rate = input$ad_rate,
        type = input$ad_type
      )

      validate(need(nrow(ad_result) > 0,
                    "Could not compute Allan Deviation. Try adjusting parameters."))

      # Choose y-axis: deviation or variance
      if (isTRUE(input$ad_show_variance)) {
        y_vals <- ad_result$adev^2
        y_label <- "Allan Variance"
        plot_title <- paste("Allan Variance:", input$ad_var)
      } else {
        y_vals <- ad_result$adev
        y_label <- "Allan Deviation"
        plot_title <- paste("Allan Deviation:", input$ad_var)
      }

      p2 <- plotly::plot_ly()

      p2 <- plotly::add_trace(p2,
                      x = ad_result$tau, y = y_vals,
                      type = "scatter", mode = "lines+markers",
                      name = y_label,
                      line = list(color = "blue"),
                      marker = list(color = "blue", symbol = "circle")
      )

      p2 <- p2 |> plotly::layout(
        title = list(text = plot_title, font = list(size = fonts$title_size)),
        xaxis = list(
          title = list(text = "Tau (s)", font = list(size = fonts$axis_title_size)),
          tickfont = list(size = fonts$axis_text_size),
          type = "log"
        ),
        yaxis = list(
          title = list(text = y_label, font = list(size = fonts$axis_title_size)),
          tickfont = list(size = fonts$axis_text_size),
          type = "log"
        ),
        legend = list(font = list(size = fonts$legend_size)),
        margin = margins
      )

      plot2_store(p2)
      return(p2)
    }
  })

  # Generate accessible plot descriptions
output$plot_description <- renderText({
  req(input$sidebar_state == "viz")
  req(input$viz_mode)

  # Build description based on current plot
  desc <- switch(input$viz_mode,

    "Raw time series" = {
      if (!is.null(input$xvar) && !is.null(input$yvar)) {
        n_vars <- length(input$yvar)
        var_text <- if (n_vars == 1) input$yvar[1] else paste(n_vars, "variables")
        paste("Line plot showing", var_text, "over", input$xvar, "for",
              ifelse(isTRUE(input$use_id) && !isTRUE(input$step_through),
                     length(input$selected_ids), 1), "participant(s)")
      } else {
        "Raw time series plot - select variables to view description"
      }
    },

    "Event + Continuous Overlay" = {
      if (!is.null(input$signal_overlay) && !is.null(input$event_overlay)) {
        paste("Overlay plot combining", length(input$signal_overlay), "continuous signal(s) with",
              length(input$event_overlay), "event type(s) over", input$time_overlay)
      } else {
        "Event overlay plot - select signals and events to view description"
      }
    },

    "Event durations (barcode)" = {
      if (!is.null(input$barcode_var)) {
        paste("Barcode plot showing event durations and patterns for", input$barcode_var,
              "over", input$barcode_time)
      } else {
        "Event barcode plot - select variables to view description"
      }
    },

    "Event-locked average" = {
      if (!is.null(input$event_var) && !is.null(input$signal_var)) {
        paste("Average response of", input$signal_var, "around", input$event_var, "events,",
              input$pre, "seconds before to", input$post, "seconds after event onset")
      } else {
        "Event-locked average - select event and signal variables to view description"
      }
    },

    "Event-locked single event" = {
      if (!is.null(input$event_var) && !is.null(input$signal_var)) {
        paste("Single event view of", input$signal_var, "around one", input$event_var, "event")
      } else {
        "Single event view - select variables to view description"
      }
    },

    "Select a visualization type to see plot description"
  )

  paste("Plot Description:", desc)
})

# Description for second plot
output$plot2_description <- renderText({
  req(input$show_second_plot, input$second_plot_type)

  desc <- switch(input$second_plot_type,
                 "raw" = paste("📈 Secondary Plot: Line plot showing", input$second_yvar, "over time"),
                 "allan_factor" = paste("📈 Allan Factor: Log-log plot of Allan Factor A(T) vs window size T for",
                                        input$af_var,
                                        "- slope > 0 indicates fractal/bursty temporal structure"),
                 "allan_deviation" = paste("📈 Allan Deviation: Log-log plot of",
                                           if(isTRUE(input$ad_show_variance)) "Allan Variance" else "Allan Deviation",
                                           "vs tau for", input$ad_var)
  )

  desc
})

# Main Plot - HTML
output$toolbar_download_plot_html <- downloadHandler(
  filename = function() {
    paste0("plot_", Sys.Date(), ".html")
  },
  content = function(file) {
    p <- plot_store()
    # Convert to pure plotly widget (strips Shiny bindings)
    p <- plotly::as_widget(p)
    tmpfile <- tempfile(fileext = ".html")
    htmlwidgets::saveWidget(p, tmpfile, selfcontained = TRUE)
    file.copy(tmpfile, file, overwrite = TRUE)
    unlink(tmpfile)
  }
)

output$toolbar_download_plot_png <- downloadHandler(
  filename = function() {
    paste0("plot_", Sys.Date(), ".png")
  },
  content = function(file) {
    p <- isolate(plot_store())

    if (is.null(p)) {
      showNotification("No plot available to save.", type = "error")
      # Create a blank placeholder
      png(file, width = 800, height = 600)
      plot.new()
      text(0.5, 0.5, "No plot available", cex = 2)
      dev.off()
      return()
    }

    # Rebuild a clean plotly object from the stored data
    p_clean <- plotly::plotly_build(p)

    # Try saving as PNG
    tryCatch({
      save_plotly_png(p_clean, file)
    }, error = function(e) {
      message("PNG method failed, trying ggplot fallback: ", e$message)

      # Last resort fallback: use plotly's built-in export
      tryCatch({
        tmphtml <- tempfile(fileext = ".html")
        htmlwidgets::saveWidget(plotly::as_widget(p), tmphtml, selfcontained = TRUE)
        webshot2::webshot(tmphtml, file, vwidth = 1200, vheight = 700, delay = 1)
        unlink(tmphtml)
      }, error = function(e2) {
        showNotification(
          paste("PNG export failed:", e2$message,
                "\nTry installing kaleido: reticulate::py_install('kaleido')"),
          type = "error", duration = 10
        )
        # Create error image
        png(file, width = 800, height = 600)
        plot.new()
        text(0.5, 0.5, "Export failed - see console", cex = 1.5)
        dev.off()
      })
    })
  }
)

# Stats - Text File
output$toolbar_download_stats_txt <- downloadHandler(
  filename = function() {
    paste0("stats_", Sys.Date(), ".txt")
  },
  content = function(file) {
    stats_text <- stats_store()
    if (is.null(stats_text) || stats_text == "") {
      stats_text <- "No descriptive statistics available. Please generate a plot first."
    }
    writeLines(stats_text, file)
  }
)

# Stats - CSV File
output$toolbar_download_stats_csv <- downloadHandler(
  filename = function() {
    paste0("stats_", Sys.Date(), ".csv")
  },
  content = function(file) {
    df <- data_reactive()

    # Build stats dataframe based on current viz mode
    stats_df <- tryCatch({

      ids_to_process <- NULL

      if (isTRUE(input$use_id)) {
        id_col <- input$idvar
        if (isTRUE(input$step_through)) {
          ids_to_process <- all_ids()[id_index()]
        } else {
          ids_to_process <- input$selected_ids
        }
      } else {
        df$temp_id <- "All Data"
        id_col <- "temp_id"
        ids_to_process <- "All Data"
      }

      results <- data.frame()

      for (id in ids_to_process) {
        sub_df <- df[df[[id_col]] == id, ]

        if (input$viz_mode == "Raw time series" && !is.null(input$yvar)) {
          for (var_name in input$yvar) {
            vals <- sub_df[[var_name]]
            results <- rbind(results, data.frame(
              Participant = id,
              Variable = var_name,
              Type = "Continuous",
              Mean = round(mean(vals, na.rm = TRUE), 4),
              SD = round(sd(vals, na.rm = TRUE), 4),
              Min = round(min(vals, na.rm = TRUE), 4),
              Max = round(max(vals, na.rm = TRUE), 4),
              Burstiness = NA,
              stringsAsFactors = FALSE
            ))
          }

        } else if (input$viz_mode == "Event + Continuous Overlay") {
          for (c_var in input$signal_overlay) {
            c_vals <- sub_df[[c_var]]
            for (e_var in input$event_overlay) {
              e_vals <- sub_df[[e_var]]
              b <- get_burstiness(e_vals)
              results <- rbind(results, data.frame(
                Participant = id,
                Variable = paste(c_var, "+", e_var),
                Type = "Overlay",
                Mean = round(mean(c_vals, na.rm = TRUE), 4),
                SD = round(sd(c_vals, na.rm = TRUE), 4),
                Min = round(min(c_vals, na.rm = TRUE), 4),
                Max = round(max(c_vals, na.rm = TRUE), 4),
                Burstiness = if (!is.na(b)) round(b, 4) else NA,
                stringsAsFactors = FALSE
              ))
            }
          }

        } else if (input$viz_mode == "Event durations (barcode)" && !is.null(input$barcode_var)) {
          vals <- sub_df[[input$barcode_var]]
          b <- get_burstiness(vals)
          results <- rbind(results, data.frame(
            Participant = id,
            Variable = input$barcode_var,
            Type = "Event",
            Mean = NA,
            SD = NA,
            Min = NA,
            Max = NA,
            Burstiness = if (!is.na(b)) round(b, 4) else NA,
            stringsAsFactors = FALSE
          ))

        } else if (grepl("Event-locked", input$viz_mode) && !is.null(input$signal_var)) {
          vals <- sub_df[[input$signal_var]]
          results <- rbind(results, data.frame(
            Participant = id,
            Variable = input$signal_var,
            Type = "Continuous",
            Mean = round(mean(vals, na.rm = TRUE), 4),
            SD = round(sd(vals, na.rm = TRUE), 4),
            Min = round(min(vals, na.rm = TRUE), 4),
            Max = round(max(vals, na.rm = TRUE), 4),
            Burstiness = NA,
            stringsAsFactors = FALSE
          ))
        }
      }

      results

    }, error = function(e) {
      data.frame(
        Note = "Could not generate statistics. Please ensure a plot is displayed.",
        stringsAsFactors = FALSE
      )
    })

    write.csv(stats_df, file, row.names = FALSE)
  }
)

# Save Everything - ZIP
output$toolbar_download_all <- downloadHandler(
  filename = function() {
    paste0("all_outputs_", Sys.Date(), ".zip")
  },
  content = function(zipfile) {
    tmpdir <- tempdir()
    files_to_zip <- c()

    p1 <- isolate(plot_store())

    if (!is.null(p1)) {
      main_html <- file.path(tmpdir, "main_plot.html")
      p1_widget <- plotly::as_widget(p1)
      htmlwidgets::saveWidget(p1_widget, main_html, selfcontained = TRUE)
      files_to_zip <- c(files_to_zip, main_html)

      main_png <- file.path(tmpdir, "main_plot.png")
      tryCatch({
        p1_built <- plotly::plotly_build(p1)
        save_plotly_png(p1_built, main_png)
        files_to_zip <- c(files_to_zip, main_png)
      }, error = function(e) {
        message("Main PNG failed: ", e$message)
      })
    }

    if (isTRUE(input$show_second_plot)) {
      p2 <- isolate(plot2_store())
      if (!is.null(p2)) {
        second_html <- file.path(tmpdir, "second_plot.html")
        p2_widget <- plotly::as_widget(p2)
        htmlwidgets::saveWidget(p2_widget, second_html, selfcontained = TRUE)
        files_to_zip <- c(files_to_zip, second_html)

        second_png <- file.path(tmpdir, "second_plot.png")
        tryCatch({
          p2_built <- plotly::plotly_build(p2)
          save_plotly_png(p2_built, second_png)
          files_to_zip <- c(files_to_zip, second_png)
        }, error = function(e) {
          message("Second PNG failed: ", e$message)
        })
      }
    }

    stats_text <- isolate(stats_store())
    if (!is.null(stats_text) && stats_text != "") {
      stats_txt <- file.path(tmpdir, "stats.txt")
      writeLines(stats_text, stats_txt)
      files_to_zip <- c(files_to_zip, stats_txt)
    }

    stats_csv <- file.path(tmpdir, "stats.csv")
    tryCatch({
      df <- data_reactive()
      ids_to_process <- NULL

      if (isTRUE(input$use_id)) {
        id_col <- input$idvar
        if (isTRUE(input$step_through)) {
          ids_to_process <- all_ids()[id_index()]
        } else {
          ids_to_process <- input$selected_ids
        }
      } else {
        df$temp_id <- "All Data"
        id_col <- "temp_id"
        ids_to_process <- "All Data"
      }

      results <- data.frame()
      for (id in ids_to_process) {
        sub_df <- df[df[[id_col]] == id, ]
        if (input$viz_mode == "Raw time series" && !is.null(input$yvar)) {
          for (var_name in input$yvar) {
            vals <- sub_df[[var_name]]
            results <- rbind(results, data.frame(
              Participant = id,
              Variable = var_name,
              Mean = round(mean(vals, na.rm = TRUE), 4),
              SD = round(sd(vals, na.rm = TRUE), 4),
              Min = round(min(vals, na.rm = TRUE), 4),
              Max = round(max(vals, na.rm = TRUE), 4),
              stringsAsFactors = FALSE
            ))
          }
        }
      }
      if (nrow(results) > 0) {
        write.csv(results, stats_csv, row.names = FALSE)
        files_to_zip <- c(files_to_zip, stats_csv)
      }
    }, error = function(e) {})

    zip::zipr(zipfile, files_to_zip)
  }
)
}

shinyApp(ui, server)
