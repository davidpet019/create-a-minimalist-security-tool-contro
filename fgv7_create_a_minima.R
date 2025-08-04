# File: fgv7_create_a_minima.R
# Description: A minimalist security tool controller
# Author: [Your Name]
# Version: 1.0

# Load necessary libraries
library(shiny)

# Define UI for the application
ui <- fluidPage(
  titlePanel("Minimalist Security Tool Controller"),
  
  sidebarLayout(
    sidebarPanel(
      textInput("username", "Username:"),
      passwordInput("password", "Password:"),
      actionButton("login", "Login")
    ),
    
    mainPanel(
      tabsetPanel(
        tabPanel("System Info", textOutput("sysInfo")),
        tabPanel("Network Info", textOutput("netInfo")),
        tabPanel("Process List", tableOutput("procList"))
      )
    )
  )
)

# Define server logic
server <- function(input, output) {
  # Login functionality
  loginAttempt <- eventReactive(input$login, {
    if (input$username == "admin" && input$password == "password") {
      return(TRUE)
    } else {
      return(FALSE)
    }
  })
  
  # System info
  output$sysInfo <- renderText({
    if (loginAttempt()) {
     paste("System Information:\n",
            "- OS: ", Sys.info()["sysname"], "\n",
            "- Version: ", Sys.info()["release"], "\n",
            "- Machine: ", Sys.info()["machine"], "\n",
            sep = "")
    } else {
      "Access denied!"
    }
  })
  
  # Network info
  output$netInfo <- renderText({
    if (loginAttempt()) {
      paste("Network Information:\n",
            "- IP Address: ", Sys.getenv("REMOTE_ADDR"), "\n",
            "- Hostname: ", Sys.info()["nodename"], "\n",
            sep = "")
    } else {
      "Access denied!"
    }
  })
  
  # Process list
  output$procList <- renderTable({
    if (loginAttempt()) {
      ps <- system("ps aux", intern = TRUE)
      ps <- ps[order(ps[, 3], decreasing = TRUE), ]
      colnames(ps) <- c("User", "PID", "CPU", "MEM", "VSZ", "RSS", "TTY", "STAT", "START", "TIME", "COMMAND")
      ps
    } else {
      data.frame(Access = "Denied")
    }
  })
}

# Run the application
shinyApp(ui = ui, server = server)