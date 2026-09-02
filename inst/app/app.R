options(shiny.maxRequestSize = 100*1024^2)

ui <- shiny::fluidPage(
  tags$head(
    tags$meta(
      name = "viewport",
      content = "width=device-width, initial-scale=1"
    ),
    tags$title("Time Series Explorer - Accessible Data Visualization"),
    includeCSS("www/styles.css"),
    includeCSS("www/accessibility.css"),
    includeScript("www/accessibility.js"),
    includeScript("www/app.js"),
    tags$script(
      src = "https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"
    )
  ),
  shinyjs::useShinyjs(),

  titlePanel("Data Organization and Rhythm Analysis"),

  # Sticky Toolbar (Top Toolbar)
  tags$div(id = "sticky-toolbar", class = "toolbar sticky-toolbar",

           # Left side - Back button
           tags$div(conditionalPanel(
             condition = "input.sidebar_state == 'viz'",
             actionButton("back_data", "← Back to Data Options",
                          class = "btn btn-outline-secondary", accesskey = "b",
                          title = "Back to Data Options (Alt+B)")
           )
           ),

           # accessibility
           tags$div(
             id = "toolbar-accessibility",
             style = paste(
               "flex: 1;",
               "text-align: center;",
               "overflow: visible;"
             ),

             tags$div(
               class = "btn-group",
               style = "position: relative;",

               tags$button(
                 id = "accessibility-dropdown-btn",
                 class = "btn btn-outline-info btn-sm accessibility-dropdown-btn",
                 type = "button",
                 `aria-haspopup` = "true",
                 `aria-expanded` = "false",
                 title = "Accessibility Settings (Alt+A)",
                 icon("universal-access"),
                 " Accessibility Settings ",
                 tags$span(class = "caret")
               ),

               tags$div(
                 id = "accessibility-dropdown-menu",
                 style = paste(
                   "display: none;",
                   "position: absolute;",
                   "left: 50%;",
                   "top: 100%;",
                   "transform: translateX(-50%);",
                   "width: 600px;",
                   "max-width: calc(100vw - 32px);",
                   "background: white;",
                   "border: 1px solid #ddd;",
                   "border-radius: 6px;",
                   "box-shadow: 0 4px 12px rgba(0,0,0,0.15);",
                   "z-index: 2000;",
                   "padding: 15px;",
                   "text-align: left;"
                 ),

                 fluidRow(
                   column(
                     4,
                     tags$h6(
                       "Visual",
                       style = "font-weight: bold; margin-bottom: 10px;"
                     ),
                     checkboxInput(
                       "high_contrast",
                       "High Contrast",
                       FALSE
                     ),
                     checkboxInput(
                       "large_text",
                       "Large Text",
                       FALSE
                     )
                   ),

                   column(
                     4,
                     tags$h6(
                       "Motor",
                       style = "font-weight: bold; margin-bottom: 10px;"
                     ),
                     checkboxInput(
                       "large_targets",
                       "Large Targets",
                       FALSE
                     ),
                     checkboxInput(
                       "reduce_motion",
                       "Reduce Motion",
                       FALSE
                     )
                   ),

                   column(
                     4,
                     tags$h6(
                       "Cognitive",
                       style = "font-weight: bold; margin-bottom: 10px;"
                     ),
                     checkboxInput(
                       "simplified_ui",
                       "Simplified UI",
                       FALSE
                     ),
                     checkboxInput(
                       "show_descriptions",
                       "Extra Help",
                       FALSE
                     ),
                     checkboxInput(
                       "confirm_actions",
                       "Confirm Actions",
                       FALSE
                     )
                   )
                 ),

                 tags$hr(),

                 fluidRow(
                   column(
                     6,
                     actionButton(
                       "preset_vision",
                       "Vision Preset",
                       class = "btn-sm btn-outline-primary",
                       style = "width: 100%;"
                     ),
                     br(),
                     br(),
                     actionButton(
                       "preset_motor",
                       "Motor Preset",
                       class = "btn-sm btn-outline-primary",
                       style = "width: 100%;"
                     )
                   ),

                   column(
                     6,
                     actionButton(
                       "reset_accessibility",
                       "Reset All",
                       class = "btn-sm btn-outline-secondary",
                       style = "width: 100%;"
                     )
                   )
                 )
               )
             )
           ),

           # Tools menu
           tags$div(
             style = "padding: 0px 10px 0px 0px;",
             tags$div(
               class = "btn-group",
               tags$button(
                 id = "tools-dropdown-btn",
                 class = "btn btn-outline-secondary dropdown-toggle",
                 type = "button",
                 title = "Tools",
                 icon("gear"), " Tools ", tags$span(class = "caret")
               ),
               tags$div(
                 id = "tools-dropdown-menu",
                 style = "display: none; position: absolute; right: 0; top: 100%;
               min-width: 240px; background: white; border: 1px solid #ddd;
               border-radius: 6px; box-shadow: 0 4px 12px rgba(0,0,0,0.15);
               z-index: 2000; padding: 8px 0;",

                 tags$a(
                   id = "open-converter-tool",
                   href = "#",
                   style = "display: block; padding: 9px 16px; color: #333;
           text-decoration: none; font-size: 14px;",
                   icon("right-left"), " Data Converter"
                 ),

                 tags$hr(style = "margin: 4px 0;"),

                 tags$a(
                   id = "open-structure-checker",
                   href = "#",
                   style = "display: block; padding: 9px 16px; color: #333;
           text-decoration: none; font-size: 14px;",
                   icon("magnifying-glass-chart"), " Dataset Structure Checker"
                 ),

                 tags$a(
                   id = "open-template-tool",
                   href = "#",
                   style = "display: block; padding: 9px 16px; color: #333;
           text-decoration: none; font-size: 14px;",
                   icon("file-csv"), " Download Data Templates"
                 ),

                 tags$a(
                   id = "open-missing-tool",
                   href = "#",
                   style = "display: block; padding: 9px 16px; color: #333;
           text-decoration: none; font-size: 14px;",
                   icon("circle-exclamation"), " Missing Data Inspector"
                 ),

                 tags$a(
                   id = "open-participant-summary",
                   href = "#",
                   style = "display: block; padding: 9px 16px; color: #333;
           text-decoration: none; font-size: 14px;",
                   icon("users"), " Participant / Visit Summary"
                 ),

                 tags$a(
                   id = "open-event-summary",
                   href = "#",
                   style = "display: block; padding: 9px 16px; color: #333;
           text-decoration: none; font-size: 14px;",
                   icon("bars-progress"), " Event Summary"
                 ),

                 tags$hr(style = "margin: 4px 0;"),

                 tags$a(
                   id = "download_quality_report",
                   href = "",
                   class = "shiny-download-link",
                   download = "",
                   target = "_blank",
                   style = "display: block; padding: 9px 16px; color: #333;
           text-decoration: none; font-size: 14px;",
                   icon("file-lines"), " Download Data Quality Report"
                 )
               )
             )
           ),

           # Save menu
           # Right side - Save menu
           tags$div(style ="padding: 0px 10px 0px 0px;",
                    conditionalPanel(
                      condition = "input.sidebar_state == 'viz'",
                      tags$div(class = "btn-group",
                               tags$button(id = "save-dropdown-btn", class = "btn btn-success dropdown-toggle",
                                           type = "button",
                                           title = "Save plots (Ctrl+S)",
                                           icon("download"), " Save ", tags$span(class = "caret")),
                               tags$div(id = "save-dropdown-menu", style = "display: none; position: absolute; right: 0; top: 100%;
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
                                        tags$div(style = "margin-bottom: 5px;",
                                                 actionButton("download_plot_png", "Static Image (PNG)",
                                                              class = "btn btn-outline-primary btn-sm",
                                                              style = "width: 100%; display: block; text-align: center;")
                                        ),
                                        tags$div(style = "margin-bottom: 10px;",
                                                 actionButton("download_plot_svg", "Vector Image (SVG)",
                                                              class = "btn btn-outline-secondary btn-sm",
                                                              style = "width: 100%; display: block; text-align: center;")
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
                    )
           ),
           # Help button
           tags$div(style ="padding: 0px 0px 0px 0px;",
                    tags$div(class = "btn-group",
                             tags$button(id = "help-dropdown-btn",
                                         class = "btn btn-sm",
                                         type = "button",
                                         title = "Help (Alt+H)",
                                         style = "width: 36px; height: 36px; padding: 0px;
                     border-radius: 50%; border: none;
                     background: transparent; color: #6c757d; font-size: 24px;",
                                         icon("circle-question")),
                             tags$div(id = "help-dropdown-menu",
                                      style = "display: none; position: absolute; right: 0; top: 100%;
                      min-width: 340px; background: white; border: 1px solid #ddd;
                      border-radius: 6px; box-shadow: 0 4px 12px rgba(0,0,0,0.15);
                      z-index: 2000; padding: 8px 0;",
                                      tags$a(
                                        id = "open-plot-presets",
                                        href = "#",
                                        style = "display: block; padding: 8px 0px 8px 26px; color: #333;
           text-decoration: none; font-size: 14px;",
                                        icon("wand-magic-sparkles"), " Help me choose a plot..."
                                      ),
                                      tags$hr(style = "margin: 4px 0;"),
                                      tags$a(href = "https://forms.gle/G3MxUSmnZzFqC5Yj8",
                                             target = "_blank",
                                             style = "display: block; padding: 8px 0px 8px 26px; color: #333;
                       text-decoration: none; font-size: 14px;",
                                             icon("bug"), " Report a bug..."),
                                      tags$hr(style = "margin: 4px 0;"),
                                      tags$div(style = "padding: 8px 16px;",
                                               tags$strong(style = "font-size: 13px; color: #555;", "Keyboard Shortcuts"),
                                               tags$table(
                                                 style = "width: 100%; font-size: 12px; border-collapse: collapse; margin-top: 6px;",
                                                 tags$thead(tags$tr(
                                                   tags$th(style = "text-align:left; padding:3px 6px; border-bottom:1px solid #eee; color:#888;", "Shortcut"),
                                                   tags$th(style = "text-align:left; padding:3px 6px; border-bottom:1px solid #eee; color:#888;", "Action")
                                                 )),
                                                 tags$tbody(
                                                   tags$tr(                        tags$td(style="padding:3px 6px;", tags$kbd("Alt+V")),          tags$td(style="padding:3px 6px; color:#333;", "Go to Visualizations")),
                                                   tags$tr(style="background:#f9f9f9;", tags$td(style="padding:3px 6px;", tags$kbd("Alt+B")),    tags$td(style="padding:3px 6px; color:#333;", "Back to Data Options")),
                                                   tags$tr(                        tags$td(style="padding:3px 6px;", tags$kbd("Alt+P")),          tags$td(style="padding:3px 6px; color:#333;", "Peek at data")),
                                                   tags$tr(style="background:#f9f9f9;", tags$td(style="padding:3px 6px;", tags$kbd("Alt+C")),    tags$td(style="padding:3px 6px; color:#333;", "Convert data")),
                                                   tags$tr(                        tags$td(style="padding:3px 6px;", tags$kbd("Alt+S / Ctrl+S")), tags$td(style="padding:3px 6px; color:#333;", "Open Save menu")),
                                                   tags$tr(style="background:#f9f9f9;", tags$td(style="padding:3px 6px;", tags$kbd("Alt+A")),    tags$td(style="padding:3px 6px; color:#333;", "Open Accessibility menu")),
                                                   tags$tr(                        tags$td(style="padding:3px 6px;", tags$kbd("Alt+H")),          tags$td(style="padding:3px 6px; color:#333;", "Open Help menu")),
                                                   tags$tr(style="background:#f9f9f9;", tags$td(style="padding:3px 6px;", tags$kbd("← →")),      tags$td(style="padding:3px 6px; color:#333;", "Previous / Next participant")),
                                                   tags$tr(                        tags$td(style="padding:3px 6px;", tags$kbd("↑ ↓")),            tags$td(style="padding:3px 6px; color:#333;", "Previous / Next event")),
                                                   tags$tr(style="background:#f9f9f9;", tags$td(style="padding:3px 6px;", tags$kbd("Esc")),      tags$td(style="padding:3px 6px; color:#333;", "Close all menus"))
                                                 )
                                               )
                                      )
                             )
                    )
           )
  ),

  sidebarLayout(
    sidebarPanel(

      # DATA OPTIONS
      conditionalPanel(
        condition = "input.sidebar_state == 'data'",

        h4("Step 1: Upload Data"),

        fileInput("file", "Upload your own data (.csv, .xlsx, .sav files accepted)", accept = c(".csv", ".sav", ".xlsx")),
        div(style = "margin-top: -40px"),

        tags$div(style = "text-align: center; padding: 10px; color: #666; font-weight: bold;",
                 "— OR —"
        ),

        actionButton("open_demo_modal", "Select a demo dataset...",
                     class = "btn btn-default",
                     style = "width: 100%;",
                     icon = icon("database")),

        tags$div(
          style = "padding: 8px; background-color: #e8f4f8; border-left: 3px solid #17a2b8;
           border-radius: 4px; font-size: 0.9em; margin-top: 8px;",
          textOutput("active_dataset_name")
        ),

        tags$div(id = "file-help", class = "help-text", style = "font-size: 0.9em; color: #666; display: none;",
                 "Upload a CSV file containing your time-series data"),
        conditionalPanel(
          condition = "output.hasData == 'true'",
          div(style = "margin-top: 10px"),
          fluidRow(
            column(12, align = "center",
                   actionButton("peek_data", "Peek at data",
                                class = "btn-sm btn-outline-info",
                                icon = icon("table"),
                                title = "Peek at data (Alt+P)",
                                style = "margin-top: 5px; align:center;")
            )

          )
        ),

        conditionalPanel(
          condition = "output.hasData == 'true'",
          hr(),
          h4("Step 2: Describe Dataset"),

          tags$p(style = "margin-bottom: 4px; font-weight: 500;",
                 "Select all types of data in your dataset:"),
          checkboxInput("has_continuous", "Continuous variables (numeric signals)", FALSE),
          checkboxInput("has_events",     "Event series or categorical variables", FALSE),
          tags$div(id = "data-structure-help", class = "help-text", style = "font-size: 0.9em; color: #666; display: none;",
                   "Continuous: numeric measurements over time. Events/categorical: 0/1 coded or labelled episodes."),
          conditionalPanel(
            condition = "input.has_events == true",
            tags$div(
              style = "margin-left: 15px; padding: 10px; border-left: 3px solid #17a2b8; background-color: #f8f9fa; margin-bottom: 15px;",
              radioButtons("event_format", "Event Data Format:",
                           choices = c("Continuous Time Series (one row per time point)" = "continuous",
                                       "Intervals (one row per event with start/end times)" = "interval"),
                           selected = "continuous"),
              conditionalPanel(
                condition = "input.event_format == 'interval'",
                uiOutput("interval_ui")
              )
            )
          ),


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
        tags$div(
          class = "panel panel-default",
          style = "margin-bottom: 10px;",

          tags$div(
            class = "panel-heading",
            style = "padding: 8px 12px; background-color: #f8f9fa;",
            tags$a(
              id = "subset-toggle",
              href = "#",
              style = "text-decoration: none; color: #333;",
              icon("filter"), " (Optional) Subset Data ",
              tags$span(id = "subset-caret", class = "caret")
            )
          ),

          tags$div(
            id = "subset-dropdown",
            style = "display: none; padding: 12px 14px 10px 14px;",
            uiOutput("subset_ui"),
            tags$div(
              style = "margin-top: 8px;",
              helpText("Show only one condition or group.")
            )
          )
        ),

        selectInput("viz_mode", "Visualization type",
                    c("Raw time series", "Event + Continuous Overlay", "Event-locked average",
                      "Event-locked single event", "Event durations (barcode)")),
        tags$div(id = "viz-mode-help", class = "help-text", style = "font-size: 0.9em; color: #666; display: none;",
                 "Choose how to display your data: line plots, event overlays, or event-triggered averages"),

        # Participant controls
        conditionalPanel(
          condition = "input.use_id == true",
          h4("Participants"),
          checkboxInput("step_through", "View one participant at a time", FALSE),

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
            tags$div(
              style = "margin-top: 0.5em;",
              textOutput("current_participant")
            )
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
          textOutput("n_events_averaged"),
          checkboxInput(
            "overlay_events",
            "Overlay individual trajectories",
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
                            condition = paste0(
                              "input.viz_mode == 'Raw time series' || ",
                              "input.viz_mode == 'Event + Continuous Overlay' || ",
                              "input.viz_mode == 'Event durations (barcode)'"
                            ),
                            textInput(
                              "custom_legend",
                              "Legend Title",
                              placeholder = "Auto-generated"
                            )
                          ),
                          uiOutput("legend_labels_ui")
                          # actionButton(
                          #   "update_labels",
                          #   "Apply Labels",
                          #   class = "btn-outline-primary btn-sm",
                          #   icon = icon("check"),
                          #   style = "width: 100%; margin-top: 8px;",
                          #   title = "Apply custom labels to the current plot"
                          # )
                 ) ),
        hr(),
        actionButton(
          "update_plot",
          "Update Plot",
          class = "btn-primary",
          icon = icon("rotate"),
          style = "width: 100%; margin-bottom: 10px;",
          title = "Update the plot using the current selections"
        ),
        hr(),
        h4("Second Plot (Optional)"),
        checkboxInput("show_second_plot", "Show second plot below main plot", FALSE),

        conditionalPanel(
          condition = "input.show_second_plot == true",
          uiOutput("second_plot_ui")
        )
      ),
      #),
      shinyjs::hidden(textInput("sidebar_state", "", value = "data"))
    ),

    mainPanel(
      conditionalPanel(
        condition = "input.sidebar_state == 'viz'",
        tags$div(id = "plot-description", class = "help-text",
                 style = "margin-bottom: 15px; padding: 10px; background-color: #f8f9fa; border-left: 4px solid #007bff; border-radius: 4px; display: none;",
                 textOutput("plot_description")),

        shinycssloaders::withSpinner(plotly::plotlyOutput("plot", height = "550px")),
        tags$div(
          style = "margin-top: 10px; margin-bottom: 12px;",
          actionButton(
            "explain_plot",
            "Explain this plot",
            class = "btn-outline-info btn-sm",
            icon = icon("circle-info"),
            title = "Explain what the current plot is showing"
          )
        ),
        uiOutput("stats_section"),

        conditionalPanel(
          condition = "input.show_second_plot == true",
          tags$div(
            style = "margin-top: 40px; margin-bottom: 15px",
          tags$div(class = "help-text",
                   style = "margin-top: 15px; margin-bottom: 15px; padding: 10px; background-color: #f8f9fa; border-left: 4px solid #007bff; border-radius: 4px; display: none;",
                   textOutput("plot2_description")),

          shinycssloaders::withSpinner(plotly::plotlyOutput("plot2", height = "400px"))
        )
        )
      )


    )
  )
)


server <- function(input, output, session){

  hex_to_rgba <- function(hex, alpha = 0.2) {
    rgb_vals <- col2rgb(hex)
    paste0("rgba(", rgb_vals[1], ",", rgb_vals[2], ",", rgb_vals[3], ",", alpha, ")")
  }

  get_labels <- function(default_title, default_x, default_y, default_legend) {
    list(
      title  = if (isTruthy(input$custom_title))  input$custom_title  else default_title,
      x      = if (isTruthy(input$custom_xlab))   input$custom_xlab   else default_x,
      y      = if (isTruthy(input$custom_ylab))   input$custom_ylab   else default_y,
      legend = if (isTruthy(input$custom_legend)) input$custom_legend else default_legend
    )
  }

  label_values <- reactiveValues()

  # label observers - maybe need to be moved down?
  observe({
    vars <- current_label_vars()

    if (is.null(vars) || length(vars) == 0) {
      return()
    }

    for (v in vars) {
      key <- make_label_id(v)
      val <- input[[key]]

      if (!is.null(val)) {
        label_values[[key]] <- trimws(val)
      }
    }
  })

  `%||%` <- function(x, y) {
    if (is.null(x)) y else x
  }

  make_variable_order_key <- function(variable) {
    paste("variable", variable, sep = "::")
  }

  make_category_order_key <- function(variable, category) {
    paste(
      "category",
      variable,
      as.character(category),
      sep = "::"
    )
  }

  order_by_plot_labels <- function(x, keys) {
    if (length(x) < 2) {
      return(x)
    }

    requested_order <- input$plot_label_order

    if (is.null(requested_order) || length(requested_order) == 0) {
      return(x)
    }

    requested_order <- unlist(
      requested_order,
      use.names = FALSE
    )

    ranks <- match(keys, requested_order)

    # Unrecognized/new items retain their original relative order.
    fallback_ranks <- length(requested_order) + seq_along(keys)
    ranks[is.na(ranks)] <- fallback_ranks[is.na(ranks)]

    x[order(ranks, seq_along(ranks))]
  }

  ordered_variables <- function(variables) {
    variables <- unique(variables)

    if (length(variables) < 2) {
      return(variables)
    }

    keys <- vapply(
      variables,
      make_variable_order_key,
      character(1)
    )

    order_by_plot_labels(variables, keys)
  }

  target_order_key <- function(target) {
    if (isTRUE(target$is_binary)) {
      make_variable_order_key(target$col)
    } else {
      make_category_order_key(target$col, target$val)
    }
  }

  ordered_plot_targets <- function(targets) {
    if (length(targets) < 2) {
      return(targets)
    }

    keys <- vapply(
      targets,
      target_order_key,
      character(1)
    )

    order_by_plot_labels(targets, keys)
  }

  plot_label_rank <- function(key) {
    requested_order <- input$plot_label_order

    if (is.null(requested_order) || length(requested_order) == 0) {
      return(10000)
    }

    requested_order <- unlist(
      requested_order,
      use.names = FALSE
    )

    rank <- match(key, requested_order)

    if (is.na(rank)) 10000 else rank
  }

  observe({
    categories <- current_event_categories()

    if (is.null(categories) || nrow(categories) == 0) {
      return()
    }

    for (i in seq_len(nrow(categories))) {
      variable_name <- categories$variable[i]
      category_value <- categories$category[i]

      key <- make_event_category_label_id(
        variable = variable_name,
        category = category_value
      )

      val <- input[[key]]

      if (!is.null(val)) {
        label_values[[key]] <- trimws(val)
      }
    }
  })

  make_label_id <- function(var) {
    paste0("legend_label_", gsub("[^a-zA-Z0-9]", "_", var))
  }

  make_event_category_label_id <- function(variable, category) {
    make_label_id(
      paste(
        "event_category",
        variable,
        category,
        sep = "__"
      )
    )
  }

  get_event_category_label <- function(variable, category) {
    key <- make_event_category_label_id(
      variable = variable,
      category = category
    )

    current_val <- input[[key]]
    stored_val  <- label_values[[key]]

    if (isTruthy(current_val)) {
      return(current_val)
    }

    if (isTruthy(stored_val)) {
      return(stored_val)
    }

    as.character(category)
  }

  get_event_trace_label <- function(variable, category) {
    variable_key <- make_label_id(variable)

    current_variable <- input[[variable_key]]
    stored_variable  <- label_values[[variable_key]]

    variable_label <- if (isTruthy(current_variable)) {
      current_variable
    } else if (isTruthy(stored_variable)) {
      stored_variable
    } else {
      variable
    }

    category_label <- get_event_category_label(
      variable = variable,
      category = category
    )

    paste(variable_label, "-", category_label)
  }

  #get_variable_label
  get_var_label <- function(var) {
    key <- make_label_id(var)

    current_val <- input[[key]]
    stored_val  <- label_values[[key]]

    if (isTruthy(current_val)) {
      return(current_val)
    }

    if (isTruthy(stored_val)) {
      return(stored_val)
    }

    paste("", var) #anchor
  }

  add_legend_target <- function(legend_traces, target) {
    if (length(legend_traces) == 0) {
      legend_traces[[1]] <- target
      return(legend_traces)
    }

    existing_keys <- vapply(
      legend_traces,
      function(x) x$legend_key,
      character(1)
    )

    if (!target$legend_key %in% existing_keys) {
      legend_traces[[length(legend_traces) + 1]] <- target
    }

    legend_traces
  }

  get_barcode_target_label <- function(
    variable,
    category,
    is_binary,
    show_variable = FALSE
  ) {
    if (isTRUE(is_binary)) {
      return(get_var_label(variable))
    }

    category_label <- get_event_category_label(
      variable = variable,
      category = category
    )

    if (isTRUE(show_variable)) {
      variable_label <- get_var_label(variable)

      # get_var_label() default begins with "-" that marker when building a combined label.
      if (identical(variable_label, paste("-", variable))) {
        variable_label <- variable
      }

      return(
        paste(variable_label, "-", category_label)
      )
    }

    category_label
  }


  # START anchor
  # Convert supported time variables to numeric values
  .numeric_event_time <- function(time) {
    if (is.numeric(time)) {
      return(as.numeric(time))
    }

    if (inherits(time, c("POSIXct", "POSIXlt", "Date", "difftime"))) {
      return(as.numeric(time))
    }

    converted <- suppressWarnings(
      as.numeric(as.character(time))
    )

    failed <- !is.na(time) & is.na(converted)

    if (any(failed)) {
      stop(
        "`time` must be numeric, Date/POSIX time, difftime, ",
        "or coercible to numeric."
      )
    }

    converted
  }


  # Extract event onset times
  .extract_abney_onsets <- function(
    vector,
    event,
    event_format = c("continuous", "interval"),
    time = NULL
  ) {
    event_format <- match.arg(event_format)

    if (length(event) != 1L) {
      stop("`event` must contain exactly one event value.")
    }

    if (!is.null(time) && length(time) != length(vector)) {
      stop("`vector` and `time` must have the same length.")
    }

    event_character <- as.character(event)
    vector_character <- as.character(vector)

    if (is.null(time)) {
      time_numeric <- seq_along(vector)
    } else {
      time_numeric <- .numeric_event_time(time)
    }

    if (event_format == "interval") {
      # Each matching row already represents one event episode.
      keep <- !is.na(vector) &
        !is.na(time_numeric) &
        vector_character == event_character

      # Do not use unique(): simultaneous events should be retained.
      return(sort(time_numeric[keep]))
    }

    # Continuous sampled-state format
    valid_time <- which(!is.na(time_numeric))

    if (length(valid_time) == 0L) {
      return(numeric(0))
    }

    # Detect runs in chronological order
    ordered_rows <- valid_time[
      order(time_numeric[valid_time], valid_time)
    ]

    ordered_vector <- vector[ordered_rows]
    ordered_time <- time_numeric[ordered_rows]

    active <- !is.na(ordered_vector) &
      as.character(ordered_vector) == event_character

    # An onset occurs when the current sample is active and
    # the immediately preceding sample was not active.
    previously_active <- c(FALSE, head(active, -1L))
    onset <- active & !previously_active

    ordered_time[onset]
  }


  # Calculate the Abney et al. burstiness statistic from event times
  .abney_burstiness_from_times <- function(event_times) {
    event_times <- .numeric_event_time(event_times)
    event_times <- sort(event_times[is.finite(event_times)])

    # R's sd() requires at least two IEIs, meaning at least
    # three event onsets.
    if (length(event_times) < 3L) {
      return(NA_real_)
    }

    interevent_intervals <- diff(event_times)

    mean_iei <- mean(interevent_intervals)
    sd_iei <- stats::sd(interevent_intervals)

    denominator <- sd_iei + mean_iei

    if (
      !is.finite(mean_iei) ||
      !is.finite(sd_iei) ||
      !is.finite(denominator) ||
      denominator == 0
    ) {
      return(NA_real_)
    }

    (sd_iei - mean_iei) / denominator
  }


  #' Calculate burstiness following Abney et al. (2018)
  #'
  #' For continuous sampled data, consecutive occurrences of an event
  #' are collapsed into a single onset. For interval data, each matching
  #' row is treated as one event and its start time is used as the onset.
  #'
  #' @param vector Event or state vector.
  #' @param event_format Either `"continuous"` or `"interval"`.
  #' @param time Optional time vector for continuous data and required
  #'   start-time vector for interval data. If omitted for continuous
  #'   data, row positions are used.
  #' @param event Event value to analyze. Defaults to `1`.
  #'
  #' @return Numeric burstiness estimate or `NA_real_`.
  #' @export
  get_burstiness <- function(
    vector,
    event_format = c("continuous", "interval"),
    time = NULL,
    event = 1
  ) {
    event_format <- match.arg(event_format)

    if (event_format == "interval" && is.null(time)) {
      stop(
        "`time` must provide the interval start times when ",
        "`event_format = 'interval'`."
      )
    }

    event_times <- .extract_abney_onsets(
      vector = vector,
      event = event,
      event_format = event_format,
      time = time
    )

    .abney_burstiness_from_times(event_times)
  }

  get_burstiness <- function(
    vector,
    event_format = c("continuous", "interval"),
    time = NULL,
    event = 1,
    method = c("finite", "original")
  ) {
    event_format <- match.arg(event_format)
    method <- match.arg(method)

    event_times <- .extract_event_times(
      vector = vector,
      event = event,
      event_format = event_format,
      time = time
    )

    .burstiness_from_times(
      event_times = event_times,
      method = method
    )
  }


  #' Calculate Abney et al. burstiness by event category
  #'
  #' @param vector Binary or categorical event vector.
  #' @param event_format Either `"continuous"` or `"interval"`.
  #' @param time Optional timestamp vector for continuous data and
  #'   required onset-time vector for interval data.
  #' @param events Optional values to analyze. If omitted, binary data
  #'   analyze event 1; categorical data analyze all observed values.
  #'
  #' @return Data frame containing one row per event category.
  #' @export
  get_burstiness_by_event <- function(
    vector,
    event_format = c("continuous", "interval"),
    time = NULL,
    events = NULL
  ) {
    event_format <- match.arg(event_format)

    observed <- unique(
      as.character(vector[!is.na(vector)])
    )

    is_binary <- length(observed) == 0L ||
      all(observed %in% c("0", "1"))

    if (is.null(events)) {
      if (is_binary) {
        events <- "1"
      } else {
        events <- observed
      }
    }

    events <- as.character(events)

    results <- lapply(events, function(event_value) {
      event_times <- .extract_abney_onsets(
        vector = vector,
        event = event_value,
        event_format = event_format,
        time = time
      )

      interevent_intervals <- diff(event_times)

      data.frame(
        event = event_value,
        n_events = length(event_times),
        n_interevent_intervals = length(interevent_intervals),
        mean_iei = if (length(interevent_intervals) > 0L) {
          mean(interevent_intervals)
        } else {
          NA_real_
        },
        sd_iei = if (length(interevent_intervals) > 1L) {
          stats::sd(interevent_intervals)
        } else {
          NA_real_
        },
        burstiness = .abney_burstiness_from_times(event_times),
        stringsAsFactors = FALSE
      )
    })

    if (length(results) == 0L) {
      return(
        data.frame(
          event = character(0),
          n_events = integer(0),
          n_interevent_intervals = integer(0),
          mean_iei = numeric(0),
          sd_iei = numeric(0),
          burstiness = numeric(0)
        )
      )
    }

    do.call(rbind, results)
  }
  #END anchor
  get_app_burstiness <- function(sub_df, event_variable) {
    event_values <- sub_df[[event_variable]]

    if (identical(input$event_format, "interval")) {
      req(input$int_start)

      get_burstiness_by_event(
        vector = event_values,
        event_format = "interval",
        time = sub_df[[input$int_start]]
      )
    } else {
      # Ideally use the same time variable displayed on the x-axis.
      # If rows are guaranteed to be evenly spaced, time = NULL is
      # mathematically sufficient.
      get_burstiness_by_event(
        vector = event_values,
        event_format = "continuous",
        time = NULL
      )
    }
  }

  is_binary_event_vector <- function(x) {
    observed <- unique(as.character(x[!is.na(x)]))

    length(observed) == 0L ||
      all(observed %in% c("0", "1"))
  }


  format_burstiness_value <- function(value, n_events) {
    if (!is.na(value)) {
      return(sprintf("%.4f", value))
    }

    if (n_events < 3L) {
      return("NA (<3 event episodes)")
    }

    "NA"
  }

  get_event_counts <- function(vals) {
    clean_vals <- na.omit(vals)
    if (length(clean_vals) == 0) return(list(n_events = 0L, total_duration = 0L))
    is_binary <- all(unique(clean_vals) %in% c(0, 1))
    if (is_binary) {
      r <- rle(as.integer(clean_vals))
      n_events  <- sum(r$values == 1L)
      total_dur <- sum(clean_vals == 1L, na.rm = TRUE)
    } else {
      active_vals <- unique(clean_vals[clean_vals != 0 & clean_vals != "0"])
      is_active   <- as.integer(clean_vals %in% active_vals)
      r           <- rle(is_active)
      n_events    <- sum(r$values == 1L)
      total_dur   <- sum(is_active)
    }
    list(n_events = n_events, total_duration = total_dur)
  }

  check_plot_cancelled <- function(my_request, my_cancel) {
    if (!identical(my_request, plot_request_id()) ||
        !identical(my_cancel, plot_cancel_id()) ||
        !identical(input$sidebar_state, "viz")) {
      validate(need(FALSE, "Plot canceled. Update the plot to build a new one."))
    }
  }

  make_plot_explanation <- function() {
    req(input$viz_mode)

    mode <- input$viz_mode

    if (mode == "Raw time series") {
      return(tagList(
        tags$p("This plot shows one or more continuous variables changing over time."),
        tags$ul(
          tags$li(paste("X-axis:", input$xvar %||% "selected time variable")),
          tags$li(paste("Y-variable(s):", paste(input$yvar %||% "selected signal variable(s)", collapse = ", "))),
          tags$li("Use this plot to inspect trends, noise, outliers, missing segments, and participant-level differences.")
        ),
        tags$p(tags$strong("What to check next: "), "Look for flat lines, sudden jumps, gaps, and participants whose signal scale differs from others.")
      ))
    }

    if (mode == "Event + Continuous Overlay") {
      return(tagList(
        tags$p("This plot overlays event periods on top of continuous signal traces."),
        tags$ul(
          tags$li(paste("Time variable:", input$time_overlay %||% "selected time variable")),
          tags$li(paste("Continuous signal(s):", paste(input$signal_overlay %||% "selected signal(s)", collapse = ", "))),
          tags$li(paste("Event variable(s):", paste(input$event_overlay %||% "selected event(s)", collapse = ", "))),
          tags$li("Use this plot to see whether signal changes appear to occur before, during, or after events.")
        ),
        tags$p(tags$strong("What to check next: "), "If event rectangles do not appear, verify that the event variable is coded as 0/1 or has non-zero active values.")
      ))
    }

    if (mode == "Event durations (barcode)") {
      return(tagList(
        tags$p("This plot shows when event states are active and how long they last."),
        tags$ul(
          tags$li(paste("Time variable:", input$barcode_time %||% "selected time variable")),
          tags$li(paste("Event variable(s):", paste(input$barcode_var %||% "selected event variable(s)", collapse = ", "))),
          tags$li("Stacked rows help compare event timing across variables or participants."),
          tags$li("Overlaid mode is useful when you want to see whether events co-occur.")
        ),
        tags$p(tags$strong("What to check next: "), "Use the Event Summary tool to count bouts and total active duration.")
      ))
    }

    if (mode == "Event-locked average") {
      return(tagList(
        tags$p("This plot summarizes the average signal trajectory around event onsets."),
        tags$ul(
          tags$li(paste("Event variable:", input$event_var %||% "selected event")),
          tags$li(paste("Signal variable:", input$signal_var %||% "selected signal")),
          tags$li(paste("Window:", input$pre, "seconds before to", input$post, "seconds after each event")),
          tags$li("Use this plot to ask whether the signal systematically changes around events.")
        ),
        tags$p(tags$strong("What to check next: "), "Check how many events are averaged. A small number of events can make the average unstable.")
      ))
    }

    if (mode == "Event-locked single event") {
      return(tagList(
        tags$p("This plot shows the signal around one event at a time."),
        tags$ul(
          tags$li(paste("Event variable:", input$event_var %||% "selected event")),
          tags$li(paste("Signal variable:", input$signal_var %||% "selected signal")),
          tags$li("Use Previous Event and Next Event to step through individual episodes."),
          tags$li("This view is useful for checking whether event-locked averages are driven by a few unusual events.")
        ),
        tags$p(tags$strong("What to check next: "), "Compare several individual events before relying on the average.")
      ))
    }

    tagList(tags$p("Select a visualization mode to see an explanation."))
  }

  safe_pct <- function(x, digits = 1) {
    if (is.na(x) || is.nan(x) || is.infinite(x)) return(NA_real_)
    round(100 * x, digits)
  }

  guess_visit_vars <- function(df) {
    names(df)[grepl("visit|session|wave|occasion|timepoint|assessment", names(df), ignore.case = TRUE)]
  }

  guess_event_vars <- function(df) {
    names(df)[sapply(df, function(x) {
      clean <- na.omit(x)
      if (length(clean) == 0) return(FALSE)

      is.factor(x) ||
        is.character(x) ||
        is.logical(x) ||
        (is.numeric(x) && length(unique(clean)) <= 20)
    })]
  }

  guess_numeric_signal_vars <- function(df) {
    names(df)[sapply(df, is.numeric)]
  }

  guess_time_vars <- function(df) {
    names(df)[sapply(df, function(x) {
      inherits(x, c("POSIXct", "POSIXt", "Date")) ||
        is.numeric(x)
    })]
  }

  make_missing_summary <- function(df) {
    data.frame(
      Variable = names(df),
      Class = sapply(df, function(x) paste(class(x), collapse = "/")),
      Missing_N = sapply(df, function(x) sum(is.na(x))),
      Missing_Percent = sapply(df, function(x) safe_pct(mean(is.na(x)))),
      Unique_N = sapply(df, function(x) length(unique(na.omit(x)))),
      stringsAsFactors = FALSE
    )
  }

  make_time_summary <- function(df, time_var = NULL, id_var = NULL) {
    if (is.null(time_var) || !time_var %in% names(df)) {
      return(data.frame(Note = "No time variable selected or detected."))
    }

    if (!is.null(id_var) && id_var %in% names(df)) {
      groups <- split(df, as.character(df[[id_var]]))
    } else {
      groups <- list("All Data" = df)
    }

    out <- lapply(names(groups), function(id) {
      sub <- groups[[id]]
      t <- sub[[time_var]]

      if (inherits(t, c("POSIXct", "POSIXt", "Date"))) {
        time_min <- suppressWarnings(min(t, na.rm = TRUE))
        time_max <- suppressWarnings(max(t, na.rm = TRUE))
        duration <- as.numeric(difftime(time_max, time_min, units = "secs"))
      } else {
        t_num <- suppressWarnings(as.numeric(t))
        time_min <- suppressWarnings(min(t_num, na.rm = TRUE))
        time_max <- suppressWarnings(max(t_num, na.rm = TRUE))
        duration <- time_max - time_min
      }

      dt <- suppressWarnings(diff(sort(unique(as.numeric(t)))))
      dt <- dt[is.finite(dt) & dt > 0]

      data.frame(
        ID = id,
        Rows = nrow(sub),
        Time_Min = as.character(time_min),
        Time_Max = as.character(time_max),
        Duration = round(duration, 4),
        Median_Time_Step = if (length(dt) > 0) round(median(dt), 4) else NA_real_,
        Irregular_Time_Steps = if (length(dt) > 1) length(unique(round(dt, 6))) > 1 else NA,
        stringsAsFactors = FALSE
      )
    })

    do.call(rbind, out)
  }

  make_participant_summary <- function(df, id_var = NULL, time_var = NULL) {
    visit_vars <- guess_visit_vars(df)

    if (!is.null(id_var) && id_var %in% names(df)) {
      groups <- split(df, as.character(df[[id_var]]))
    } else {
      groups <- list("All Data" = df)
    }

    out <- lapply(names(groups), function(id) {
      sub <- groups[[id]]

      visits <- if (length(visit_vars) > 0) {
        paste(
          sapply(visit_vars, function(v) {
            paste0(v, ": ", length(unique(na.omit(sub[[v]]))))
          }),
          collapse = "; "
        )
      } else {
        "No visit/session-like variable detected"
      }

      if (!is.null(time_var) && time_var %in% names(sub)) {
        t <- sub[[time_var]]

        if (inherits(t, c("POSIXct", "POSIXt", "Date"))) {
          start <- suppressWarnings(min(t, na.rm = TRUE))
          end <- suppressWarnings(max(t, na.rm = TRUE))
          duration <- as.numeric(difftime(end, start, units = "secs"))
        } else {
          t_num <- suppressWarnings(as.numeric(t))
          start <- suppressWarnings(min(t_num, na.rm = TRUE))
          end <- suppressWarnings(max(t_num, na.rm = TRUE))
          duration <- end - start
        }
      } else {
        start <- NA
        end <- NA
        duration <- NA
      }

      data.frame(
        ID = id,
        Rows = nrow(sub),
        Start_Time = as.character(start),
        End_Time = as.character(end),
        Duration = round(duration, 4),
        Visit_Summary = visits,
        stringsAsFactors = FALSE
      )
    })

    do.call(rbind, out)
  }

  make_event_summary <- function(df, event_vars, id_var = NULL) {
    if (is.null(event_vars) || length(event_vars) == 0) {
      return(data.frame(Note = "No event-like variables selected or detected."))
    }

    if (!is.null(id_var) && id_var %in% names(df)) {
      groups <- split(df, as.character(df[[id_var]]))
    } else {
      groups <- list("All Data" = df)
    }

    rows <- list()

    for (id in names(groups)) {
      sub <- groups[[id]]

      for (v in event_vars) {
        if (!v %in% names(sub)) next

        counts <- get_event_counts(sub[[v]])
        active <- sub[[v]]
        active_clean <- active[!is.na(active)]
        percent_active <- if (length(active_clean) > 0) {
          is_active <- active_clean != 0 & active_clean != "0"
          safe_pct(mean(is_active))
        } else {
          NA_real_
        }

        rows[[length(rows) + 1]] <- data.frame(
          ID = id,
          Variable = v,
          Event_Count = counts$n_events,
          Total_Active_Rows = counts$total_duration,
          Percent_Active = percent_active,
          Unique_Values = paste(head(unique(na.omit(as.character(sub[[v]]))), 8), collapse = ", "),
          stringsAsFactors = FALSE
        )
      }
    }

    if (length(rows) == 0) {
      return(data.frame(Note = "No event summaries could be generated."))
    }

    do.call(rbind, rows)
  }

  make_data_quality_report <- function(df, input, diagnostics_obj) {
    time_vars <- diagnostics_obj$time
    numeric_vars <- diagnostics_obj$numeric
    binary_vars <- diagnostics_obj$binary
    event_like_vars <- guess_event_vars(df)
    visit_vars <- guess_visit_vars(df)

    id_var <- if (isTRUE(input$use_id) && isTruthy(input$idvar)) input$idvar else NULL
    time_var <- if (length(time_vars) > 0) time_vars[1] else NULL

    missing_summary <- make_missing_summary(df)
    participant_summary <- make_participant_summary(df, id_var = id_var, time_var = time_var)
    event_summary <- make_event_summary(df, event_vars = head(event_like_vars, 10), id_var = id_var)
    time_summary <- make_time_summary(df, time_var = time_var, id_var = id_var)

    warnings <- c()

    if (length(time_vars) == 0) warnings <- c(warnings, "- No obvious time variable detected.")
    if (length(numeric_vars) == 0) warnings <- c(warnings, "- No numeric signal variables detected.")
    if (length(event_like_vars) == 0) warnings <- c(warnings, "- No event-like variables detected.")

    high_missing <- missing_summary$Variable[missing_summary$Missing_Percent >= 25]
    if (length(high_missing) > 0) {
      warnings <- c(warnings, paste0("- Variables with at least 25% missing values: ", paste(high_missing, collapse = ", ")))
    }

    if (length(warnings) == 0) {
      warnings <- "- No major issues detected by the basic checks."
    }

    c(
      "DATA QUALITY REPORT",
      paste("Generated:", Sys.time()),
      "",
      "DATASET OVERVIEW",
      paste("Rows:", nrow(df)),
      paste("Columns:", ncol(df)),
      paste("Participant ID variable:", ifelse(is.null(id_var), "None selected", id_var)),
      paste("Likely time variables:", ifelse(length(time_vars) > 0, paste(time_vars, collapse = ", "), "None detected")),
      paste("Likely numeric signals:", ifelse(length(numeric_vars) > 0, paste(numeric_vars, collapse = ", "), "None detected")),
      paste("Likely binary event variables:", ifelse(length(binary_vars) > 0, paste(binary_vars, collapse = ", "), "None detected")),
      paste("Likely event/categorical variables:", ifelse(length(event_like_vars) > 0, paste(event_like_vars, collapse = ", "), "None detected")),
      paste("Likely visit/session variables:", ifelse(length(visit_vars) > 0, paste(visit_vars, collapse = ", "), "None detected")),
      "",
      "WARNINGS / THINGS TO CHECK",
      warnings,
      "",
      "MISSING DATA SUMMARY",
      capture.output(print(missing_summary, row.names = FALSE)),
      "",
      "TIME SUMMARY",
      capture.output(print(time_summary, row.names = FALSE)),
      "",
      "PARTICIPANT / VISIT SUMMARY",
      capture.output(print(participant_summary, row.names = FALSE)),
      "",
      "EVENT SUMMARY",
      capture.output(print(event_summary, row.names = FALSE)),
      "",
      "NOTES",
      "- This report is a screening aid. It does not guarantee that the data are correctly structured for every analysis.",
      "- Check time units, participant IDs, event coding, and missing values before interpreting plots."
    )
  }

  plot_store  <- reactiveVal(NULL)
  plot2_store <- reactiveVal(NULL)
  stats_store <- reactiveVal(NULL)
  data_converted <- reactiveVal(NULL)
  conversion_done <- reactiveVal(FALSE)
  last_data_source <- reactiveVal("demo")
  active_demo <- reactiveVal(NULL)

  demo_interval_defaults <- reactiveValues(
    start = NULL,
    mode = "end",
    end = NULL,
    duration = NULL,
    options = NULL
  )

  data_reactive <- reactive({
    if (conversion_done() && !is.null(data_converted())) {
      data_converted()
    } else {
      data_original()
    }
  })

  current_label_vars <- reactive({
    req(input$viz_mode)

    vars <- switch(
      input$viz_mode,
      "Raw time series" =
        input$yvar,

      "Event + Continuous Overlay" =
        c(input$signal_overlay, input$event_overlay),

      "Event durations (barcode)" =
        input$barcode_var,

      "Event-locked average" =
        c(input$signal_var, input$event_var),

      "Event-locked single event" =
        c(input$signal_var, input$event_var),

      NULL
    )

    unique(vars)
  })

  event_label_vars <- reactive({
    req(input$viz_mode)

    vars <- switch(
      input$viz_mode,
      "Event + Continuous Overlay" =
        input$event_overlay,

      "Event durations (barcode)" =
        input$barcode_var,

      "Event-locked average" =
        input$event_var,

      "Event-locked single event" =
        input$event_var,

      NULL
    )

    unique(vars)
  })

  current_event_categories <- reactive({
    df <- data_reactive()
    vars <- event_label_vars() #ach

    if (
      is.null(df) ||
      is.null(vars) ||
      length(vars) == 0
    ) {
      return(data.frame(
        variable = character(),
        category = character(),
        stringsAsFactors = FALSE
      ))
    }

    vars <- vars[vars %in% names(df)]

    if (length(vars) == 0) {
      return(data.frame(
        variable = character(),
        category = character(),
        stringsAsFactors = FALSE
      ))
    }

    category_list <- lapply(vars, function(v) {
      x <- df[[v]]

      observed <- as.character(x[!is.na(x)])

      if (length(observed) == 0) {
        return(NULL)
      }

      # Preserve factor-level ordering where possible
      if (is.factor(x)) {
        categories <- levels(x)
        categories <- categories[categories %in% observed]
      } else {
        categories <- unique(observed)
      }

      # Standard binary event columns do not need category labels:
      # the existing variable label describes the event represented by 1.
      is_standard_binary <- all(categories %in% c("0", "1"))

      if (is_standard_binary) {
        return(NULL)
      }

      data.frame(
        variable = rep(v, length(categories)),
        category = categories,
        stringsAsFactors = FALSE
      )
    })

    category_list <- Filter(Negate(is.null), category_list)

    if (length(category_list) == 0) {
      return(data.frame(
        variable = character(),
        category = character(),
        stringsAsFactors = FALSE
      ))
    }

    do.call(rbind, category_list)
  })

  observeEvent(input$open_demo_modal, {
    showModal(modalDialog(
      title = "Select a Demo Dataset",
      size = "m",
      easyClose = TRUE,
      footer = modalButton("Cancel"),
      tags$p(style = "color: #666; margin-bottom: 15px;",
             "Select a dataset to load it and dismiss this menu."),
      tags$div(
        style = "cursor: pointer; padding: 12px; border: 1px solid #ddd;
               border-radius: 6px; margin-bottom: 10px; background: white;",
        onclick = "Shiny.setInputValue('demo_selected', 'object_play', {priority: 'event'})",
        tags$strong("Infant Object Play"),
        tags$p(style = "margin: 4px 0 0 0; color: #666; font-size: 0.9em;",
               "Event-coded object interactions")
      ),
      tags$div(
        style = "cursor: pointer; padding: 12px; border: 1px solid #ddd;
               border-radius: 6px; margin-bottom: 10px; background: white;",
        onclick = "Shiny.setInputValue('demo_selected', 'biobehavioral_interactions', {priority: 'event'})",
        tags$strong("Mother-Child Biobehavioral Interactions"),
        tags$p(style = "margin: 4px 0 0 0; color: #666; font-size: 0.9em;",
               "Mixed continuous and event data from dyadic observations")
      ),
      tags$div(
        style = "cursor: pointer; padding: 12px; border: 1px solid #ddd;
               border-radius: 6px; margin-bottom: 10px; background: white;",
        onclick = "Shiny.setInputValue('demo_selected', 'music_bouts', {priority: 'event'})",
        tags$strong("Daily Music Bouts"),
        tags$p(style = "margin: 4px 0 0 0; color: #666; font-size: 0.9em;",
               "Event-coded music listening episodes across the day")
      ),
      tags$div(
        style = "cursor: pointer; padding: 12px; border: 1px solid #ddd;
               border-radius: 6px; margin-bottom: 10px; background: white;",
        onclick = "Shiny.setInputValue('demo_selected', 'cradling_diaries', {priority: 'event'})",
        tags$strong("Gahvora Cradling Diaries"),
        tags$p(style = "margin: 4px 0 0 0; color: #666; font-size: 0.9em;",
               "Gahvora cradle use across the day")
      )
    ))
  })

  # when a demo is clicked in the modal
  observeEvent(input$demo_selected, {
    active_demo(input$demo_selected)
    last_data_source("demo")
    data_converted(NULL)
    conversion_done(FALSE)
    removeModal()
  }, ignoreInit = TRUE)

  # when a file is uploaded
  observeEvent(input$file, {
    active_demo(NULL)
    last_data_source("file")
    data_converted(NULL)
    conversion_done(FALSE)
  }, ignoreInit = TRUE)

  observeEvent(input$open_structure_checker, {
    df <- data_reactive()

    if (is.null(df) || nrow(df) == 0) {
      showNotification("Please upload a file or select a demo dataset first.", type = "error", duration = 6)
      return()
    }

    d <- diagnostics()

    time_vars <- d$time
    numeric_vars <- d$numeric
    binary_vars <- d$binary
    event_like_vars <- guess_event_vars(df)
    visit_vars <- guess_visit_vars(df)

    id_msg <- if (isTRUE(input$use_id) && isTruthy(input$idvar)) {
      paste0("Participant ID variable: ", input$idvar,
             " (", length(unique(na.omit(df[[input$idvar]]))), " unique IDs)")
    } else {
      "No participant ID variable is currently selected."
    }

    warning_rows <- list()

    if (length(time_vars) == 0) {
      warning_rows[[length(warning_rows) + 1]] <- "No obvious time variable detected."
    }

    if (length(numeric_vars) == 0) {
      warning_rows[[length(warning_rows) + 1]] <- "No numeric signal variables detected."
    }

    if (length(event_like_vars) == 0) {
      warning_rows[[length(warning_rows) + 1]] <- "No event-like or categorical variables detected."
    }

    missing_summary <- make_missing_summary(df)
    high_missing <- missing_summary$Variable[missing_summary$Missing_Percent >= 25]

    if (length(high_missing) > 0) {
      warning_rows[[length(warning_rows) + 1]] <- paste(
        "Variables with at least 25% missing values:",
        paste(high_missing, collapse = ", ")
      )
    }

    warnings_text <- if (length(warning_rows) == 0) {
      tags$p(style = "color: #198754;", icon("circle-check"), " No major structure issues detected.")
    } else {
      tags$ul(lapply(warning_rows, tags$li))
    }

    showModal(modalDialog(
      title = tagList(icon("magnifying-glass-chart"), " Dataset Structure Checker"),
      size = "l",
      easyClose = TRUE,
      footer = modalButton("Close"),

      tags$p(
        style = "color: #666;",
        "This is different from Peek at data: instead of showing raw rows, it summarizes what the app thinks your dataset contains and flags issues that may affect visualization."
      ),

      tags$div(
        style = "padding: 12px; background: #f8f9fa; border-left: 4px solid #0d6efd; border-radius: 4px; margin-bottom: 12px;",
        tags$strong("Dataset overview"),
        tags$ul(
          tags$li(paste("Rows:", nrow(df))),
          tags$li(paste("Columns:", ncol(df))),
          tags$li(id_msg),
          tags$li(paste("Likely time variables:", ifelse(length(time_vars) > 0, paste(time_vars, collapse = ", "), "None detected"))),
          tags$li(paste("Likely numeric signals:", ifelse(length(numeric_vars) > 0, paste(numeric_vars, collapse = ", "), "None detected"))),
          tags$li(paste("Likely binary event variables:", ifelse(length(binary_vars) > 0, paste(binary_vars, collapse = ", "), "None detected"))),
          tags$li(paste("Likely event/categorical variables:", ifelse(length(event_like_vars) > 0, paste(event_like_vars, collapse = ", "), "None detected"))),
          tags$li(paste("Likely visit/session variables:", ifelse(length(visit_vars) > 0, paste(visit_vars, collapse = ", "), "None detected")))
        )
      ),

      tags$h4("Warnings / things to check"),
      warnings_text,

      tags$h4("Missingness summary"),
      tags$div(
        style = "max-height: 250px; overflow-y: auto;",
        tableOutput("structure_missing_table")
      )
    ))
  }, ignoreInit = TRUE)

  output$structure_missing_table <- renderTable({
    df <- data_reactive()
    req(df)
    make_missing_summary(df)
  })

  observeEvent(input$open_missing_tool, {
    df <- data_reactive()

    if (is.null(df) || nrow(df) == 0) {
      showNotification("Please upload a file or select a demo dataset first.", type = "error", duration = 6)
      return()
    }

    showModal(modalDialog(
      title = tagList(icon("circle-exclamation"), " Missing Data Inspector"),
      size = "l",
      easyClose = TRUE,
      footer = modalButton("Close"),

      tags$p(
        style = "color: #666;",
        "This summarizes missing values by variable. High missingness can lead to blank plots, broken event summaries, or misleading averages."
      ),

      tags$div(
        style = "max-height: 420px; overflow-y: auto;",
        tableOutput("missing_summary_table")
      )
    ))
  }, ignoreInit = TRUE)

  output$missing_summary_table <- renderTable({
    df <- data_reactive()
    req(df)

    ms <- make_missing_summary(df)
    ms[order(-ms$Missing_Percent, ms$Variable), ]
  })


  observeEvent(input$open_participant_summary, {
    df <- data_reactive()

    if (is.null(df) || nrow(df) == 0) {
      showNotification("Please upload a file or select a demo dataset first.", type = "error", duration = 6)
      return()
    }

    showModal(modalDialog(
      title = tagList(icon("users"), " Participant / Visit Summary"),
      size = "l",
      easyClose = TRUE,
      footer = modalButton("Close"),

      tags$p(
        style = "color: #666;",
        "This summarizes how many rows, time points, and detected visits/sessions each participant contributes."
      ),

      tags$div(
        style = "max-height: 420px; overflow-y: auto;",
        tableOutput("participant_summary_table")
      )
    ))
  }, ignoreInit = TRUE)

  output$participant_summary_table <- renderTable({
    df <- data_reactive()
    req(df)

    d <- diagnostics()
    time_var <- if (length(d$time) > 0) d$time[1] else NULL
    id_var <- if (isTRUE(input$use_id) && isTruthy(input$idvar)) input$idvar else NULL

    make_participant_summary(df, id_var = id_var, time_var = time_var)
  })

  observeEvent(input$open_event_summary, {
    df <- data_reactive()

    if (is.null(df) || nrow(df) == 0) {
      showNotification("Please upload a file or select a demo dataset first.", type = "error", duration = 6)
      return()
    }

    showModal(modalDialog(
      title = tagList(icon("bars-progress"), " Event Summary"),
      size = "l",
      easyClose = TRUE,
      footer = modalButton("Close"),

      tags$p(
        style = "color: #666;",
        "This summarizes event-like variables using counts, total active rows, and percent active. It is useful before choosing a barcode, overlay, or event-locked plot."
      ),

      uiOutput("event_summary_selector"),

      tags$div(
        style = "max-height: 420px; overflow-y: auto;",
        tableOutput("event_summary_table")
      )
    ))
  }, ignoreInit = TRUE)

  output$event_summary_selector <- renderUI({
    df <- data_reactive()
    req(df)

    event_vars <- guess_event_vars(df)

    selectizeInput(
      "event_summary_vars",
      "Event-like variables to summarize",
      choices = event_vars,
      selected = head(event_vars, 5),
      multiple = TRUE,
      options = list(
        plugins = list("remove_button"),
        placeholder = "Select event variables"
      )
    )
  })

  output$event_summary_table <- renderTable({
    df <- data_reactive()
    req(df)

    id_var <- if (isTRUE(input$use_id) && isTruthy(input$idvar)) input$idvar else NULL
    event_vars <- input$event_summary_vars

    make_event_summary(df, event_vars = event_vars, id_var = id_var)
  })

  observeEvent(input$open_plot_presets, {
    showModal(modalDialog(
      title = tagList(icon("wand-magic-sparkles"), " Help Me Choose a Plot"),
      size = "m",
      easyClose = TRUE,
      footer = modalButton("Close"),

      tags$p(
        style = "color: #666;",
        "Choose a preset based on what you are trying to understand. The app will select a reasonable visualization mode and starting variables when possible."
      ),

      tags$div(style = "margin-bottom: 8px;",
               actionButton("preset_first_look", "First look at my data",
                            class = "btn-outline-primary", style = "width: 100%;")),

      tags$div(style = "margin-bottom: 8px;",
               actionButton("preset_event_timing", "Show event timing / durations",
                            class = "btn-outline-primary", style = "width: 100%;")),

      tags$div(style = "margin-bottom: 8px;",
               actionButton("preset_overlay", "Overlay events on continuous signals",
                            class = "btn-outline-primary", style = "width: 100%;")),

      tags$div(style = "margin-bottom: 8px;",
               actionButton("preset_event_locked", "Look at signal response around events",
                            class = "btn-outline-primary", style = "width: 100%;")),

      tags$div(style = "margin-bottom: 8px;",
               actionButton("preset_compare_people", "Compare several participants",
                            class = "btn-outline-primary", style = "width: 100%;"))
    ))
  }, ignoreInit = TRUE)


  choose_first <- function(x) {
    if (length(x) > 0) x[1] else NULL
  }

  choose_first_n <- function(x, n = 2) {
    if (length(x) > 0) head(x, n) else NULL
  }

  observeEvent(input$preset_first_look, {
    df <- data_reactive()
    req(df)

    d <- diagnostics()

    if (length(d$numeric) > 0) {
      updateSelectInput(session, "viz_mode", selected = "Raw time series")
      updateSelectizeInput(session, "xvar", selected = choose_first(d$time))
      updateSelectizeInput(session, "yvar", selected = choose_first_n(d$numeric, 2))
      updateSelectInput(session, "plot_type", selected = "Line")
    } else {
      event_vars <- guess_event_vars(df)
      updateSelectInput(session, "viz_mode", selected = "Event durations (barcode)")
      updateSelectizeInput(session, "barcode_time", selected = choose_first(d$time))
      updateSelectizeInput(session, "barcode_var", selected = choose_first_n(event_vars, 3))
      updateRadioButtons(session, "barcode_layout", selected = "stacked")
    }

    removeModal()
    request_plot_redraw()
  }, ignoreInit = TRUE)

  observeEvent(input$preset_event_timing, {
    df <- data_reactive()
    req(df)

    d <- diagnostics()
    event_vars <- guess_event_vars(df)

    updateSelectInput(session, "viz_mode", selected = "Event durations (barcode)")
    updateSelectizeInput(session, "barcode_time", selected = choose_first(d$time))
    updateSelectizeInput(session, "barcode_var", selected = choose_first_n(event_vars, 4))
    updateRadioButtons(session, "barcode_layout", selected = "stacked")

    removeModal()
    request_plot_redraw()
  }, ignoreInit = TRUE)

  observeEvent(input$preset_overlay, {
    df <- data_reactive()
    req(df)

    d <- diagnostics()
    event_vars <- guess_event_vars(df)

    if (length(d$numeric) == 0 || length(event_vars) == 0) {
      showNotification("This preset needs at least one continuous signal and one event-like variable.", type = "error", duration = 6)
      return()
    }

    updateSelectInput(session, "viz_mode", selected = "Event + Continuous Overlay")
    updateSelectizeInput(session, "time_overlay", selected = choose_first(d$time))
    updateSelectizeInput(session, "signal_overlay", selected = choose_first_n(d$numeric, 2))
    updateSelectizeInput(session, "event_overlay", selected = choose_first_n(event_vars, 2))

    removeModal()
    request_plot_redraw()
  }, ignoreInit = TRUE)

  observeEvent(input$preset_event_locked, {
    df <- data_reactive()
    req(df)

    d <- diagnostics()
    event_vars <- d$binary

    if (length(d$numeric) == 0 || length(event_vars) == 0) {
      showNotification("This preset needs at least one numeric signal and one binary event variable.", type = "error", duration = 6)
      return()
    }

    updateSelectInput(session, "viz_mode", selected = "Event-locked average")
    updateSelectizeInput(session, "event_var", selected = choose_first(event_vars))
    updateSelectizeInput(session, "signal_var", selected = choose_first(d$numeric))
    updateNumericInput(session, "pre", value = 5)
    updateNumericInput(session, "post", value = 5)

    removeModal()
    request_plot_redraw()
  }, ignoreInit = TRUE)

  observeEvent(input$preset_compare_people, {
    df <- data_reactive()
    req(df)

    d <- diagnostics()

    if (!isTRUE(input$use_id) || !isTruthy(input$idvar)) {
      showNotification("To compare participants, first turn on Multiple participants and choose an ID variable.", type = "error", duration = 7)
      return()
    }

    ids <- all_ids()
    selected <- head(ids, min(5, length(ids)))

    updateCheckboxInput(session, "step_through", value = FALSE)
    updateSelectizeInput(session, "selected_ids", selected = selected)

    if (length(d$numeric) > 0) {
      updateSelectInput(session, "viz_mode", selected = "Raw time series")
      updateSelectizeInput(session, "xvar", selected = choose_first(d$time))
      updateSelectizeInput(session, "yvar", selected = choose_first_n(d$numeric, 1))
      updateSelectInput(session, "plot_type", selected = "Line")
    }

    removeModal()
    request_plot_redraw()
  }, ignoreInit = TRUE)


  # Store both original and converted data
  # cradling_diaries
  data_original <- reactive({

    df <- if (last_data_source() == "demo") {
      req(!is.null(active_demo()))
      demo_file <- switch(active_demo(),
                          "object_play" = system.file("extdata", "object_play.csv", package = "dora"),
                          "biobehavioral_interactions" = system.file("extdata", "biobehavioral_interactions.csv", package = "dora"),
                          "music_bouts" = system.file("extdata", "music_bouts.csv", package = "dora"),
                          "cradling_diaries" = system.file("extdata", "cradling_diaries.csv", package = "dora")
      )
      if (demo_file == "") stop("Demo file not found. Try reinstalling the package.")
      readr::read_csv(demo_file, show_col_types = FALSE)

    } else {
      req(input$file)
      if (grepl(".csv", input$file$datapath)) {
        readr::read_csv(input$file$datapath, show_col_types = FALSE)
      }
      else if(grepl(".sav", input$file$datapath)){
        haven::read_sav(input$file$datapath)
      } else if(grepl(".xlsx", input$file$datapath)){
        readxl::read_excel(input$file$datapath)
      } else {
        return("File type not supported. Please upload a CSV, XLSX, or SAV file.")
      }
    }

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
  })

  observeEvent(input$explain_plot, {
    if (is.null(plot_store())) {
      showNotification("Generate a plot first, then click Explain this plot.", type = "error", duration = 6)
      return()
    }

    showModal(modalDialog(
      title = tagList(icon("circle-info"), " Explain This Plot"),
      size = "m",
      easyClose = TRUE,
      footer = modalButton("Close"),

      tags$div(
        style = "padding: 10px; background: #f8f9fa; border-left: 4px solid #0d6efd; border-radius: 4px; margin-bottom: 12px;",
        textOutput("plot_description")
      ),

      make_plot_explanation()
    ))
  }, ignoreInit = TRUE)

  output$hasData <- renderText({
    has <- (last_data_source() == "demo" && !is.null(active_demo())) ||
      (last_data_source() == "file" && !is.null(input$file))
    if (has) "true" else "false"
  })
  outputOptions(output, "hasData", suspendWhenHidden = FALSE)

  accessibility <- reactiveValues(
    high_contrast   = FALSE,
    large_text      = FALSE,
    large_targets   = FALSE,
    reduce_motion   = FALSE,
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
      list(t = 80, b = 60, l = 50, r = 40)
    } else {
      list(t = 50, b = 50, l = 40, r = 40)
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

  # observe({
  #   vars <- current_label_vars()
  #
  #   if (is.null(vars) || length(vars) == 0) {
  #     return()
  #   }
  #
  #   for (v in vars) {
  #     key <- make_label_id(v)
  #     val <- input[[key]]
  #
  #     if (!is.null(val)) {
  #       label_values[[key]] <- val
  #     }
  #   }
  # }) # get labels - is this the right location?

  # Update CSS based on accessibility settings
  observe({
    shinyjs::runjs(sprintf(
      "$('body').toggleClass('high-contrast', %s);",
      tolower(accessibility$high_contrast)
    ))

    shinyjs::runjs(sprintf(
      "$('body').toggleClass('large-text', %s);",
      tolower(accessibility$large_text)
    ))

    shinyjs::runjs(sprintf(
      "$('body').toggleClass('large-targets', %s);",
      tolower(accessibility$large_targets)
    ))

    shinyjs::runjs(sprintf(
      "$('body').toggleClass('reduce-motion', %s);",
      tolower(accessibility$reduce_motion)
    ))

    shinyjs::runjs(sprintf(
      "$('body').toggleClass('simplified-ui', %s);",
      tolower(accessibility$simplified_ui)
    ))

    shinyjs::runjs(sprintf(
      "$('body').toggleClass('show-descriptions', %s);",
      tolower(accessibility$show_descriptions)
    ))
  })

  observeEvent(input$confirm_actions,      { accessibility$confirm_actions     <- input$confirm_actions
  updateCheckboxInput(session, "toolbar_confirm_actions", value = input$confirm_actions)}, ignoreInit = TRUE)

  observeEvent(input$toolbar_confirm_actions, {
    accessibility$confirm_actions <- input$toolbar_confirm_actions
    updateCheckboxInput(session, "confirm_actions", value = input$toolbar_confirm_actions)
  }, ignoreInit = TRUE)

  vision_preset_handler <- function () {
    accessibility$high_contrast   <- TRUE
    accessibility$large_text      <- TRUE
    accessibility$reduce_motion   <- TRUE
    showNotification("Vision preset applied", type = "message", duration = 5)
  }

  observeEvent(input$preset_vision,         handle_vision_preset(), ignoreInit = TRUE)

  motor_preset_handler <- function () {
    accessibility$large_targets   <- TRUE
    accessibility$reduce_motion   <- TRUE
    accessibility$confirm_actions <- TRUE
    showNotification("Motor preset applied", type = "message", duration = 5)
  }

  observeEvent(input$preset_motor,         handle_motor_preset(), ignoreInit = TRUE)

  access_reset_handler <- function () {
    accessibility$high_contrast     <- FALSE
    accessibility$large_text        <- FALSE
    accessibility$large_targets     <- FALSE
    accessibility$reduce_motion     <- FALSE
    accessibility$simplified_ui     <- FALSE
    accessibility$show_descriptions <- FALSE
    accessibility$confirm_actions   <- FALSE
    showNotification("All accessibility settings reset", type = "message", duration = 3)
  }

  observeEvent(input$reset_accessibility, access_reset_handler(), ignoreInit = TRUE)
  observeEvent(input$toolbar_reset_accessibility, access_reset_handler(), ignoreInit = TRUE)

  # Colorblind-friendly palette generator
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
    shinyjs::runjs("$('#accessibility-controls').collapse('hide');")


    # Determine which visualizations are allowed based on data structure
    cont   <- isTRUE(input$has_continuous)
    events <- isTRUE(input$has_events)

    if (!cont && !events) {
      showNotification("Please select at least one data type before proceeding.",
                       type = "error", duration = 6)
      return()
    }

    allowed_choices <- if (cont && events) {
      c("Raw time series", "Event + Continuous Overlay", "Event-locked average",
        "Event-locked single event", "Event durations (barcode)")
    } else if (cont) {
      c("Raw time series")
    } else {
      c("Event durations (barcode)")
    }

    updateSelectInput(session, "viz_mode",
                      choices = allowed_choices,
                      selected = allowed_choices[1])
  })

  #check here
  observeEvent(input$back_data, {
    cancel_current_plot()

    updateTextInput(session, "sidebar_state", value = "data")
    updateCheckboxInput(session, "show_second_plot", value = FALSE)

    plot_store(NULL)
    plot2_store(NULL)
    stats_store(NULL)

    updateTextInput(session,"sidebar_state",value="data")
  })

  output$interval_ui <- renderUI({
    columns <- names(data_reactive())

    valid_columns <- function(selected_columns) {
      if (is.null(selected_columns)) {
        return(NULL)
      }

      selected_columns <- as.character(selected_columns)

      selected_columns[
        selected_columns %in% columns
      ]
    }

    valid_column <- function(selected_column) {
      valid <- valid_columns(selected_column)

      if (length(valid) > 0) {
        valid[1]
      } else {
        NULL
      }
    }

    selected_mode <- demo_interval_defaults$mode

    if (
      !isTruthy(selected_mode) ||
      !selected_mode %in% c("end", "duration")
    ) {
      selected_mode <- "end"
    }

    tagList(
      selectInput(
        "int_start", "Start Time Column", choices = columns,
        selected = valid_column(demo_interval_defaults$start)
      ),

      radioButtons(
        "interval_mode", "End format:",
        choices = c("End Time" = "end","Duration" = "duration"),
        selected = selected_mode
      ),

      conditionalPanel(
        condition = "input.interval_mode == 'end'",

        selectInput(
          "int_end", "End Time Column", choices = columns,
          selected = valid_column(demo_interval_defaults$end))
      ),

      conditionalPanel(
        condition = "input.interval_mode == 'duration'",
        selectInput("int_dur", "Duration Column", choices = columns,
                    selected = valid_column(demo_interval_defaults$duration))
      ),

      selectInput("int_val", "Event/Categorical Column(s)", choices = columns,
                  selected = valid_columns(demo_interval_defaults$options),multiple = TRUE)
    )
  })

  outputOptions(
    output,
    "interval_ui",
    suspendWhenHidden = FALSE
  )

  observeEvent(input$demo_selected, {
    active_demo(input$demo_selected)
    last_data_source("demo")
    cancel_current_plot()
    data_converted(NULL)
    conversion_done(FALSE)

    plot_store(NULL)
    plot2_store(NULL)
    stats_store(NULL)
    removeModal()

    demo_types <- switch(
      input$demo_selected,

      "object_play" = list(
        continuous = FALSE,
        events = TRUE,
        multiple = TRUE,
        int_cont = "interval",
        start = "onset",
        interval_mode = "end",
        end = "offset",
        duration = NULL,
        options = c("bobj", "objcat")
      ),

      "biobehavioral_interactions" = list(
        continuous = TRUE,
        events = TRUE,
        multiple = TRUE,
        int_cont = "continuous"
      ),

      "music_bouts" = list(
        continuous = FALSE,
        events = TRUE,
        multiple = TRUE,
        int_cont = "interval",
        start = "DayInSeconds",
        interval_mode = "duration",
        duration = "DurationSecs",
        interval = NULL,
        options = c("Live",	"Recorded",	"Vocal", "Instrumental", "oneVoice",	"oneTune",	"LV_1V1T",	"RVI_1V1T")
      ),

      "cradling_diaries" = list(
        continuous = FALSE,
        events = TRUE,
        multiple = TRUE,
        int_cont = "interval"
      )
    )
    demo_interval_defaults$start <-
      demo_types$start %||% NULL

    demo_interval_defaults$mode <-
      demo_types$interval_mode %||% "end"

    demo_interval_defaults$end <-
      demo_types$end %||% NULL

    demo_interval_defaults$duration <-
      demo_types$duration %||% NULL

    demo_interval_defaults$options <-
      demo_types$options %||% NULL

    updateCheckboxInput(session, "has_continuous", value = demo_types$continuous)
    updateCheckboxInput(session, "has_events", value = demo_types$events)
    updateCheckboxInput(session, "use_id", value = demo_types$multiple)
    updateRadioButtons(session, "event_format", selected = demo_types$int_cont)
  }, ignoreInit = TRUE)

  observeEvent(input$file, {
    cancel_current_plot()

    active_demo(NULL)
    last_data_source("file")
    data_converted(NULL)
    conversion_done(FALSE)

    plot_store(NULL)
    plot2_store(NULL)
    stats_store(NULL)
    #updateCheckboxInput(session, "is_interval_data", value = FALSE)
  }, ignoreInit = TRUE)

  diagnostics <- reactive({
    df <- data_reactive()
    req(!is.null(df) && nrow(df) > 0)
    detect_dataset(df)
  }) |> bindCache(data_reactive())

  output$active_dataset_name <- renderText({
    if (last_data_source() == "file" && !is.null(input$file)) {
      paste("Currently using:", input$file$name)
    } else if (last_data_source() == "demo" && !is.null(active_demo())) {
      label <- switch(active_demo(),
                      "object_play" = "Infant Object Play",
                      "biobehavioral_interactions" = "Mother-Child Interactions",
                      "music_bouts" = "Daily Music Bouts",
                      "cradling_diaries" = "Gahvora Cradling Diaries"
      )
      paste("Currently using:", label)
    } else {
      "No dataset selected - browse for a file or select a demo above"
    }
  })

  output$time_step_ui <- renderUI({
    df <- data_reactive()
    time_col <- input$start_time_col
    is_datetime <- !is.null(time_col) && time_col %in% names(df) &&
      inherits(df[[time_col]], c("POSIXct", "POSIXt", "Date"))
    label <- if (is_datetime) {
      "Output time step (seconds)"
    } else {
      "Output time step (in units of your time column; seconds if time is in datetime format)"
    }
    numericInput("time_unit_val", label, 1, min = 0.001, step = 0.1)
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
      # Independent participant control for this step
      checkboxInput("conv_has_id", "Dataset contains multiple participants", FALSE),

      conditionalPanel(
        condition = "input.conv_has_id",
        selectInput("conv_id_col", "Participant ID Variable", all_vars)
      ),

      selectInput("event_var_col", "Event/Activity variable(s)", all_vars, multiple = TRUE),
      uiOutput("time_step_ui")
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
  outputOptions(output, "interval_conversion_ui", suspendWhenHidden = FALSE)

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
    shinyjs::disable("convert_data")

    shinyjs::disable("convert_data")
    id <- showNotification("Converting data, please wait...", duration = NULL, type = "message")
    on.exit({
      shinyjs::enable("convert_data")
      removeNotification(id)
    })
    req(input$start_time_col, input$event_var_col, input$time_unit_val)

    if (input$interval_format == "start_end") req(input$end_time_col)
    if (input$interval_format == "start_dur") req(input$duration_col)

    # VALIDATION: Check ID variable if selected
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

      # Parse datetime columns if character
      for (col in c(input$start_time_col, input$end_time_col)) {
        if (!is.null(col) && col %in% names(df) && is.character(df[[col]])) {
          parsed <- suppressWarnings(
            lubridate::parse_date_time(df[[col]],
                                       orders = c("ymd HMS", "ymd HM", "HMS", "HM", "ymd", "dmy HMS", "mdy HMS"),
                                       quiet = TRUE)
          )
          if (sum(!is.na(parsed)) > 0.5 * length(parsed)) df[[col]] <- parsed
        }
      }

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

      req(length(input$event_var_col) > 0)

      time_is_datetime <- inherits(df_to_process[[input$start_time_col]], c("POSIXct", "POSIXt"))
      origin_time <- NULL

      if (time_is_datetime) {
        origin_time <- min(df_to_process[[input$start_time_col]], na.rm = TRUE)
        df_to_process[[input$start_time_col]] <- as.numeric(
          difftime(df_to_process[[input$start_time_col]], origin_time, units = "secs")
        )
        if (target_end_col %in% names(df_to_process)) {
          df_to_process[[target_end_col]] <- as.numeric(
            difftime(df_to_process[[target_end_col]], origin_time, units = "secs")
          )
        }
      }


      # Expand each variable separately
      all_converted <- lapply(input$event_var_col, function(var) {
        expand_timeseries(
          data = df_to_process,
          id_var = chosen_id,
          var_name = var,
          start_time_var = input$start_time_col,
          end_time_var = target_end_col,
          time_unit = input$time_unit_val
        )
      })

      # Use the first expansion as the base, then cbind unique columns from the rest
      converted <- all_converted[[1]]
      if (length(all_converted) > 1) {
        for (i in 2:length(all_converted)) {
          new_cols <- setdiff(names(all_converted[[i]]), names(converted))
          if (length(new_cols) > 0) {
            converted <- cbind(converted, all_converted[[i]][, new_cols, drop = FALSE])
          }
        }
      }

      # Convert row indices back to datetime
      if (time_is_datetime) {
        time_out_col <- input$start_time_col
        if (time_out_col %in% names(converted) && is.numeric(converted[[time_out_col]])) {
          converted[[time_out_col]] <- origin_time + (converted[[time_out_col]] * time_step_secs)
        }
      }

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
  } #end of converter

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
      tags$div(
        style = "overflow-x: auto; max-height: 400px; overflow-y: auto;",
        renderTable({ head(df, 10) })
      )
    ))
  })

  output$download_quality_report <- downloadHandler(
    filename = function() {
      paste0("data_quality_report_", Sys.Date(), ".txt")
    },
    content = function(file) {
      df <- data_reactive()

      if (is.null(df) || nrow(df) == 0) {
        writeLines("No data available. Please upload a file or select a demo dataset first.", file)
        return()
      }

      d <- diagnostics()
      report <- make_data_quality_report(df, input, d)
      writeLines(report, file)
    }
  )

  # Convert interval data
  observeEvent(input$convert_data, {
    do_convert()
  })

  observeEvent(input$confirm_convert, {
    removeModal()
    do_convert()
  })

  output$subset_ui <- renderUI({
    df <- data_reactive()
    req(df)

    all_vars <- names(df)

    tagList(
      tags$div(
        style = "margin-bottom: 12px;",
        selectizeInput(
          "subset_var",
          "Subset variable",
          choices = c("No subset" = "", all_vars),
          selected = "",
          multiple = FALSE,
          options = list(
            placeholder = "Choose a variable to subset by"
          )
        )
      ),

      conditionalPanel(
        condition = "input.subset_var != null && input.subset_var != ''",
        tags$div(
          style = "margin-bottom: 8px;",
          uiOutput("subset_values_ui")
        )
      )
    )
  })

  observeEvent(input$open_converter_modal, {
    if (is.null(data_reactive()) || nrow(data_reactive()) == 0) {
      showNotification(
        "Please upload a file or select a demo dataset before using the data converter.",
        type = "error",
        duration = 6
      )
      return()
    }

    showModal(
      modalDialog(
        title = tagList(icon("right-left"), " Data Converter"),
        size = "l",
        easyClose = TRUE,

        tags$p(
          style = "font-size: 0.92em; color: #666; margin-bottom: 12px;",
          "Use this tool if your data has one row per event with start/end times or durations.
         The converter expands it into a continuous time-series format that can be downloaded
         and reused later."
        ),

        tags$div(
          style = "padding: 12px; background-color: #f8f9fa; border-left: 4px solid #17a2b8;
                 border-radius: 4px; margin-bottom: 14px;",
          tags$strong("Tip: "),
          "You do not need to convert your data every time you use the app. Convert once, download the converted file,
         then upload that converted file directly in the future."
        ),

        uiOutput("interval_conversion_ui"),

        tags$hr(),

        textOutput("conversion_status"),

        conditionalPanel(
          condition = "output.conversionDone",
          downloadButton(
            "download_converted",
            "Download Converted Data (.csv)",
            class = "btn-sm btn-outline-success",
            style = "margin-top: 8px;"
          )
        ),

        footer = tagList(
          modalButton("Close"),
          actionButton(
            "convert_data",
            "Convert to Continuous Format",
            class = "btn-success",
            icon = icon("right-left"),
            title = "Convert data"
          )
        )
      )
    )
  }, ignoreInit = TRUE)

  output$subset_values_ui <- renderUI({
    df <- data_reactive()
    req(df)
    req(input$subset_var)
    req(input$subset_var != "")

    vals <- sort(unique(as.character(df[[input$subset_var]])))
    vals <- vals[!is.na(vals)]

    selectizeInput(
      "subset_values",
      "Keep value(s)",
      choices = vals,
      selected = vals[1],
      multiple = TRUE,
      options = list(
        plugins = list("remove_button"),
        placeholder = "Select value(s) to keep"
      )
    )
  })

  outputOptions(output, "subset_ui", suspendWhenHidden = FALSE)
  outputOptions(output, "subset_values_ui", suspendWhenHidden = FALSE)

  # Participant handling
  output$idvar_ui <- renderUI({
    df <- data_reactive()
    sel <- if(isTRUE(input$conv_has_id) && !is.null(input$conv_id_col)) input$conv_id_col else NULL

    selectInput("idvar", "Participant ID variable", names(df), selected = sel)
  })

  all_ids <- reactive({
  req(input$idvar)
  unique(as.character(data_reactive()[[input$idvar]]))
  })

  id_index <- reactiveVal(1)
  event_index <- reactiveVal(1)

  # Persistent variable selections
  selected_time <- reactiveVal(NULL)
  selected_signal <- reactiveVal(NULL)
  selected_event <- reactiveVal(NULL)

  plot_request_id <- reactiveVal(0)
  plot_cancel_id  <- reactiveVal(0)

  request_plot_redraw <- function() {
    plot_request_id(plot_request_id() + 1)
  }

  cancel_current_plot <- function() {
    plot_cancel_id(plot_cancel_id() + 1)
  }

  observeEvent(input$viz_mode, {
    if (input$viz_mode == "Event-locked single event") {
      updateCheckboxInput(session, "step_through", value = TRUE)
    }
  })

  observeEvent(input$next_id,{
    id_index(ifelse(id_index() == length(all_ids()), 1, id_index() + 1))
    event_index(1)
    cancel_current_plot()
    request_plot_redraw()
  })
  observeEvent(input$prev_id,{
    id_index(ifelse(id_index() == 1, length(all_ids()), id_index() - 1))
    event_index(1) # anchor - i don't remember what this is doing lol
    cancel_current_plot()
    request_plot_redraw()
  })

  observeEvent(input$next_event,{
    event_index(event_index() + 1)
    cancel_current_plot()
    request_plot_redraw()
  })
  observeEvent(input$prev_event,{
    event_index(max(1, event_index() - 1))
    cancel_current_plot()
    request_plot_redraw()
  })

  output$current_participant <- renderText({
    paste("Participant:", all_ids()[id_index()])
  })

  output$current_event <- renderText({
    paste("Event:", event_index())
  })

  output$n_events_averaged <- renderText({
    req(input$viz_mode == "Event-locked average", input$event_var)

    multi_participant <- isTRUE(input$use_id) && !isTRUE(input$step_through)

    n <- if (multi_participant) {
      req(input$idvar, input$selected_ids)
      total <- 0
      for (pid in input$selected_ids) {
        pdf <- filtered_data()[filtered_data()[[input$idvar]] == pid, ]
        if (nrow(pdf) == 0) next
        pw <- extract_event_windows_idx(pdf[[input$event_var]])
        total <- total + nrow(pw)
      }
      total
    } else {
      windows <- extract_event_windows_idx(filtered_data()[[input$event_var]])
      nrow(windows)
    }

    paste("Averaging", n, "event(s)")
  })

  output$event_onset_time <- renderText({
    req(input$viz_mode == "Event-locked single event")
    df <- data_reactive()

    if (isTRUE(input$use_id)) {
      df <- df[df[[input$idvar]] == all_ids()[id_index()], ]
    }

    req(input$event_var)

    if (input$event_format == "interval") {
      active_idx <- which(!is.na(df[[input$event_var]]) & df[[input$event_var]] != 0 & df[[input$event_var]] != "0")
      if (length(active_idx) > 0 && event_index() <= length(active_idx)) {
        onset_time <- df[[input$int_start]][active_idx[event_index()]]
        if (inherits(onset_time, c("POSIXct", "POSIXt", "POSIXlt"))) {
          paste("Event onset time:", format(onset_time, "%Y-%m-%d %H:%M:%S"))
        } else if (is.numeric(onset_time)) {
          paste("Event onset time:", round(onset_time, 2), "seconds")
        } else {
          paste("Event onset time:", as.character(onset_time))
        }
      }
    } else {
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
    }
  })

  output$id_select_ui <- renderUI({
    ids <- all_ids()
    default_sel <- ids[seq_len(min(5, length(ids)))]

    tagList(
      selectizeInput(
        "selected_ids",
        "Select participant(s)",
        choices = ids,
        selected = default_sel,
        multiple = TRUE,
        options = list(
          plugins = list("remove_button"),
          placeholder = "Select participant(s)"
        )
      ),
      checkboxInput("select_all_ids", "Select all participants", FALSE)
    )
  })

  observeEvent(input$select_all_ids, {
    if (isTRUE(input$select_all_ids)) {
      updateSelectizeInput(session, "selected_ids", selected = all_ids())
    } else {
      ids <- all_ids()
      updateSelectizeInput(session, "selected_ids", selected = ids[seq_len(min(5, length(ids)))])
    }
  }, ignoreInit = TRUE)

  observeEvent(input$selected_ids, {
    all_selected <- length(input$selected_ids) == length(all_ids())
    updateCheckboxInput(session, "select_all_ids", value = all_selected)
  }, ignoreInit = TRUE, ignoreNULL = TRUE)

  # Variable selection
  output$var_ui <- renderUI({
    data_reactive()
    d <- diagnostics()

    tagList(
      selectizeInput(
        "xvar",
        "Time (x) variable",
        choices = d$time,
        selected = selected_time(),
        multiple = FALSE
      ),
      selectizeInput(
        "yvar",
        "Signal (y) variable",
        choices = d$numeric,
        selected = selected_signal(),
        multiple = TRUE,
        options = list(
          plugins = list("remove_button"),
          placeholder = "Select signal variable(s)"
        )
      )
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

  # Label UI
  output$legend_labels_ui <- renderUI({
    vars <- current_label_vars()
    category_df <- current_event_categories()

    vars <- vars[!is.na(vars) & nzchar(vars)]

    if (length(vars) == 0 && nrow(category_df) == 0) {
      return(NULL)
    }

    make_order_item <- function(
    order_key,
    input_id,
    field_label,
    placeholder,
    item_type
    ) {
      tags$div(
        class = "label-order-item",
        `data-order-key` = order_key,
        style = paste(
          "display: flex;",
          "align-items: flex-start;",
          "gap: 8px;",
          "padding: 8px;",
          "margin-bottom: 7px;",
          "border: 1px solid #e5e5e5;",
          "border-radius: 4px;",
          "background: #fff;"
        ),

        tags$div(
          style = paste(
            "display: flex;",
            "flex-direction: column;",
            "gap: 3px;",
            "padding-top: 23px;"
          ),

          tags$button(
            type = "button",
            class = "move-label-up btn btn-default btn-xs",
            title = paste("Move", field_label, "up"),
            `aria-label` = paste("Move", field_label, "up"),
            icon("chevron-up")
          ),

          tags$button(
            type = "button",
            class = "move-label-down btn btn-default btn-xs",
            title = paste("Move", field_label, "down"),
            `aria-label` = paste("Move", field_label, "down"),
            icon("chevron-down")
          )
        ),

        tags$div(
          style = "flex: 1; min-width: 0;",

          textInput(
            inputId = input_id,
            label = tags$span(
              tags$small(
                style = "color: #777;",
                paste0(item_type, ": ")
              ),
              field_label
            ),
            value = isolate(label_values[[input_id]] %||% ""),
            placeholder = placeholder
          )
        )
      )
    }

    records <- list()

    # Interleave each variable with its categories so the default
    # order matches the existing variable/category organization.
    for (variable_name in vars) {
      variable_input_id <- make_label_id(variable_name)

      records[[length(records) + 1]] <- list(
        key = make_variable_order_key(variable_name),
        node = make_order_item(
          order_key = make_variable_order_key(variable_name),
          input_id = variable_input_id,
          field_label = variable_name,
          placeholder = variable_name,
          item_type = "Variable"
        )
      )

      variable_categories <- category_df[
        category_df$variable == variable_name,
        ,
        drop = FALSE
      ]

      if (nrow(variable_categories) > 0) {
        for (i in seq_len(nrow(variable_categories))) {
          category_value <- variable_categories$category[i]

          category_input_id <- make_event_category_label_id(
            variable = variable_name,
            category = category_value
          )

          records[[length(records) + 1]] <- list(
            key = make_category_order_key(
              variable_name,
              category_value
            ),
            node = make_order_item(
              order_key = make_category_order_key(
                variable_name,
                category_value
              ),
              input_id = category_input_id,
              field_label = paste(
                variable_name,
                category_value,
                sep = " — "
              ),
              placeholder = category_value,
              item_type = "Category"
            )
          )
        }
      }
    }

    record_keys <- vapply(
      records,
      function(record) record$key,
      character(1)
    )

    records <- isolate(
      order_by_plot_labels(records, record_keys)
    )

    tags$div(
      tags$hr(style = "margin: 8px 0;"),

      tags$p(
        style = paste(
          "font-weight: 500;",
          "margin-bottom: 4px;",
          "font-size: 0.9em;"
        ),
        "Plot Labels and Order"
      ),

      tags$p(
        style = paste(
          "font-size: 0.8em;",
          "color: #666;",
          "margin-bottom: 8px;"
        ),
        paste(
          "Rename labels and use the arrow buttons to change their order.",
          "Click Update Plot to apply the changes."
        )
      ),

      tags$div(
        id = "plot-label-order-list",
        lapply(records, function(record) record$node)
      )
    )
  })

  outputOptions(
    output,
    "legend_labels_ui",
    suspendWhenHidden = FALSE
  )

  outputOptions(output, "legend_labels_ui", suspendWhenHidden = FALSE)

  output$second_plot_ui <- renderUI({
    data_reactive()
    d <- diagnostics()
    tagList(
      if (isTRUE(input$use_id) && isTruthy(input$idvar)) {
        ids <- tryCatch(
          as.character(all_ids()),
          error = function(e) NULL
        )

        if (!is.null(ids) && length(ids) > 0) {
          selected_second_id <- isolate(input$second_plot_id)

          if (
            !isTruthy(selected_second_id) ||
            !as.character(selected_second_id) %in% ids
          ) {
            selected_second_id <- ids[1]
          }

          tagList(
            selectInput("second_plot_type", "Second plot type",
                        c("Allan Factor (event data)" = "allan_factor",
                          "Allan Deviation (continuous)" = "allan_deviation")),
            selectInput(
              "second_plot_id",
              "Select Participant (second plot)",
              choices = ids,
              selected = selected_second_id,
              multiple = FALSE
            ),

            fluidRow(
              column(
                6,
                actionButton(
                  "prev_second_id",
                  "Previous Participant",
                  icon = icon("arrow-left")
                )
              ),
              column(
                6,
                actionButton(
                  "next_second_id",
                  "Next Participant",
                  icon = icon("arrow-right")
                )
              )
            ),
            tags$div(
              style = "margin-top: 0.5em;",
              textOutput("current_second_participant")
            ),
            hr()
          )
        }
      },

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

  change_second_participant <- function(direction) {
    ids <- as.character(all_ids())
    req(length(ids) > 0)

    current_id <- isolate(input$second_plot_id)
    current_index <- match(as.character(current_id), ids)

    if (is.na(current_index)) {
      current_index <- 1L
    }

    new_index <- (
      (current_index - 1L + direction) %% length(ids)
    ) + 1L

    updateSelectInput(
      session,
      "second_plot_id",
      choices = ids,
      selected = ids[new_index]
    )
  }

  observeEvent(input$prev_second_id, {
    change_second_participant(-1L)
  })

  observeEvent(input$next_second_id, {
    change_second_participant(1L)
  })

  output$current_second_participant <- renderText({
    req(input$second_plot_id)

    paste(
      "Plot 2 participant:",
      input$second_plot_id
    )
  })

  output$overlay_ui <- renderUI({
    data_reactive()
    d <- diagnostics()
    df <- data_reactive()

    all_vars <- names(df)
    cat_vars <- all_vars[sapply(df, function(x) {
      is.factor(x) || is.character(x) ||
        (is.numeric(x) && length(unique(na.omit(x))) <= 20)
    })]

    tagList(
      selectizeInput(
        "time_overlay",
        "Time (x) variable",
        choices = d$time,
        selected = selected_time(),
        multiple = FALSE
      ),
      selectizeInput(
        "signal_overlay",
        "Continuous (y) variable(s)",
        choices = d$numeric,
        selected = selected_signal(),
        multiple = TRUE,
        options = list(
          plugins = list("remove_button"),
          placeholder = "Select continuous variable(s)"
        )
      ),
      selectizeInput(
        "event_overlay",
        "Event variable(s)",
        choices = cat_vars,
        selected = selected_event(),
        multiple = TRUE,
        options = list(
          plugins = list("remove_button"),
          placeholder = "Select event variable(s)"
        )
      )
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
      selectizeInput(
        "barcode_time",
        "Time (x) variable",
        choices = d$time,
        selected = selected_time(),
        multiple = FALSE
      ),
      selectizeInput(
        "barcode_var",
        "Event variable(s)",
        choices = cat_vars,
        selected = valid_sel,
        multiple = TRUE,
        options = list(
          plugins = list("remove_button"),
          placeholder = "Select event variable(s)"
        )
      ),
      radioButtons(
        "barcode_layout",
        "Layout:",
        choices = c(
          "Stacked rows" = "stacked",
          "Overlaid (single row)" = "overlay"
        ),
        selected = "stacked",
        inline = TRUE
      )
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
  observeEvent(input$update_plot, {
    cancel_current_plot()
    request_plot_redraw()}, ignoreInit = TRUE)

  # observeEvent(input$update_labels, {
  #   cancel_current_plot()
  #   request_plot_redraw()}, ignoreInit = TRUE)

  selected_events <- reactive(input$event_overlay) |>
    debounce(0)

  selected_barcodes <- reactive(input$barcode_var) |>
    debounce(0)

  subset_data <- reactive({
    df <- data_reactive()

    if (is.null(input$subset_var) || input$subset_var == "") {
      return(df)
    }
    req(input$subset_var, input$subset_values)
    df[as.character(df[[input$subset_var]]) %in% as.character(input$subset_values),,drop = FALSE]
  })

  filtered_data <- reactive({

    df <- subset_data()

    if (!isTRUE(input$use_id)) {
      return(df)
    }

    req(input$idvar)
    id_col <- as.character(df[[input$idvar]])

    if (isTRUE(input$step_through)) {
      current_id <- as.character(all_ids()[id_index()])
      df[id_col == current_id, , drop = FALSE]
    } else {
      req(input$selected_ids)
      selected_ids <- as.character(input$selected_ids)
      df[id_col %in% selected_ids, , drop = FALSE]
    }

  }) |>
    bindCache(
      subset_data(),
      input$use_id,
      input$idvar,
      input$step_through,
      id_index(),
      input$selected_ids
    ) #attempt to reduce computational load...

  get_interval_start <- function(df) {
    df[[input$int_start]]
  }

  get_interval_end <- function(df) {
    if (input$interval_mode == "end") {
      return(df[[input$int_end]])
    }

    starts <- df[[input$int_start]]
    durs   <- as.numeric(df[[input$int_dur]])

    starts + durs
  }


  # Plot
  output$plot <- plotly::renderPlotly({

    req(input$sidebar_state == "viz")

    plot_request_id()

    validate(
      need(plot_request_id() > 0, "Choose your plotting options, then click Update Plot.")
    )

    my_request <- plot_request_id()
    my_cancel  <- plot_cancel_id()

    isolate({

      check_plot_cancelled(my_request, my_cancel)

      t0 <- Sys.time()
      on.exit({
        print(Sys.time() - t0)
      })

      fonts <- get_plot_fonts()
      margins <- get_plot_margins()

      validate(
        need(input$viz_mode, "Please select a visualization type"),
        need(data_reactive(), "Please upload data to create visualizations"),
        need(nrow(data_reactive()) > 0, "The uploaded data appears to be empty")
      )
      check_plot_cancelled(my_request, my_cancel)

      req(input$viz_mode)

    # Add mode-specific validation
    if (input$viz_mode == "Raw time series") {
      validate(
        need(input$xvar, "Please select a time variable (X-axis)"),
        need(input$yvar, "Please select at least one signal variable (Y-axis)")
      )
    }

    # Raw time series
    if (input$viz_mode == "Raw time series") {
      check_plot_cancelled(my_request, my_cancel)
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
        for (var in ordered_variables(input$yvar)) {
          check_plot_cancelled(my_request, my_cancel)
          p <- plotly::add_trace(p, x = filtered_data()[[input$xvar]], y = filtered_data()[[var]],
                                 name = get_var_label(var),legendrank = plot_label_rank(make_variable_order_key(var)),
                                 type = "scatter", mode = ifelse(input$plot_type == "Line", "lines", "markers"))
        }
      } else {
        for (var in ordered_variables(input$yvar)) {
          check_plot_cancelled(my_request, my_cancel)
          p <- plotly::add_trace(p, x = filtered_data()[[input$xvar]], y = filtered_data()[[var]],
                                 name = paste(filtered_data()[[input$idvar]], get_var_label(var)),
                                 legendrank = plot_label_rank(make_variable_order_key(var)),
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
      check_plot_cancelled(my_request, my_cancel)
      req(input$time_overlay, input$signal_overlay, selected_events)

      time_vec <- filtered_data()[[input$time_overlay]]

      # Calculate y-axis range for the rectangles
      all_vals <- unlist(lapply(input$signal_overlay, function(v) filtered_data()[[v]]))
      y_min <- min(all_vals, na.rm = TRUE)
      y_max <- max(all_vals, na.rm = TRUE)

      plot_targets <- list()

      # Helper for colors - replace with colorblind friendly??
      get_palette <- function(n) {
        if(n <= 8) RColorBrewer::brewer.pal(max(3, n), "Set2")[1:n]
        else colorRampPalette(RColorBrewer::brewer.pal(8, "Set2"))(n)
      }

      # 1. get total colors needed
      total_items <- 0
      for(col in selected_events()){
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

      # 2. Generate palette
      master_pal <- get_accessible_palette(total_items)
      color_idx <- 1

      for(col in selected_events()){
        raw_vals <- filtered_data()[[col]]
        unique_vals <- unique(raw_vals[!is.na(raw_vals)])

        # Check if strictly binary 0/1
        is_binary <- all(unique_vals %in% c(0,1))

        if(is_binary) {
          # if binary column (e.g. "Freezing") -> One color
          plot_targets[[length(plot_targets) + 1]] <- list(
            col = col,
            val = 1,
            color = master_pal[color_idx],
            legend_key = paste(col, "1", sep = "__"),
            is_binary = TRUE
          )
          color_idx <- color_idx + 1
        } else {
          # if categorical col (e.g. "Activity") -> Multiple colors
          unique_vals <- sort(unique_vals)
          unique_vals <- unique_vals[unique_vals != 0 & unique_vals != "0"]

          for(uv in unique_vals){
            plot_targets[[length(plot_targets) + 1]] <- list(
              col = col,
              val = uv,
              color = master_pal[color_idx],
              legend_key = paste(col, as.character(uv), sep = "__"),
              is_binary = FALSE
            )
            color_idx <- color_idx + 1
          }
        }
      }

      plot_targets <- ordered_plot_targets(plot_targets) #anchor

      shapes <- list()
      legend_traces <- list()
      multi_participant <- isTRUE(input$use_id) && !isTRUE(input$step_through)

      if (multi_participant) {
        req(input$idvar, input$selected_ids)
        combined_time <- c()
        combined_signals <- setNames(vector("list", length(input$signal_overlay)), input$signal_overlay)
        for (v in input$signal_overlay) combined_signals[[v]] <- c()

        for (pid in input$selected_ids) {
          check_plot_cancelled(my_request, my_cancel)
          pdf <- filtered_data()[filtered_data()[[input$idvar]] == pid, ]
          if (nrow(pdf) == 0) next
          pt <- pdf[[input$time_overlay]]
          combined_time <- c(combined_time, pt, NA)
          for (v in input$signal_overlay) combined_signals[[v]] <- c(combined_signals[[v]], pdf[[v]], NA)

          for (target in plot_targets) {
            vec <- pdf[[target$col]]
            if (input$event_format == "interval") {
              active_idx <- which(!is.na(vec) & vec == target$val)
              if (length(active_idx) > 0) {
                rgba_col <- hex_to_rgba(target$color, alpha = 0.5)
                for (i in seq_along(active_idx)) {
                  shapes[[length(shapes) + 1]] <- list(type = "rect", x0 = time_vec[active_idx[i]], x1 = end_vec[active_idx[i]], y0 = y_min, y1 = y_max, fillcolor = rgba_col, line = list(width = 0), layer = "below")
                }
                existing_keys <- vapply(
                  legend_traces,
                  function(lt) lt$legend_key,
                  character(1)
                )

                legend_traces <- add_legend_target(
                  legend_traces,
                  target
                )
              }
            } else {
              is_active <- as.numeric(!is.na(vec) & vec == target$val)
              windows <- extract_event_windows_idx(is_active)
              if (nrow(windows) > 0) {
                rgba_col <- hex_to_rgba(target$color, alpha = 0.5)
                for (i in seq_len(nrow(windows))) {
                  shapes[[length(shapes) + 1]] <- list(
                    type = "rect",
                    x0 = pt[windows$start[i]], x1 = pt[windows$end[i]],
                    y0 = y_min, y1 = y_max,
                    fillcolor = rgba_col, line = list(width = 0), layer = "below"
                  )
                }
                legend_traces <- add_legend_target(
                  legend_traces,
                  target
                )
              }
            }
          }
        }
        time_vec <- combined_time

      } else {
        for (target in plot_targets) {
          vec <- filtered_data()[[target$col]]
          if (input$event_format == "interval") {
            active_idx <- which(!is.na(vec) & vec == target$val)
            if (length(active_idx) > 0) {
              rgba_col <- hex_to_rgba(target$color, alpha = 0.5)
              for (i in seq_along(active_idx)) {
                shapes[[length(shapes) + 1]] <- list(type = "rect", x0 = time_vec[active_idx[i]], x1 = end_vec[active_idx[i]], y0 = y_min, y1 = y_max, fillcolor = rgba_col, line = list(width = 0), layer = "below")
              }
              legend_traces[[length(legend_traces) + 1]] <- target
            }
          } else {
            is_active <- as.numeric(!is.na(vec) & vec == target$val)
            windows <- extract_event_windows_idx(is_active)
            if (nrow(windows) > 0) {
              rgba_col <- hex_to_rgba(target$color, alpha = 0.5)
              for (i in seq_len(nrow(windows))) {
                shapes[[length(shapes) + 1]] <- list(
                  type = "rect",
                  x0 = time_vec[windows$start[i]], x1 = time_vec[windows$end[i]],
                  y0 = y_min, y1 = y_max,
                  fillcolor = rgba_col, line = list(width = 0), layer = "below"
                )
              }
              legend_traces[[length(legend_traces) + 1]] <- target
            }
          }
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

      # Add continuous lines
      for (var in ordered_variables(input$signal_overlay)) {
        check_plot_cancelled(my_request, my_cancel)
        y_data <- if (multi_participant) combined_signals[[var]] else filtered_data()[[var]]
        p <- plotly::add_trace(p, x = time_vec, y = y_data, legendrank = plot_label_rank(
          make_variable_order_key(var)), name = get_var_label(var), type = "scatter", mode = "lines")
      }

      for (tr in legend_traces) {
        trace_label <- if (isTRUE(tr$is_binary)) {
          get_var_label(tr$col)
        } else {
          get_event_trace_label(
            variable = tr$col,
            category = tr$val
          )
        }

        p <- plotly::add_trace(
          p,
          x = time_vec[1],
          y = y_min,
          type = "scatter",
          mode = "markers",
          marker = list(
            color = tr$color,
            symbol = "square"
          ),
          name = trace_label,
          legendgroup = tr$legend_key,
          legendrank = plot_label_rank(target_order_key(tr)),
          visible = "legendonly",
          hoverinfo = "skip"
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
      check_plot_cancelled(my_request, my_cancel)
      req(input$event_var, input$signal_var)
      windows <- extract_event_windows_idx(filtered_data()[[input$event_var]])
      req(nrow(windows) > 0)
      time_vec <- filtered_data()[[input$xvar]]
      i <- min(event_index(), nrow(windows))
      d <- diagnostics()
      time_vec <- filtered_data()[[input$xvar]]
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

      labs <- get_labels(
        default_title = paste(
          get_var_label(input$signal_var),
          "around",
          get_var_label(input$event_var),
          "event",
          i
        ),
        default_x = "Time relative to event (s)",
        default_y = get_var_label(input$signal_var),
        default_legend = ""
      )

      p <- plotly::plot_ly(
        x = x_vals,
        y = y_vals,
        type = "scatter",
        mode = "lines",
        name = get_var_label(input$signal_var),
        legendrank = plot_label_rank(
          make_variable_order_key(input$signal_var)
        )
      )



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
      check_plot_cancelled(my_request, my_cancel)
      req(input$event_var, input$signal_var)

      win <- (-input$pre):input$post
      win_len <- length(win)

      # Loop per participant to avoid epoch windows bleeding across participant boundaries
      multi_participant <- isTRUE(input$use_id) && !isTRUE(input$step_through)

      if (multi_participant) {
        req(input$idvar, input$selected_ids)
        all_rows <- list()
        for (pid in input$selected_ids) {
          check_plot_cancelled(my_request, my_cancel)
          pdf <- filtered_data()[filtered_data()[[input$idvar]] == pid, ]
          if (nrow(pdf) == 0) next
          pw <- extract_event_windows_idx(pdf[[input$event_var]])
          if (nrow(pw) == 0) next
          for (i in seq_len(nrow(pw))) {
            valid_win <- pw$start[i] + win
            in_bounds <- valid_win > 0 & valid_win <= nrow(pdf)
            snippet <- rep(NA_real_, win_len)
            snippet[in_bounds] <- pdf[[input$signal_var]][valid_win[in_bounds]]
            all_rows[[length(all_rows) + 1]] <- snippet
          }
        }
        validate(need(length(all_rows) > 0, "No events found across selected participants."))
        mat <- do.call(rbind, all_rows)
      } else {
        windows <- extract_event_windows_idx(filtered_data()[[input$event_var]])
        req(nrow(windows) > 0)
        mat <- do.call(rbind, lapply(seq_len(nrow(windows)), function(i) {
          valid_win <- windows$start[i] + win
          in_bounds <- valid_win > 0 & valid_win <= nrow(filtered_data())
          snippet <- rep(NA_real_, win_len)
          snippet[in_bounds] <- filtered_data()[[input$signal_var]][valid_win[in_bounds]]
          snippet
        }))
      }

      avg <- colMeans(mat, na.rm = TRUE)

      # Get Labels
      labs <- get_labels(
        default_title = paste(
          "Average",
          get_var_label(input$signal_var),
          "trajectory around",
          get_var_label(input$event_var)
        ),
        default_x = "Time relative to event",
        default_y = get_var_label(input$signal_var),
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
          p <- plotly::add_lines(p, x = win, y = mat[i, ],
                                 opacity = 0.3, line = list(color = "gray"),
                                 showlegend = FALSE)
        }
      }
      p <- p |> plotly::layout(
        title = list(text = labs$title, font = list(size = fonts$title_size)),
        xaxis = list(
          title = list(text = labs$x, font = list(size = fonts$axis_title_size), standoff = 5),
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

    # event durations (barcode anchor)
    if (input$viz_mode == "Event durations (barcode)") {
      check_plot_cancelled(my_request, my_cancel)

      req(selected_barcodes())

      plot_df <- filtered_data()

      # Temporary check
      print(unique(plot_df[[input$idvar]]))
      print(nrow(plot_df))

      if (input$event_format == "interval") {

        req(input$int_start)

        if (input$interval_mode == "end") {
          req(input$int_end)
          start_vec_all <- plot_df[[input$int_start]]
          end_vec_all   <- plot_df[[input$int_end]]
        } else {
          req(input$int_dur)
          start_vec_all <- plot_df[[input$int_start]]
          end_vec_all   <- plot_df[[input$int_start]] + as.numeric(plot_df[[input$int_dur]])
        }

        valid_idx <- !is.na(start_vec_all) & !is.na(end_vec_all)

        df_clean  <- plot_df[valid_idx, , drop = FALSE]
        time_vec  <- start_vec_all[valid_idx]
        start_vec <- start_vec_all[valid_idx]
        end_vec   <- end_vec_all[valid_idx]

      } else {

        req(input$barcode_time)

        valid_idx <- !is.na(plot_df[[input$barcode_time]])

        df_clean <- plot_df[valid_idx, , drop = FALSE]
        time_vec <- df_clean[[input$barcode_time]]
      }

      req(nrow(df_clean) > 0)
      print(nrow(df_clean))
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
        x_positions <- as.numeric(time_vec)
      }

      plot_targets <- list()

      multiple_barcode_vars <- length(selected_barcodes()) > 1

      for (col in selected_barcodes()) {
        col_data <- df_clean[[col]]

        unique_vals <- unique(
          col_data[!is.na(col_data)]
        )

        # Sort when possible, but avoid errors for unusual classes.
        unique_vals <- tryCatch(
          sort(unique_vals),
          error = function(e) unique_vals
        )

        is_binary <- all(
          as.character(unique_vals) %in% c("0", "1")
        )

        if (is_binary) {
          plot_targets[[length(plot_targets) + 1]] <- list(
            col = col,
            val = 1,
            is_binary = TRUE,
            legend_key = paste(
              col,
              "1",
              sep = "__"
            )
          )
        } else {
          unique_vals <- unique_vals[
            !as.character(unique_vals) %in% c("0")
          ]

          for (uv in unique_vals) {
            plot_targets[[length(plot_targets) + 1]] <- list(
              col = col,
              val = uv,
              is_binary = FALSE,
              legend_key = paste(
                col,
                as.character(uv),
                sep = "__"
              )
            )
          }
        }
      }

      n_targets <- length(plot_targets)
      req(n_targets > 0)

      pal <- get_accessible_palette(n_targets)

      for (i in seq_along(plot_targets)) {
        plot_targets[[i]]$color <- pal[i]
      } #making sure colors stay the same when labels are reordered

      plot_targets <- ordered_plot_targets(plot_targets)

      use_stacked <- isTRUE(input$barcode_layout == "stacked") && n_targets > 1

      p <- plotly::plot_ly()

      row_height <- if (use_stacked) 1 / n_targets else 1

      event_df <- data.frame()

      for (t_idx in seq_along(plot_targets)) {

        target <- plot_targets[[t_idx]]
        col_data <- df_clean[[target$col]]

        if (input$event_format == "interval") {

          active_idx <- which(!is.na(col_data) & col_data == target$val)

          if (length(active_idx) > 0) {

            tmp <- data.frame(
              target_idx = t_idx,
              variable = target$col,
              category = as.character(target$val),
              is_binary = target$is_binary,
              legend_key = target$legend_key,
              start = start_vec[active_idx],
              end = end_vec[active_idx],
              color = target$color,
              participant_id = if (isTRUE(input$use_id)) {
                as.character(
                  df_clean[[input$idvar]][active_idx]
                )
              } else {
                NA_character_
              },
              stringsAsFactors = FALSE
            )

            event_df <- rbind(event_df, tmp)
          }

        } else {

          is_active <- as.numeric(!is.na(col_data) & col_data == target$val)

          windows <- extract_event_windows_idx(is_active)

          if (nrow(windows) > 0) {

            tmp <- data.frame(
              target_idx = t_idx,
              variable = target$col,
              category = as.character(target$val),
              is_binary = target$is_binary,
              legend_key = target$legend_key,
              start = time_vec[windows$start],
              end = time_vec[windows$end],
              color = target$color,
              participant_id = if (isTRUE(input$use_id)) {
                as.character(
                  df_clean[[input$idvar]][windows$start]
                )
              } else {
                NA_character_
              },
              stringsAsFactors = FALSE
            )

            event_df <- rbind(event_df, tmp)
          }
        }
      }

      legend_added <- rep(FALSE, n_targets)

      for (i in seq_len(nrow(event_df))) {

        ev <- event_df[i, ]

        t_idx <- ev$target_idx

        display_label <- get_barcode_target_label(
          variable = as.character(ev$variable),
          category = as.character(ev$category),
          is_binary = isTRUE(as.logical(ev$is_binary)),
          show_variable = multiple_barcode_vars
        )

        if (use_stacked) {

          gap <- row_height * 0.05

          y_bottom <- 1 - (t_idx * row_height) + gap
          y_top <- 1 - ((t_idx - 1) * row_height) - gap

        } else {

          y_bottom <- 0
          y_top <- 1
        }

        start_time <- ev$start
        end_time <- ev$end

        if (input$event_format == "interval") {

          if (is_datetime) {

            x_start <- as.numeric(start_time)
            x_end <- as.numeric(end_time)

          } else {

            x_start <- start_time
            x_end <- end_time
          }

        } else {

          start_idx <- which(time_vec == start_time)[1]
          end_idx <- which(time_vec == end_time)[1]

          x_start <- x_positions[start_idx]
          x_end <- x_positions[end_idx]
        }

        is_point <- isTRUE(all.equal(x_start, x_end))

        if (is_point) {

          x_vals <- c(
            x_start,
            x_start,
            NA
          )

          y_vals <- c(
            y_bottom,
            y_top,
            NA
          )

          hover_text <- rep(
            paste0(
              display_label,
              "<br>",
              as.character(start_time)
            ),
            3
          )

          p <- plotly::add_trace(
            p,
            x = x_vals,
            y = y_vals,
            type = "scatter",
            mode = "lines",
            line = list(
              color = hex_to_rgba(ev$color, alpha = 0.8),
              width = 1.75
            ),
            hoverinfo = "text",
            text = hover_text,
            name = display_label,
            legendgroup = ev$legend_key,
            showlegend= !use_stacked && !legend_added[t_idx] #anchor
          )

        } else {

          x_poly <- c(
            x_start,
            x_end,
            x_end,
            x_start,
            x_start,
            NA
          )

          y_poly <- c(
            y_bottom,
            y_bottom,
            y_top,
            y_top,
            y_bottom,
            NA
          )

          hover_text <- rep(
            paste0(
              display_label,
              "<br>Start: ",
              as.character(start_time),
              "<br>End: ",
              as.character(end_time)
            ),
            length(x_poly)
          )

          p <- plotly::add_trace(
            p,
            x = x_poly,
            y = y_poly,
            type = "scatter",
            mode = "lines",
            fill = "toself",
            fillcolor = hex_to_rgba(
              ev$color,
              alpha = if (use_stacked) 0.9 else 0.65
            ),
            line = list(
              color = ev$color,
              width = 1
            ),
            hoverinfo = "text",
            text = hover_text,
            name = display_label,
            legendgroup = ev$legend_key,
            showlegend = !use_stacked && !legend_added[t_idx]
          )
        }

        legend_added[t_idx] <- TRUE
      }

      if (use_stacked) {

        tick_vals_y <- sapply(seq_along(plot_targets), function(i) {

          y_bottom <- 1 - (i * row_height)
          y_top <- 1 - ((i - 1) * row_height)

          (y_bottom + y_top) / 2
        })

        tick_labels_y <- paste0(
          vapply(
            plot_targets,
            function(target) {
              get_barcode_target_label(
                variable = target$col,
                category = target$val,
                is_binary = target$is_binary,
                show_variable = multiple_barcode_vars
              )
            },
            character(1)
          ),
          "  "
        )

        y_axis_config <- list(
          title = list(text = ""),
          range = c(0, 1),
          showgrid = FALSE,
          zeroline = FALSE,
          tickmode = "array",
          tickvals = tick_vals_y,
          ticktext = tick_labels_y,
          tickfont = list(size = fonts$axis_text_size),
          automargin = TRUE
        )

      } else {

        y_axis_config <- list(
          title = list(text = ""),
          range = c(0, 1),
          showgrid = FALSE,
          zeroline = FALSE,
          showticklabels = FALSE,
          automargin = TRUE
        )
      }


      labs <- get_labels(
        default_title = paste0(
          "Event Barcode: ",
          paste0(
            vapply(
              ordered_variables(selected_barcodes()),
              get_var_label,
              character(1)
            ),
            collapse = ", "
          )
        ),
        default_x = if (input$event_format == "interval")
          input$int_start
        else
          input$barcode_time,
        default_y = "",
        default_legend = "Events"
      )

      if (use_stacked)
        margins$l <- max(margins$l, 0)

      margins$b <- max(margins$b, 0)

      if (is_datetime) {

        time_range_secs <- as.numeric(
          difftime(
            max(time_vec, na.rm = TRUE),
            min(time_vec, na.rm = TRUE),
            units = "secs"
          )
        )

        if (time_range_secs < 3600) {

          tick_fmt <- "%H:%M:%S"

        } else if (time_range_secs < 86400) {

          tick_fmt <- "%H:%M"

        } else {

          tick_fmt <- "%m-%d %H:%M"
        }

        x_axis_config <- list(
          title = list(
            text = labs$x,
            font = list(size = fonts$axis_title_size),
            standoff = 5
          ),
          tickfont = list(
            size = fonts$axis_text_size
          ),
          type = "date",
          tickformat = tick_fmt,
          nticks = 10,
          tickangle = -45
        )

      } else {

        x_axis_config <- list(
          title = list(
            text = labs$x,
            font = list(size = fonts$axis_title_size),
            standoff = 5
          ),
          tickfont = list(
            size = fonts$axis_text_size
          )
        )
      }

      p <- p |>
        plotly::layout(
          title = list(
            text = labs$title,
            font = list(size = fonts$title_size)
          ),
          xaxis = x_axis_config,
          yaxis = y_axis_config,
          showlegend = !use_stacked,
          legend = list(
            title = list(
              text = labs$legend,
              font = list(size = fonts$legend_size)
            ),
            font = list(
              size = fonts$legend_size
            )
          ),
          margin = margins
        )

      plot_store(p)
      return(p)
    }

    })

  })
    # End of plotting

  #Dynamic desc stats
  output$stats_section <- renderUI({
    #req(input$viz_mode)
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
      tagList(
        hr(),

        tags$div(
          class = "panel panel-default",
          style = "margin-bottom: 15px;",

          tags$div(
            class = "panel-heading",
            style = "padding: 0;",

            tags$a(
              href = "#descriptive-stats-collapse",
              `data-toggle` = "collapse",
              `aria-expanded` = "false",
              `aria-controls` = "descriptive-stats-collapse",
              style = paste(
                "display: flex;",
                "align-items: center;",
                "justify-content: space-between;",
                "width: 100%;",
                "padding: 11px 14px;",
                "color: #333;",
                "text-decoration: none;",
                "cursor: pointer;"
              ),

              tags$span(
                style = "font-size: 16px; font-weight: 500;",
                icon("chart-simple"),
                " Descriptive Statistics"
              ),

              tags$span(
                style = "font-size: 13px; color: #337ab7;",
                "View ",
                icon("chevron-down")
              )
            )
          ),

          tags$div(
            id = "descriptive-stats-collapse",
            class = "panel-collapse collapse",

            tags$div(
              class = "panel-body",
              verbatimTextOutput("desc_stats")
            )
          )
        )
      )
    } else {
      NULL
    }
  })

  # Descriptive statistics
  stats_text <- reactive({

    req(input$viz_mode)
    df <- data_reactive()

    if (isTRUE(input$use_id)) {
      req(input$idvar)
      ids_to_process <- if (isTRUE(input$step_through)) all_ids()[id_index()] else input$selected_ids
    } else {
      ids_to_process <- "All Data"
      df$temp_id <- "All Data"
    }

    id_col <- if (isTRUE(input$use_id)) input$idvar else "temp_id"

    # Zoom filtering
    range       <- visible_range()
    zoom_active <- !is.null(range)
    range_label <- NULL

    if (zoom_active) {
      time_col <- switch(input$viz_mode,
                         "Raw time series"            = input$xvar,
                         "Event + Continuous Overlay" = input$time_overlay,
                         "Event durations (barcode)"  = input$barcode_time,
                         diagnostics()$time[1]
      )
      if (!is.null(time_col) && time_col %in% names(df)) {
        time_vals <- df[[time_col]]
        if (inherits(time_vals, c("POSIXct", "POSIXt"))) {
          x_min <- as.POSIXct(as.numeric(range$min) / 1000, origin = "1970-01-01", tz = "UTC")
          x_max <- as.POSIXct(as.numeric(range$max) / 1000, origin = "1970-01-01", tz = "UTC")
          df    <- df[!is.na(time_vals) & time_vals >= x_min & time_vals <= x_max, ]
          range_label <- paste("From", format(x_min, "%H:%M:%S"), "to", format(x_max, "%H:%M:%S"))
        } else {
          x_min <- as.numeric(range$min)
          x_max <- as.numeric(range$max)
          df    <- df[!is.na(time_vals) & time_vals >= x_min & time_vals <= x_max, ]
          range_label <- paste("From", round(x_min, 2), "to", round(x_max, 2), "seconds")
        }
      }
    }

    cont_vars  <- NULL
    event_vars <- NULL
    calc_type  <- NULL

    if (input$viz_mode == "Event + Continuous Overlay") {
      req(input$signal_overlay, selected_events)
      cont_vars  <- input$signal_overlay
      event_vars <- selected_events
      calc_type  <- "both"
    } else if (input$viz_mode == "Raw time series") {
      req(input$yvar)
      cont_vars <- input$yvar
      calc_type <- "continuous"
    } else if (input$viz_mode == "Event durations (barcode)") {
      req(selected_barcodes)
      event_vars <- selected_barcodes
      calc_type  <- "event"
    } else if (grepl("Event-locked", input$viz_mode)) {
      req(input$signal_var)
      cont_vars <- input$signal_var
      calc_type <- "continuous"
    }

    if (is.null(calc_type) || length(ids_to_process) == 0) {
      return("No statistics available for this view.")
    }

    txt <- capture.output({
      for (id in ids_to_process) {
        sub_df <- df[df[[id_col]] == id, ]

        if (id != "All Data") {
          cat(paste("Participant:", id, "\n"))
          cat(paste(rep("-", 40), collapse = ""), "\n")
        }

        if (calc_type == "both") {

          # continuous
          if (length(cont_vars) > 0) {
            cat("  Continuous signals:\n")
            for (c_var in cont_vars) {
              c_vals <- sub_df[[c_var]]
              cat(sprintf("    %-20s  Mean: %.4f,  SD: %.4f\n",
                          c_var,
                          mean(c_vals, na.rm = TRUE),
                          sd(c_vals,   na.rm = TRUE)))
            }
            cat("\n")
          }

          # event vars
          if (length(event_vars()) > 0) {
            cat("  Event variables:\n")

            for (e_var in event_vars()) {

              e_vals <- sub_df[[e_var]]
              counts <- get_event_counts(e_vals)

              is_bin <- is_binary_event_vector(e_vals)
              b_results <- get_app_burstiness(sub_df, e_var)

              if (is_bin) {
                b_row <- b_results[1, ]

                b_str <- format_burstiness_value(
                  value = b_row$burstiness,
                  n_events = b_row$n_events
                )

                cat(sprintf(
                  paste0(
                    "    %-20s  Count: %d, ",
                    "Total duration (rows): %d, ",
                    "Burstiness: %s\n"
                  ),
                  e_var,
                  counts$n_events,
                  counts$total_duration,
                  b_str
                ))
              } else {
                cat(sprintf(
                  paste0(
                    "    %-20s  Count: %d, ",
                    "Total duration (rows): %d ",
                    "(Categorical: %d types)\n"
                  ),
                  e_var,
                  counts$n_events,
                  counts$total_duration,
                  nrow(b_results)
                ))

                for (j in seq_len(nrow(b_results))) {
                  b_row <- b_results[j, ]

                  b_str <- format_burstiness_value(
                    value = b_row$burstiness,
                    n_events = b_row$n_events
                  )

                  cat(sprintf(
                    "      %-16s  Episodes: %d, Burstiness: %s\n",
                    b_row$event,
                    b_row$n_events,
                    b_str
                  ))
                }
              }
            }

            cat("\n")
          }

        } else if (calc_type == "continuous") {

          for (var_name in cont_vars) {
            vals <- sub_df[[var_name]]
            cat(paste("  Variable:", var_name, "\n"))
            cat(sprintf("    Mean: %.4f,  SD: %.4f\n",
                        mean(vals, na.rm = TRUE), sd(vals, na.rm = TRUE)))
          }
          cat("\n")

        } else if (calc_type == "event") {

          for (e_var in event_vars()) {
            vals <- sub_df[[e_var]]
            counts <- get_event_counts(vals)

            is_bin <- is_binary_event_vector(vals)
            b_results <- get_app_burstiness(sub_df, e_var)

            cat(paste("  Variable:", e_var, "\n"))
            cat(sprintf(
              "    Event count:           %d\n",
              counts$n_events
            ))
            cat(sprintf(
              "    Total duration (rows): %d\n",
              counts$total_duration
            ))

            if (is_bin) {
              b_row <- b_results[1, ]

              cat(sprintf(
                "    Burstiness:            %s\n",
                format_burstiness_value(
                  value = b_row$burstiness,
                  n_events = b_row$n_events
                )
              ))
            } else {
              cat("    Burstiness by event type:\n")

              for (j in seq_len(nrow(b_results))) {
                b_row <- b_results[j, ]

                cat(sprintf(
                  "      %-3s Episodes: %d, Burstiness: %s\n",
                  b_row$event,
                  b_row$n_events,
                  format_burstiness_value(
                    value = b_row$burstiness,
                    n_events = b_row$n_events
                  )
                ))
              }
            }
          }

          cat("\n")
        }
      }
    })

    header <- if (zoom_active && !is.null(range_label)) {
      c(paste("  Time window:", range_label),
        paste(rep("-", 60), collapse = ""))
    } else {
      c(paste(rep("-", 60), collapse = ""),
        "  Time window: Full dataset",
        paste(rep("-", 60), collapse = ""))
    }

    paste(c(header, "", txt), collapse = "\n")
  })

  observe({ stats_store(stats_text()) })

  output$desc_stats <- renderPrint({
    cat(stats_text())
  })

  output$plot2 <- plotly::renderPlotly({
    req(input$show_second_plot)
    req(input$second_plot_type)

    df <- data_reactive()

    # single ID filtering
    if (isTRUE(input$use_id)) {
      req(input$idvar)
      pid <- if (isTruthy(input$second_plot_id)) {
        input$second_plot_id
      } else {
        all_ids()[1]
      }
      df <- df[df[[input$idvar]] == pid, ]
    }

    fonts <- get_plot_fonts()
    margins <- get_plot_margins()

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

      if (!1 %in% y_ticks) y_ticks <- sort(c(y_ticks, 1))

      p2 <- p2 |> plotly::layout(
        title = list(text = slope_text, font = list(size = fonts$title_size)),
        xaxis = list(
          title = list(text = "Window Size T (sec)", font = list(size = fonts$axis_title_size)),
          tickfont = list(size = fonts$axis_text_size),
          type = "log",
          tickmode = "array",
          # tickvals = x_ticks,
          # ticktext = as.character(x_ticks),
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
          # tickvals = log10(y_ticks),
          # ticktext = as.character(log10(y_ticks)),
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

      x_range_ad <- range(ad_result$tau, na.rm = TRUE)
      y_range_ad <- range(y_vals, na.rm = TRUE)

      x_log_min_ad <- floor(log10(x_range_ad[1]))
      x_log_max_ad <- ceiling(log10(x_range_ad[2]))
      x_ticks_ad <- 10^(x_log_min_ad:x_log_max_ad)
      x_ticks_ad <- x_ticks_ad[x_ticks_ad >= x_range_ad[1] * 0.5 &
                                 x_ticks_ad <= x_range_ad[2] * 2]

      y_log_min_ad <- floor(log10(max(y_range_ad[1], 1e-10)))
      y_log_max_ad <- ceiling(log10(y_range_ad[2]))
      y_ticks_ad <- 10^(y_log_min_ad:y_log_max_ad)
      y_ticks_ad <- y_ticks_ad[y_ticks_ad >= y_range_ad[1] * 0.5 &
                                 y_ticks_ad <= y_range_ad[2] * 2]

      p2 <- p2 |> plotly::layout(
        title = list(text = plot_title, font = list(size = fonts$title_size)),
        xaxis = list(
          title = list(text = "Tau (s)", font = list(size = fonts$axis_title_size)),
          tickfont = list(size = fonts$axis_text_size),
          type = "log",
          tickmode = "array",
          tickvals = x_ticks_ad,
          ticktext = as.character(x_ticks_ad)
        ),
        yaxis = list(
          title = list(text = y_label, font = list(size = fonts$axis_title_size)),
          tickfont = list(size = fonts$axis_text_size),
          type = "log",
          tickmode = "array",
          tickvals = y_ticks_ad,
          ticktext = as.character(y_ticks_ad)
        ),
        legend = list(font = list(size = fonts$legend_size)),
        margin = margins
      )

      plot2_store(p2)
      return(p2)
    }
  })

  # plot descriptions
  output$plot_description <- renderText({
    req(input$sidebar_state == "viz")
    req(input$viz_mode)

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
                     if (!is.null(input$signal_overlay) && !is.null(selected_events)) {
                       paste("Overlay plot combining", length(input$signal_overlay), "continuous signal(s) with",
                             length(selected_events), "event type(s) over", input$time_overlay)
                     } else {
                       "Event overlay plot - select signals and events to view description"
                     }
                   },

                   "Event durations (barcode)" = {
                     if (!is.null(selected_barcodes)) {
                       paste("Barcode plot showing event durations and patterns for", selected_barcodes,
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

  # Main Plot HTML
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

  observeEvent(input$download_plot_png, {
    if (is.null(plot_store())) {
      showNotification("No plot available to save.", type = "error")
      return()
    }
    session$sendCustomMessage("downloadPlot", list(
      elementId = "plot",
      format    = "png",
      filename  = paste0("plot_", Sys.Date()),
      width     = 1200,
      height    = 700,
      scale     = 2        # 2x for print quality
    ))
  })

  observeEvent(input$download_plot_svg, {
    if (is.null(plot_store())) {
      showNotification("No plot available to save.", type = "error")
      return()
    }
    session$sendCustomMessage("downloadPlot", list(
      elementId = "plot",
      format    = "svg",
      filename  = paste0("plot_", Sys.Date()),
      width     = 1200,
      height    = 700,
      scale     = 1        # scale ignored for SVG but required by API
    ))
  })

  # Stats txt
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

  # Stats csv
  output$toolbar_download_stats_csv <- downloadHandler(
    filename = function() {
      paste0("stats_", Sys.Date(), ".csv")
    },
    content = function(file) {
      df <- data_reactive()

      if (isTRUE(input$use_id)) {
        id_col         <- input$idvar
        ids_to_process <- if (isTRUE(input$step_through)) all_ids()[id_index()] else input$selected_ids
      } else {
        df$temp_id     <- "All Data"
        id_col         <- "temp_id"
        ids_to_process <- "All Data"
      }

      # All modes produce the same columns; NA where not applicable
      make_row <- function(id, variable, type,
                           event_count = NA_integer_, total_duration = NA_integer_,
                           mean = NA_real_, sd = NA_real_,
                           min = NA_real_, max = NA_real_,
                           burstiness = NA_real_) {
        data.frame(
          Participant    = id,
          Variable       = variable,
          Type           = type,
          Event_Count    = event_count,
          Total_Duration = total_duration,
          Mean           = mean,
          SD             = sd,
          Min            = min,
          Max            = max,
          Burstiness     = burstiness,
          stringsAsFactors = FALSE
        )
      }

      results <- lapply(ids_to_process, function(id) {
        sub_df <- df[df[[id_col]] == id, ]
        rows   <- list()

        if (input$viz_mode == "Raw time series" && !is.null(input$yvar)) {
          for (v in input$yvar) {
            vals <- sub_df[[v]]
            rows[[length(rows) + 1]] <- make_row(
              id, v, "Continuous",
              mean = round(mean(vals, na.rm = TRUE), 4),
              sd   = round(sd(vals,   na.rm = TRUE), 4),
              min  = round(min(vals,  na.rm = TRUE), 4),
              max  = round(max(vals,  na.rm = TRUE), 4)
            )
          }

        } else if (input$viz_mode == "Event + Continuous Overlay" &&
                   !is.null(input$signal_overlay) && !is.null(selected_events)) {
          for (v in input$signal_overlay) {
            vals <- sub_df[[v]]
            rows[[length(rows) + 1]] <- make_row(
              id, v, "Continuous",
              mean = round(mean(vals, na.rm = TRUE), 4),
              sd   = round(sd(vals,   na.rm = TRUE), 4),
              min  = round(min(vals,  na.rm = TRUE), 4),
              max  = round(max(vals,  na.rm = TRUE), 4)
            )
          }
          for (v in selected_events()) {
            vals   <- sub_df[[v]]
            b      <- get_burstiness(vals)
            counts <- get_event_counts(vals)
            rows[[length(rows) + 1]] <- make_row(
              id, v, "Event",
              event_count    = counts$n_events,
              total_duration = counts$total_duration,
              burstiness     = if (!is.na(b)) round(b, 4) else NA_real_
            )
          }

        } else if (input$viz_mode == "Event durations (barcode)" && !is.null(selected_barcodes)) {
          for (v in selected_barcodes()) {
            vals   <- sub_df[[v]]
            b      <- get_burstiness(vals)
            counts <- get_event_counts(vals)
            rows[[length(rows) + 1]] <- make_row(
              id, v, "Event",
              event_count    = counts$n_events,
              total_duration = counts$total_duration,
              burstiness     = if (!is.na(b)) round(b, 4) else NA_real_
            )
          }

        } else if (grepl("Event-locked", input$viz_mode) && !is.null(input$signal_var)) {
          vals <- sub_df[[input$signal_var]]
          rows[[length(rows) + 1]] <- make_row(
            id, input$signal_var, "Continuous",
            mean = round(mean(vals, na.rm = TRUE), 4),
            sd   = round(sd(vals,   na.rm = TRUE), 4),
            min  = round(min(vals,  na.rm = TRUE), 4),
            max  = round(max(vals,  na.rm = TRUE), 4)
          )
        }

        if (length(rows) == 0) return(NULL)
        do.call(rbind, rows)
      })

      results <- Filter(Negate(is.null), results)

      final <- if (length(results) > 0) {
        do.call(rbind, results)
      } else {
        data.frame(Note = "No statistics available for this visualization mode.")
      }

      write.csv(final, file, row.names = FALSE)
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
