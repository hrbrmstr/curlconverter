#' #' cURL Command-line Workbench
#' #'
#' #' @export
#' curlAddin <- function() {
#'
#'   # Get the document context.
#'   context <- rstudioapi::getActiveDocumentContext()
#'
#'   # Set the default data to use based on the selection.
#'   defaultData <- read_clip()
#'   defaultData <- if (any(grepl("curl", defaultData))) defaultData else ""
#'   defaultData <- paste0(defaultData, collapse = "\n")
#'
#'   # Generate UI for the gadget.
#'   ui <- miniPage(
#'     gadgetTitleBar("cURL Command-line Workbench"),
#'     miniTabstripPanel(
#'       miniTabPanel(
#'         "cURL Command-line",
#'         icon = icon("terminal"),
#'         miniContentPanel(
#'           div(
#'             textAreaInput(
#'               inputId = "curl_cmd", label = "",
#'               width = "100%", height = "100%",
#'               value = defaultData,
#'               resize='both'
#'             ),
#'             style = "width:750px; height:700px"
#'           )
#'         )
#'       ),
#'       miniTabPanel(
#'         "Parsed Parameters",
#'         icon = icon("flask"),
#'         miniContentPanel(
#'           verbatimTextOutput("straight")
#'         )
#'       ),
#'       miniTabPanel(
#'         "Crafted httr VERB() ƒunction",
#'         icon = icon("code"),
#'         miniContentPanel(
#'           div(
#'             textAreaInput(
#'               "req", "",
#'               width = "100%", height = "100%",
#'               value="", resize='both'
#'             ),
#'             style = "width:750px; height:700px"
#'           )
#'         )
#'       )
#'     )
#'   )
#'
#'   # Server code for the gadget.
#'   server <- function(input, output, session) {
#'
#'     reactiveData <- reactive({
#'       dataString <- input$curl_cmd
#'       dataString
#'     })
#'
#'     output$straight <- renderText({
#'       data <- reactiveData()
#'       if (nzchar(data) > 0) {
#'         st <- straighten(data)
#'         req <- make_req(st)
#'         updateTextAreaInput(session, "req", value=gsub("\\n", "<br/>\\n", read_clip()))
#'         jsonlite::toJSON(st[[1]], auto_unbox=TRUE, pretty=TRUE)
#'       } else {
#'         ""
#'       }
#'     })
#'
#'     # Listen for 'done'.
#'     observeEvent(input$done, {
#'       stopApp(TRUE)
#'     })
#'   }
#'
#'   # Use a modal dialog as a viewr.
#'   viewer <- dialogViewer("cURL Command-line Workbench", width = 800, height = 800)
#'   runGadget(ui, server, viewer = viewer)
#'
#' }