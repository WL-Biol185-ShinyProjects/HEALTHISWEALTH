library(shiny)
library(bslib)

navbarPage(
  navset_tab(
    nav_panel(
      "PCOS Heatmap",
      plotOutput("pcosMap", height = "600px")
    ),
    nav_panel("B", "Page B content"),
    nav_panel("C", "Page C content"),
    nav_menu( 
      "Other links", 
      nav_panel("D", "Panel D content"), 
      "----", 
      "Description:", 
      nav_item( 
        a("Shiny", href = "https://shiny.posit.co", target = "_blank") 
      ), 
    ), 
  ), 
  id = "tab" 
)
  



