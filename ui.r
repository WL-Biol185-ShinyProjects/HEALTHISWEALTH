library(shiny)
library(bslib)
library(leaflet)
library(shinyjs)
library(wordcloud2)
library(tm)
library(RColorBrewer)
library(plotly)

navbarPage("Health is Wealth",
            tabPanel("About",
            tags$head(
             tags$style(HTML("
        @import url('https://fonts.googleapis.com/css2?family=Playfair+Display:wght@700;900&family=Source+Sans+3:wght@400;600&display=swap');

        body { font-family: 'Source Sans 3', sans-serif; }

        .about-section {
          max-width: 1500px;
          margin: 30px auto 60px;
          padding: 0 24px;
        }
        
        .about-card {
          background: #ffffff;
          border-radius: 24px;
          padding: 48px 52px;
          box-shadow: 0 20px 60px rgba(230,57,133,0.12), 0 4px 16px rgba(0,0,0,0.06);
          border-top: 6px solid #e63985;
        }
        .about-label {
          font-size: 1.5rem; font-weight: 700;
          letter-spacing: 0.15em; text-transform: uppercase;
          color: #e63985; margin-bottom: 12px;
        }
        .about-heading {
          font-family: 'Playfair Display', serif;
          font-size: 3rem; font-weight: 700;
          color: #1a1a2e; margin-bottom: 24px; line-height: 1.25;
        }
        .about-heading span { color: #e63985; }
        .about-text { font-size: 2.0rem; line-height: 1.85; color: #444; margin-bottom: 18px; }
        .stat-row { display: flex; gap: 16px; flex-wrap: wrap; margin-top: 32px; }
        .stat-pill {
          flex: 1; min-width: 150px;
          background: linear-gradient(135deg, #fff0f7, #fff8f0);
          border: 2px solid #f7c5de; border-radius: 16px;
          padding: 20px 24px; text-align: center;
        }
        .stat-number {
          font-family: 'Playfair Display', serif;
          font-size: 2.2rem; font-weight: 900; color: #e63985; display: block;
        }
        .stat-desc {
          font-size: 0.82rem; font-weight: 600; color: #888;
          text-transform: uppercase; letter-spacing: 0.06em; margin-top: 4px;
        }
        @media (max-width: 600px) { .about-card { padding: 32px 24px; } }
        
          .map-page {
  max-width: 1500px;
  margin: 30px auto 60px;
  padding: 0 24px;
  font-family: 'Source Sans 3', sans-serif;
}
        .map-label {
          font-size:10rem; font-weight: 700;
          letter-spacing: 0.15em; text-transform: uppercase;
          color: #e63985; margin-bottom: 10px;
        }
        .map-heading {
  font-family: 'Playfair Display', serif;
  font-size: 3rem;        
  font-weight: 700;
  color: #1a1a2e;
  margin-bottom: 24px;
  line-height: 1.25;
}
        .map-heading span { color: #e63985; }
        .map-intro {
          font-size: 2.0rem; color: #555; line-height: 1.8;
          margin-bottom: 28px; max-width: 780px;
        }
        .map-card {
  background: #ffffff;
  border-radius: 24px;
  box-shadow: 0 20px 60px rgba(230,57,133,0.12), 0 4px 16px rgba(0,0,0,0.06);
  overflow: hidden;
  border-top: 6px solid #e63985;
  padding: 16px;
}
       .map-card {
  margin-top: 20px;
  padding: 0;
  width: 100%;
}

.map-card .leaflet-container {
  border-radius: 14px;
}
        
        .hero-section {
  width: 100;
  margin-bottom: 60px;  
  padding: 80px 20px 60px;
  text-align: center;
  background: #FADADD;
  border-radius: 24px;
  box-shadow: 0 12px 40px rgba(0,0,0,0.06);
}

.hero-title {
  font-family: 'Playfair Display', serif;
  font-size: 10rem;
  font-weight: 800;
  color: #e63985;
  margin-bottom: 18px;
}

.hero-subtitle {
  font-family: 'Playfair Display', serif;
  font-size: 5rem;
  color: #333;
  font-weight: 400;
}
.hero-link {
  display: inline-block;
  margin-top: 10px;
  font-size: 3.0rem;
  font-family: 'Playfair Display', serif;
  color: #e63985;
  text-decoration: none;
  font-weight: 600;
  border-bottom: 2px solid #e63985;
  padding-bottom: 4px;
  transition: all 0.2s ease;
}

.hero-link:hover {
  color: #c2185b;
  border-color: #c2185b;
}
.types-hero {
  text-align: center;
  background: ##FFFFFF;
  padding: 60px 20px 30px 20px;
}

.types-hero-heading {
  font-family: 'Playfair Display', serif;
  font-size: 5.0rem;
  font-weight: 700;
  color: #e63985;   
  margin-bottom: 10px;
}

.types-hero-label {
  font-size: 2.0rem;
  font-weight: 700;
  letter-spacing: 0.14em;
  text-transform: uppercase;
  color: #e63985;
  margin-bottom: 10px;
}

.types-hero-subtext {
  font-size: 2.0rem;
  color: #555;
  max-width: 650px;
  margin: 0 auto;
}
.nav-tabs > li > a {
  color: #000000 !important;
  font-weight: 700 !important;
}

.nav-tabs > li.active > a {
  color: #000000 !important;
  font-weight: 700 !important;
}
.nav-tabs > li > a {
  color: #DC5987;
  font-weight: 600;
}

.nav-tabs > li.active > a,
.nav-tabs > li.active > a:hover {
  color: #C71585;
  border-bottom: 3px solid #C71585;
  font-weight: 300;
}
.nav-tabs > li > a {
  font-size: 3.0rem !important;
}
      ")), 
           ),
           div(class = "about-section",
               div(class = "hero-section",
                   div(class = "hero-title", "PCOS"),
                   div(class = "hero-subtitle", "The risk you don’t see")
               ),
               div(style = "text-align: center; margin-top: 10px; margin-bottom: 20px;",
                   tags$a(
                     href = "#globalMaps",
                     "Checkout Global PCOS Data",
                     class = "hero-link"
                   )
               ),
               div(class = "about-card",
                   div(class = "about-label", "About This Project"),
                   div(class = "about-heading",
                       "Understanding ", tags$span("PCOS"), "Through Data"
                   ),
                   p(class = "about-text",
                     "Polycystic Ovary Syndrome (PCOS) is one of the most common hormonal disorders affecting women of reproductive age (typically 15–49), yet it remains widely underdiagnosed and misunderstood. Despite affecting millions of women worldwide, gaps in research, delayed diagnosis, and disparities in healthcare access continue to affect outcomes particularly for women from marginalized communities."
                   ),
                   p(class = "about-text",
                     "This project explores the prevalence, risk factors, and health outcomes associated with PCOS including metabolic complications, mental health impacts, and reproductive challenges. Using publicly available health datasets, we analyze trends by country, race, and age group to better understand disparities in diagnosis, treatment access, and long-term health outcomes."
                   ),
                   div(class = "stat-row",
                       div(class = "stat-pill",
                           tags$span(class = "stat-number", "1 in 10"),
                           tags$span(class = "stat-desc", "Women affected globally")
                       ),
                       div(class = "stat-pill",
                           tags$a(href = "https://www.who.int/news-room/fact-sheets/detail/polycystic-ovary-syndrome", target = "_blank",
                                  class = "stat-link",
                           tags$span(class = "stat-number", "70%")
                                  ),
                           tags$span(class = "stat-desc", "Cases go undiagnosed"), 
                           
                       ),
                       div(class = "stat-pill",
                           tags$span(class = "stat-number", "15–49"),
                           tags$span(class = "stat-desc", "Reproductive age range")
                       )
                   )
               ),
               div(style = "height: 60px;"),
               
               div(style = "text-align: center;",
                   
                   div(class = "about-label", "Word Cloud"),
                   
                   div(class = "about-heading",
                       "PCOS ", tags$span("Key Terms")
                   ),
                   
                   p(class = "about-text",
                     "A visual snapshot of the most common terms associated with PCOS — from symptoms and hormones to diagnosis and treatment."
                   ),
                   
                   div(style = "margin-top: 20px;",
                       plotOutput("wordcloud", width = "100%", height = "400px")
                   )
               ),
               
               div(style = "height: 60px;"),
               
               div(style = "height: 60px;"),
               div(class = "about-card",
                       div(class = "about-label", "Causes"),

                   
                       div(class = "about-heading",
                           "What causes ", tags$span("PCOS"), "?"
                       ),
                       
                       div(style = "display: flex; align-items: center; gap: 40px; flex-wrap: wrap;",
                           
            
                           div(style = "flex: 1; min-width: 100px;font-size: 3rem;font-family: 'Times New Roman', serif;",
                               p(class = "about-text", "The exact cause of PCOS is unknown. It is thought to happen due to a mix of:",
                                 tags$ol(
                                   tags$li("Genetic (inherited)"),
                                   tags$li("Hormonal"),
                                   tags$li("Lifestyle"),
                                   tags$li("Environmental factors")
                              
                               ),
                               tags$p(
                                 tags$strong("Source: "),
                                 tags$a(
                                   href = "https://www.healthdirect.gov.au/polycystic-ovarian-syndrome-pcos",
                                   "Healthdirect Australia",
                                   target = "_blank",
                                   style = "color:#e63985; text-decoration: none;"
                                 ),
                                 style = "margin-top: 8px; font-size: 1.5rem; color: #666;"
                               )
                           )),
                           
                           div(style = "flex: 1; min-width: 200px; min-height: 60%; text-align: center;",
                               tags$img(
                                 src = "polycystic-ovarian-syndrome-pcos-bae428.png",
                                 style = "max-width: 80%; height: 50%;"
                               )
                           )
                           
           ))),
  
           
    
  # ── 4. MAP 1990 ──
  
  div( id= "globalMaps", class = "about-section",
      
      div(class = "map-label", "Epidemiology"),
      div(class = "map-heading", "Global PCOS ", tags$span("Incidence (1990)"),
          style = "font-size: 3.0rem;"),
      p(class = "map-intro", 
        style = "font-size: 1.5rem;",
        "This map shows country-level PCOS incidence rates per 100,000 women of adolescence age in 1990. Hover over any country to see its specific values."
      ),
      div(class = "map-card",
          leafletOutput("pcosMap1990", height = "650px")   # <-- pcosMap1990
      ),
      p(class = "map-source",
        style = "font-size: 1.5rem;color: #e36895",
        tags$strong("Source: "),
        tags$a(href = "https://pmc.ncbi.nlm.nih.gov/articles/PMC6266413/", target = "_blank",
               class = "map-source-link",
               tags$strong("PCOS Dataset · PCOS in adolescents and young adults aged 10-24 years in 1990"))
      )
  ),
  # ── 3. MAP 2021 ──
  div(class = "about-section",
        
               div(class = "map-label", "Epidemiology"),
               div(class = "map-heading", "Global PCOS ", tags$span("Incidence (2021)"),
                   style = "font-size: 3.0rem;"),
               p(class = "map-intro",
                 style = "font-size: 1.5rem;",
                 "This map shows country-level PCOS incidence rates per 100,000 women of adolescence age in 2021. Hover over any country to see its specific values."
               ),
               div(class = "map-card",
                   leafletOutput("pcosMap", height = "650px")   # <-- pcosMap
               ),
               p(class = "map-source",
                 style = "font-size: 1.5rem;color: #e36895",
                 tags$strong("Source: "),
                 tags$a(href = "https://pmc.ncbi.nlm.nih.gov/articles/PMC6266413/", target = "_blank",
                        class = "map-source-link",
                        tags$strong("PCOS Dataset · PCOS in adolescents and young adults aged 10-24 years in 2021"))
         )),
  div(
    style = "text-align: center; margin-top: 20px; margin-bottom: 50px;",
    tags$a(
      href = "#",
      "Explore PCOS Trends Over Time",
      class = "hero-link",
      onclick = "document.querySelector('a[data-value=\"Trends\"]').click(); return false;"
    )
  )

  ),
  
  tabPanel("Trends",
           
           div(class = "types-hero",
               div(class = "types-hero-label", "Data Analysis"),
               h1(class = "types-hero-heading", "PCOS Trends"),
               p(class = "types-hero-subtext",
                 "Explore how PCOS incidence and prevalence have changed globally from 1990 to 2021."
               )
           ),
           
           div(class = "types-tabs-wrap",
               mainPanel(width = 12,
               tabsetPanel(
                 id = "trends_tabs",
                 
                 # ── TAB 1: Baseline Incidence vs AAPC ──────────────────────────
                 tabPanel("Baseline Incidence vs AAPC",
                          mainPanel(width = 12,
                                    div(class = "about-section",
                                        
                                        div(class = "map-label", "Trend Analysis"),
                                        div(class = "map-heading",
                                            style = "font-size: 3.0rem;",
                                            "Baseline Incidence ", tags$span("vs AAPC")
                                        ),
                                        p(class = "map-intro",
                                          style = "font-size: 1.5rem;",
                                          "This plot shows how baseline PCOS incidence in 1990 relates to long-term average annual percent change from 1990 to 2021. Countries with lower baseline incidence often show faster growth over time."
                                        ),
                                        div(class = "map-card",
                                            plotlyOutput("scatter_aapc", height = "500px")
                                        ),
                                        p(class = "map-source",
                                          "Source: PCOS Dataset · AAPC = Average Annual Percent Change"
                                        )
                                    )
                          ),
                 
                 
                 div(class = "map-card",
                     style = "padding: 32px 36px; margin-top: 20px;",
                     
                     # Card title
                     div(
                       style = "
        font-size: 1.5rem;
        font-weight: 700;
        letter-spacing: 0.15em;
        text-transform: uppercase;
        color: #e63985;
        margin-bottom: 8px;
      ",
                       "Analysis"
                     ),
                     div(
                       style = "
        font-family: 'Playfair Display', serif;
        font-size: 4.0rem;
        font-weight: 700;
        color: #1a1a2e;
        margin-bottom: 20px;
        padding-bottom: 12px;
        border-bottom: 2px solid #fce8f1;
      ",
                       "Baseline Incidence vs AAPC ",
                       tags$span("(Spearman p = -0.228, p = 0.001)",
                                 style = "color: #e63985; font-size: 2.0rem;")
                     ),
                     
                     # Section 1: Correlation interpretation
                     div(
                       style = "margin-bottom: 20px;",
                       div(
                         style = "
          font-size: 3.0rem;
          font-weight: 700;
          color: #1a1a2e;
          margin-bottom: 10px;
        ",
                         "Correlation Interpretation"
                       ),
                       tags$ul(
                         style = "padding-left: 20px; margin: 0;",
                         tags$li(
                           style = "font-size: 2.0rem; color: #444; line-height: 1.85; margin-bottom: 6px;",
                           "Spearman correlation measures rank-based (monotonic) relationships rather than exact values."
                         ),
                         tags$li(
                           style = "font-size: 2.0rem; color: #444; line-height: 1.85; margin-bottom: 6px;",
                           "The ", tags$strong("negative correlation (ρ = -0.228)"),
                           " indicates that as baseline incidence (1990) increases, AAPC tends to decrease slightly."
                         ),
                         tags$li(
                           style = "font-size: 2.0rem; color: #444; line-height: 1.85;",
                           "The magnitude is ", tags$strong("small to moderate"),
                           ", meaning the relationship is present but not strong."
                         )
                       )
                     ),
                     
                     tags$hr(style = "border: none; border-top: 1px solid #fce8f1; margin: 16px 0;"),
                     
                     # Section 2: Statistical significance
                     div(
                       style = "margin-bottom: 20px;",
                       div(
                         style = "
          font-size: 3.0rem;
          font-weight: 700;
          color: #1a1a2e;
          margin-bottom: 10px;
        ",
                         "Statistical Significance"
                       ),
                       tags$ul(
                         style = "padding-left: 20px; margin: 0;",
                         tags$li(
                           style = "font-size: 2.0rem; color: #444; line-height: 1.85; margin-bottom: 6px;",
                           tags$strong("p = 0.001"), " indicates a 0.1% probability that the relationship is due to chance."
                         ),
                         tags$li(
                           style = "font-size: 2.0rem; color: #444; line-height: 1.85;",
                           "Since ", tags$strong("p < 0.05"),
                           ", the result is statistically significant and reliable."
                         )
                       )
                     ),
                     
                     tags$hr(style = "border: none; border-top: 1px solid #fce8f1; margin: 16px 0;"),
                     
                     # Section 3: Trend and uncertainty
                     div(
                       div(
                         style = "
          font-size: 3.0rem;
          font-weight: 700;
          color: #1a1a2e;
          margin-bottom: 10px;
        ",
                         "Trend and Uncertainty"
                       ),
                       tags$ul(
                         style = "padding-left: 20px; margin: 0;",
                         tags$li(
                           style = "font-size: 2.0rem; color: #444; line-height: 1.85; margin-bottom: 6px;",
                           "The ", tags$strong(style = "color: #d7191c;", "red line"),
                           " represents the best-fit trend between incidence (1990) and AAPC."
                         ),
                         tags$li(
                           style = "font-size: 2.0rem; color: #444; line-height: 1.85; margin-bottom: 6px;",
                           "The ", tags$strong("shaded region"),
                           " is the 95% confidence interval, showing uncertainty around the trend."
                         ),
                         tags$li(
                           style = "font-size: 2.0rem; color: #444; line-height: 1.85;",
                           "The widening band at higher incidence values reflects ",
                           tags$strong("greater variability and fewer data points"), "."
                         )
                       )
                     )
                 )),
                 
                 # ── TAB 2: Regional Trend ───────────────────────────────────────
                 tabPanel("Regional Trend",
                          mainPanel(width = 12,
                                    div(class = "about-section",
                                        
                                        div(class = "map-label", "Regional Analysis"),
                                        div(class = "map-heading",
                                            style = "font-size: 3.0rem;",
                                            "PCOS Prevalence ", tags$span("by Region")
                                        ),
                                        p(class = "map-intro",
                                          style = "font-size: 1.5rem;",
                                          "This bar graph compares PCOS prevalence across regions in 1990 and 2021."
                                        ),
                                        div(class = "map-card",
                                            plotOutput("regionBarPlot", height = "500px")
                                        ),
                                        div(style = "height: 30px;"),
                                        div(class = "map-card",
                                            plotOutput("regionDiffPlot", height = "500px")
                                        ),
                                        div(style = "height: 30px;"),
                                        div(class = "map-card",
                                            verbatimTextOutput("regionTTest")
                                        ),
                                        p(class = "map-source", "Source: PCOS Dataset")
                                    )
                          )
                 ),
                 
                 # ── TAB 3: SDI Trend ────────────────────────────────────────────
                 tabPanel("SDI Trend",
                          mainPanel(width = 12,
                                    div(class = "about-section",
                                        
                                        div(class = "map-label", "SDI Trends"),
                                        div(class = "map-heading",
                                            style = "font-size: 3.0rem;",
                                            "PCOS Prevalence ", tags$span("by SDI Level")
                                        ),
                                        p(class = "map-intro",
                                          style = "font-size: 1.5rem;",
                                          "This section compares PCOS prevalence across SDI levels in 1990 and 2021, highlighting how disease burden varies by socioeconomic development."
                                        ),
                                        div(class = "map-card",
                                            plotOutput("sdiBarPlot", height = "500px")
                                        ),
                                        div(style = "height: 30px;"),
                                        div(class = "map-card",
                                            plotOutput("sdiDiffPlot", height = "500px")
                                        ),
                                        div(style = "height: 30px;"),
                                        div(class = "map-card",
                                            verbatimTextOutput("sdiTTest")
                                        ),
                                        p(class = "map-source",
                                          "Source: PCOS Dataset · SDI = Socio-Demographic Index"
                                        )
                                    )
                          )
                 )
                 
               ) # end tabsetPanel
           )   # end types-tabs-wrap
  )),    # end tabPanel Trends
  
  # ── 2. TYPES OF PCOS ──────────────────────────────────────────────────────
  tabPanel("Types of PCOS",
             div(class = "types-hero",
                 div(class = "types-hero-label", "PCOS Guide"),
                 h1(class = "types-hero-heading", "Types of PCOS"),
                 p(class = "types-hero-subtext",
                   "Learn about the four main types of PCOS and how each one differs."
                 )
             ),
             div(class = "types-tabs-wrap",
                 tabsetPanel(
                   id = "pcos_type_tabs",
                   
                   tabPanel(
                     "Overview",
                     mainPanel(
                       width = 12,
                       div(
                         class = "about-section",
                         style = "max-width: 63%; margin: 30px auto 60px; padding: 0 24px;",
                         
                         div(class = "about-card",
                             div(class = "about-label", "About This Section"),
                             div(class = "about-heading",
                                 "PCOS", tags$span("Overview"), 
                             ),
                             p(class = "about-text",
                               "Polycystic Ovary Syndrome (PCOS) is a hormonal disorder that affects how the ovaries function. It can cause irregular periods, high levels of androgens, and cysts on the ovaries. However, PCOS is not the same for everyone, and there are different types based on underlying causes."
                             ),
                             div(class = "stat-row",
                                 div(class = "stat-pill",
                                     tags$span(class = "stat-number", "1 in 10"),
                                     tags$span(class = "stat-desc", "Women affected globally")
                                 ),
                                 div(class = "stat-pill",
                                     tags$span(class = "stat-number", "70%"),
                                     tags$span(class = "stat-desc", "Cases go undiagnosed")
                                 ),
                                 div(class = "stat-pill",
                                     tags$span(class = "stat-number", "15–49"),
                                     tags$span(class = "stat-desc", "Reproductive age range")
                                 )
                             )
                         )
                       ),
                       
                       div(
                         style = "display: flex; gap: 16px; justify-content: center; align-items: center; margin-bottom: 40px;",
                         tags$img(
                           src = "symptoms.png",
                           width = "30%",
                           height = "600px",
                           style = "border: 1px solid #000000; border-radius: 8px;"
                         ),
                         tags$img(
                           src = "types_of_pcos.png",
                           width = "30%",
                           height = "600px",
                           style = "border: 1px solid #000000; border-radius: 8px;"
                         )
                       )
                     )
                   ),
                  tabPanel("Insulin Resistant PCOS",
                      mainPanel(width = "15",
                                div(class = "tx-page",
                                    
                                    div(style = "text-align: center;",
                                          src = "insulin_pcos.png",
                                          width = "400px",
                                          style = "border: 1px solid #e63985; border-radius: 1px;"
                                    ),
                                    
                                   
                                    div(class = "tx-page-heading", "Insulin Resistant ", tags$span("PCOS")),
                                    p(class = "tx-page-intro",
                                      "The most common type, accounting for ~70% of PCOS cases."
                                    ),
                                    
                                    div(class = "tx-card",
                                        div(class = "tx-card-header",
                                            div(
                                              p(class = "tx-card-subtitle",
                                                style = "text-align: center; width: 100%;",
                                                "Most Common Type"),
                                              
                                            )
                                        ),
                                        div(class = "tx-card-body",
                                            div(class = "tx-badge-row", span(class = "tx-badge badge-first-line", "~70% of Cases")),
                                            p(class = "tx-desc",
                                              "Insulin resistant PCOS occurs when the body's cells don't respond properly to insulin, leading
                   to elevated insulin levels. High insulin then signals the ovaries to overproduce androgens,
                   disrupting ovulation and causing the hallmark symptoms of PCOS. This type is closely tied to
                   diet, lifestyle, and metabolic health."
                                            ),
                                            p(tags$strong("Key symptoms:"), style = "font-size:0.92rem;color:#333;margin-bottom:8px;"),
                                            div(class = "tx-pills",
                                                span(class = "tx-pill pill-green", "Belly weight gain"),
                                                span(class = "tx-pill pill-green", "Irregular periods"),
                                                span(class = "tx-pill pill-green", "Acne & oily skin"),
                                                span(class = "tx-pill pill-green", "Hair thinning"),
                                                span(class = "tx-pill pill-green", "Brain fog"),
                                                span(class = "tx-pill pill-green", "Sugar cravings")
                                            ),
                                            p(tags$strong("Management approaches:"), style = "font-size:0.92rem;color:#333;margin-bottom:8px;margin-top:12px;"),
                                            div(class = "tx-pills",
                                                span(class = "tx-pill pill-green", "Low-carb diet"),
                                                span(class = "tx-pill pill-green", "Regular exercise"),
                                                span(class = "tx-pill pill-green", "Prioritise sleep"),
                                                span(class = "tx-pill pill-green", "Inositol"),
                                                span(class = "tx-pill pill-green", "Berberine"),
                                                span(class = "tx-pill pill-green", "Magnesium")
                                            ),
                                            div(class = "tx-note",
                                                tags$strong("Key marker: "), "Elevated fasting insulin is the hallmark diagnostic indicator.
                    Also check HbA1c, triglycerides, and ALT. A low-GI diet combined with consistent movement
                    can significantly reverse symptoms in this type."
                                            )
                                        )
                                    )
                                )
                      )
                  ), 
        
          
           tabPanel("Post-pill PCOS",
                  mainPanel(width = "12",
                            div(class = "tx-page",
                                
                                div(style = "text-align: center;",
                                      src = "postpill_pcos.png",
                                      width = "400px",
                                      style = "border: 1px solid #e63985; border-radius: 1px;"
                                    
                                ),
                                
                               
                                div(class = "tx-page-heading", "Post-Pill ", tags$span("PCOS")),
                                p(class = "tx-page-intro",
                                  "Develops after stopping hormonal contraceptives."
                                ),
                                
                                div(class = "tx-card",
                                    div(class = "tx-card-header",
                                        div(
                                          p(class = "tx-card-subtitle", 
                                            style = "text-align: center; width: 100%;",
                                            "Temporary Type"),
                                        )
                                    ),
                                    div(class = "tx-card-body",
                                        div(class = "tx-badge-row", span(class = "tx-badge badge-specialized", "Often Reversible")),
                                        p(class = "tx-desc",
                                          "Post-pill PCOS develops when the body's hormones take time to rebalance after stopping
                   hormonal contraceptives. The pill suppresses LH and androgens; once discontinued,
                   a temporary rebound surge can create PCOS-like symptoms. This is not permanent PCOS and
                   typically resolves within 3-6 months as the body recalibrates."
                                        ),
                                        p(tags$strong("Key symptoms:"), style = "font-size:0.92rem;color:#333;margin-bottom:8px;"),
                                        div(class = "tx-pills",
                                            span(class = "tx-pill pill-purple", "Cycle irregularity"),
                                            span(class = "tx-pill pill-purple", "Increased acne"),
                                            span(class = "tx-pill pill-purple", "Elevated testosterone"),
                                            span(class = "tx-pill pill-purple", "Mood changes"),
                                            span(class = "tx-pill pill-purple", "Temporary hair loss")
                                        ),
                                        p(tags$strong("Management approaches:"), style = "font-size:0.92rem;color:#333;margin-bottom:8px;margin-top:12px;"),
                                        div(class = "tx-pills",
                                            span(class = "tx-pill pill-purple", "Natural hormone reset"),
                                            span(class = "tx-pill pill-purple", "Seed cycling"),
                                            span(class = "tx-pill pill-purple", "Vitex (chasteberry)"),
                                            span(class = "tx-pill pill-purple", "Liver-supporting foods")
                                        ),
                                        div(class = "tx-note",
                                            tags$strong("Important: "), "This is not permanent PCOS. Many women are incorrectly diagnosed
                    after stopping the pill — reassessment after 6 months is recommended before confirming a
                    PCOS diagnosis. Also check: LH, FSH, and androgens."
                                        )
                                    )
                                )
                            )
                  )
           ),
             tabPanel("Adrenal PCOS",
                      mainPanel(width = "12",
                                div(class = "tx-page",
                                    
                                    div(style = "text-align: center;",
                                          src = "adrenal_pcos.png",
                                          width = "400px",
                                          style = "border: 1px solid #e63985; border-radius: 1px;"
                                    ),
                                    
                                  
                                    div(class = "tx-page-heading", "Adrenal ", tags$span("PCOS")),
                                    p(class = "tx-page-intro",
                                      "Driven by an overactive stress response rather than insulin."
                                    ),
                                    
                                    div(class = "tx-card",
                                        div(class = "tx-card-header",
                                                     div(
                                              p(class = "tx-card-subtitle", 
                                                style = "text-align: center; width: 100%;",
                                                "Stress-Driven Type"),
                                             
                                            )
                                        ),
                                        div(class = "tx-card-body",
                                            div(class = "tx-badge-row", span(class = "tx-badge badge-surgical", "Adrenal Androgen Excess")),
                                            p(class = "tx-desc",
                                              "Adrenal PCOS is rooted in a dysregulated stress response. When the body is under chronic stress,
                   the adrenal glands produce excess DHEA-S, an androgen that disrupts the hormonal balance needed
                   for regular ovulation. Unlike insulin-resistant PCOS, blood sugar and insulin levels are typically
                   normal in this type, making accurate diagnosis especially important."
                                            ),
                                            p(tags$strong("Key symptoms:"), style = "font-size:0.92rem;color:#333;margin-bottom:8px;"),
                                            div(class = "tx-pills",
                                                span(class = "tx-pill pill-pink", "Anxiety & fatigue"),
                                                span(class = "tx-pill pill-pink", "Irregular periods"),
                                                span(class = "tx-pill pill-pink", "Acne & facial hair"),
                                                span(class = "tx-pill pill-pink", "Poor stress tolerance"),
                                                span(class = "tx-pill pill-pink", "Sleep disturbances")
                                            ),
                                            p(tags$strong("Management approaches:"), style = "font-size:0.92rem;color:#333;margin-bottom:8px;margin-top:12px;"),
                                            div(class = "tx-pills",
                                                span(class = "tx-pill pill-pink", "Stress reduction"),
                                                span(class = "tx-pill pill-pink", "Ashwagandha"),
                                                span(class = "tx-pill pill-pink", "Adequate sleep"),
                                                span(class = "tx-pill pill-pink", "Magnesium"),
                                                span(class = "tx-pill pill-pink", "Vitamin C"),
                                                span(class = "tx-pill pill-pink", "Vitamin B5")
                                            ),
                                            div(class = "tx-note",
                                                tags$strong("Key marker: "), "Elevated DHEA-S with normal insulin levels points to adrenal PCOS.
                    Also check cortisol levels. Addressing the root cause chronic stress and HPA axis
                    dysregulation is central to recovery."
                                            )
                                        )
                                    )
                                )
                      )
             ),
             tabPanel("Inflammatory PCOS",
                      mainPanel(width = "12",
                                div(class = "tx-page",
                                    
                                    div(style = "text-align: center;",
                                          src = "inflammatory_pcos.png",
                                          width = "400px",
                                          style = "border: 1px solid #e63985; border-radius: 1px;"
                                    ),
                                    
                                  
                                    div(class = "tx-page-heading", "Inflammatory ", tags$span("PCOS")),
                                    p(class = "tx-page-intro",
                                      "Chronic low-grade inflammation disrupts ovulation and stimulates androgens."
                                    ),
                                    
                                    div(class = "tx-card",
                                        div(class = "tx-card-header",
                                            div(
                                              p(class = "tx-card-subtitle", 
                                                style = "text-align: center; width: 100%;",
                                                "Immune-Driven Type"),
                                             
                                            )
                                        ),
                                        div(class = "tx-card-body",
                                            div(class = "tx-badge-row", span(class = "tx-badge badge-first-line", "Chronic Inflammation")),
                                            p(class = "tx-desc",
                                              "Inflammatory PCOS is driven by the immune system rather than hormonal contraceptives or insulin.
                   Persistent low-grade inflammation, triggered by gut issues, food sensitivities, or environmental
                   toxins, stimulates androgen production and impairs ovulation. Testing for inflammatory markers
                   is key to identifying and managing this type effectively."
                                            ),
                                            p(tags$strong("Key symptoms:"), style = "font-size:0.92rem;color:#333;margin-bottom:8px;"),
                                            div(class = "tx-pills",
                                                span(class = "tx-pill pill-green", "Fatigue & joint pain"),
                                                span(class = "tx-pill pill-green", "Headaches"),
                                                span(class = "tx-pill pill-green", "Digestive problems"),
                                                span(class = "tx-pill pill-green", "Mood disorders"),
                                                span(class = "tx-pill pill-green", "Unexplained weight gain")
                                            ),
                                            p(tags$strong("Management approaches:"), style = "font-size:0.92rem;color:#333;margin-bottom:8px;margin-top:12px;"),
                                            div(class = "tx-pills",
                                                span(class = "tx-pill pill-green", "Anti-inflammatory diet"),
                                                span(class = "tx-pill pill-green", "Omega-3"),
                                                span(class = "tx-pill pill-green", "Gut health support"),
                                                span(class = "tx-pill pill-green", "Turmeric"),
                                                span(class = "tx-pill pill-green", "Zinc"),
                                                span(class = "tx-pill pill-green", "Vitamin D")
                                            ),
                                            div(class = "tx-note",
                                                tags$strong("Note: "), "Inflammatory markers like CRP, white blood cell count, and homocysteine
                    should be tested. Also check vitamin D and ferritin. Eliminating inflammatory triggers:
                    gluten, dairy, or processed foods, may significantly reduce symptoms."
                                            )
                                        )
                                    )
                                )
                      )
             )
  ),
  
  # ── 4. TREATMENT ──────────────────────────────────────────────────────────
  tabPanel("Treatment",
           useShinyjs(),
           tags$head(
             tags$style(HTML("
        @import url('https://fonts.googleapis.com/css2?family=Playfair+Display:wght@700;900&family=Source+Sans+3:wght@400;600&display=swap');

        .tx-page {
          max-width: 1100px; margin: 36px auto 72px;
          padding: 0 32px; font-family: 'Source Sans 3', sans-serif;
        }
        .tx-page-label {
          font-size: 1.0rem; font-weight: 700;
          letter-spacing: 0.15em; text-transform: uppercase;
          color: #e63985; margin-bottom: 10px;
        }
        .tx-page-heading {
          font-family: 'Playfair Display', serif;
          font-size: 3.0rem; font-weight: 700;
          color: #1a1a2e; margin-bottom: 15px; line-height: 1.25;
        }
        .tx-page-heading span { color: #e63985; }
        .tx-page-intro {
          font-size: 2.0rem; color: #555; line-height: 1.8;
          margin-bottom: 40px; max-width: 860px;
        }
        .tx-card {
          background: #ffffff; border-radius: 20px;
          box-shadow: 0 12px 40px rgba(230,57,133,0.10), 0 2px 10px rgba(0,0,0,0.05);
          margin-bottom: 28px; overflow: hidden;
          transition: transform 0.2s ease, box-shadow 0.2s ease;
        }
        .tx-card:hover {
          transform: translateY(-3px);
          box-shadow: 0 20px 56px rgba(230,57,133,0.15), 0 4px 14px rgba(0,0,0,0.07);
        }
        .tx-card-header {
          padding: 0;
          border-bottom: 1px solid #fce8f1;
        }
        .tx-toggle-btn {
          width: 100%;
          background: none;
          border: none;
          padding: 28px 32px 22px;
          display: flex;
          align-items: center;
          justify-content: space-between;
          gap: 18px;
          text-align: left;
        }
        .tx-toggle-left {
          display: flex;
          align-items: center;
          gap: 18px;
        }
        .tx-icon {
          width: 60px; height: 60px; border-radius: 14px;
          display: flex; align-items: center; justify-content: center;
          font-size: 3.0rem; flex-shrink: 0;
        }
        .tx-icon-green  { background: linear-gradient(135deg, #e8f8f0, #d0f0e0); }
        .tx-icon-pink   { background: linear-gradient(135deg, #fff0f7, #fcd8eb); }
        .tx-icon-purple { background: linear-gradient(135deg, #f3f0ff, #e2d9fb); }
        .tx-card-title {
          font-family: 'Playfair Display', serif;
          font-size: 3.0rem; font-weight: 700; color: #1a1a2e; margin: 0 0 4px;
        }
        .tx-card-subtitle {
          font-size: 1.88rem; font-weight: 600;
          letter-spacing: 0.08em; text-transform: uppercase;
          color: #e63985; margin: 0;
        }
        .tx-card-body { padding: 24px 32px 28px; }
        .tx-desc { font-size: 1.88rem; color: #444; line-height: 1.85; margin-bottom: 20px; }
        .tx-pills { display: flex; flex-wrap: wrap; gap: 8px; margin-bottom: 20px; }
        .tx-pill {
          font-size: 1.33rem; font-weight: 600;
          padding: 6px 16px; border-radius: 999px; border: 1.5px solid;
        }
        .tx-pill {
          font-size: 1.33rem;
          font-weight: 600;
          padding: 6px 16px;
          border-radius: 999px;
          border: 1.5px solid #f0a0c8;
          background: #fff0f7;
          color: #c0185f;
        }
        .tx-note {
  background: linear-gradient(135deg, #fff8fb, #fff4f0);
  border-left: 4px solid #e63985;
  border-radius: 10px;
  padding: 16px 20px;
  font-size: 1.88rem;
  color: #555;
  line-height: 1.75;
  margin-top: 10px;
}

.tx-note strong {
  color: #e63985;
}

        .tx-badge {
  font-size: 1.2rem;
  font-weight: 700;
  padding: 5px 14px;
  border-radius: 999px;
  text-transform: uppercase;
  letter-spacing: 0.08em;

  background: linear-gradient(135deg, #fff0f7, #ffe3ef);
  color: #e63985;
  border: 1.5px solid #f0a0c8;
}

        .tx-chevron {
          font-size: 1.4rem;
          color: #e63985;
          transition: transform 0.3s ease;
          display: inline-block;
          flex-shrink: 0;
        }
        .tx-chevron.open {
          transform: rotate(180deg);
        }

        @media (max-width: 600px) {
          .tx-toggle-btn { padding: 20px 20px 16px; align-items: flex-start; }
          .tx-toggle-left { flex-direction: column; align-items: flex-start; }
          .tx-card-body   { padding: 16px 20px 22px; }
        }
      "))
           ),
           
           mainPanel(
             width = 12,
             
             div(class = "tx-page",
                 div(class = "tx-page-label", "Managing PCOS"),
                 div(class = "tx-page-heading", "Treatment ", tags$span("Options")),
                 p(class = "tx-page-intro",
                   "PCOS management is highly individual. Treatment goals vary from regulating cycles and managing symptoms to supporting fertility. Below are key approaches used by clinicians worldwide."
                 ),
                 
                 div(class = "tx-card",
                     div(class = "tx-card-header",
                         actionButton(
                           "toggle_diet",
                           label = tagList(
                             div(class = "tx-toggle-left",
                                 div(class = "tx-icon tx-icon-pink", "🥗"),
                                 div(
                                   p(class = "tx-card-subtitle", "Lifestyle Intervention"),
                                   h3(class = "tx-card-title", "Dietary Therapy")
                                 )
                             ),
                             span(id = "chev_diet", class = "tx-chevron", "▼")
                           ),
                           class = "tx-toggle-btn"
                         )
                     ),
                     div(
                       id = "body_diet",
                       class = "tx-card-body",
                       style = "display: none;",
                       div(class = "tx-badge-row", span(class = "tx-badge badge-first-line", "First-line treatment")),
                       p(class = "tx-desc",
                         "Dietary therapy is typically the first recommended approach for managing PCOS, particularly for those with insulin resistance or elevated BMI. A low-glycemic, anti-inflammatory diet can reduce androgen levels, improve menstrual regularity, and support metabolic health often without medication. Obesity has been reported in 30% of PCOS patients. However, dieting and exercise alone does not always show long-term results; bariatric surgery has been introduced in cases where conservative approaches fall short."
                       ),
                       p(tags$strong("Key dietary approaches:"), style = "font-size:1.05rem;color:#333;margin-bottom:8px;"),
                       div(class = "tx-pills",
                           span(class = "tx-pill pill-green", "Low-GI diet"),
                           span(class = "tx-pill pill-green", "Anti-inflammatory foods"),
                           span(class = "tx-pill pill-green", "Reduced refined carbs"),
                           span(class = "tx-pill pill-green", "High fiber intake"),
                           span(class = "tx-pill pill-green", "Omega-3 rich foods"),
                           span(class = "tx-pill pill-green", "Caloric balance")
                       ),
                       div(class = "tx-note",
                           tags$strong("Important: "),
                           "A 5–10% reduction in body weight can restore ovulation and improve hormonal balance in women with PCOS. Diet changes are most effective when combined with regular physical activity."
                       )
                     )
                 ),
                 
                 div(class = "tx-card",
                     div(class = "tx-card-header",
                         actionButton(
                           "toggle_lod",
                           label = tagList(
                             div(class = "tx-toggle-left",
                                 div(class = "tx-icon tx-icon-pink", "🔬"),
                                 div(
                                   p(class = "tx-card-subtitle", "Surgical Procedure"),
                                   h3(class = "tx-card-title", "Laparoscopic Ovarian Drilling (LOD)")
                                 )
                             ),
                             span(id = "chev_lod", class = "tx-chevron", "▼")
                           ),
                           class = "tx-toggle-btn"
                         )
                     ),
                     div(
                       id = "body_lod",
                       class = "tx-card-body",
                       style = "display: none;",
                       div(class = "tx-badge-row", span(class = "tx-badge badge-surgical", "Surgical option")),
                       p(class = "tx-desc",
                         "LOD is a minimally invasive surgical procedure performed under general anesthesia. Small holes are made in the ovarian tissue using heat or a laser to destroy androgen-producing tissue. LOD was introduced in 1984 and is successful in approximately 84% of patients, improving insulin resistance and increasing SHBG levels. Lower miscarriage rates have also been reported with LOD."
                       ),
                       p(tags$strong("Typical candidates & outcomes:"), style = "font-size:1.05rem;color:#333;margin-bottom:8px;"),
                       div(class = "tx-pills",
                           span(class = "tx-pill pill-pink", "Clomiphene-resistant PCOS"),
                           span(class = "tx-pill pill-pink", "Anovulatory infertility"),
                           span(class = "tx-pill pill-pink", "Elevated LH levels"),
                           span(class = "tx-pill pill-pink", "No multiple pregnancy risk"),
                           span(class = "tx-pill pill-pink", "Laparoscopic access")
                       ),
                       div(class = "tx-note",
                           tags$strong("Note: "),
                           "LOD does not treat all PCOS symptoms, it primarily targets ovulation. Effects may be temporary. It is generally considered after first-line drug therapies have failed."
                       )
                     )
                 ),
                 
                 div(class = "tx-card",
                     div(class = "tx-card-header",
                         actionButton(
                           "toggle_art",
                           label = tagList(
                             div(class = "tx-toggle-left",
                                 div(class = "tx-icon tx-icon-pink", "🧬"),
                                 div(
                                   p(class = "tx-card-subtitle", "Fertility Treatment"),
                                   h3(class = "tx-card-title", "Assisted Reproductive Technology (ART)")
                                 )
                             ),
                             span(id = "chev_art", class = "tx-chevron", "▼")
                           ),
                           class = "tx-toggle-btn"
                         )
                     ),
                     div(
                       id = "body_art",
                       class = "tx-card-body",
                       style = "display: none;",
                       div(class = "tx-badge-row", span(class = "tx-badge badge-specialized", "Specialized care")),
                       p(class = "tx-desc",
                         "ART encompasses a range of fertility treatments that handle eggs, sperm, or embryos outside the body. For women with PCOS struggling to conceive, IVF is the most common ART option. PCOS patients often respond strongly to ovarian stimulation, requiring careful monitoring to prevent ovarian hyperstimulation syndrome (OHSS)."
                       ),
                       p(tags$strong("Common ART approaches for PCOS:"), style = "font-size:1.05rem;color:#333;margin-bottom:8px;"),
                       div(class = "tx-pills",
                           span(class = "tx-pill pill-purple", "IVF"),
                           span(class = "tx-pill pill-purple", "Ovulation induction"),
                           span(class = "tx-pill pill-purple", "Embryo freezing"),
                           span(class = "tx-pill pill-purple", "Egg freezing"),
                           span(class = "tx-pill pill-purple", "ICSI"),
                           span(class = "tx-pill pill-purple", "Frozen embryo transfer")
                       ),
                       div(class = "tx-note",
                           tags$strong("OHSS Risk: "),
                           "Women with PCOS are at higher risk for ovarian hyperstimulation during ART. Clinicians use low-dose stimulation protocols and close monitoring to minimize this risk."
                       )
                     )
                 ),
                 
                 div(class = "tx-card",
                     div(class = "tx-card-header",
                         actionButton(
                           "toggle_ocp",
                           label = tagList(
                             div(class = "tx-toggle-left",
                                 div(class = "tx-icon tx-icon-pink", "💊"),
                                 div(
                                   p(class = "tx-card-subtitle", "Hormonal Treatment"),
                                   h3(class = "tx-card-title", "Combined Oral Contraceptive Pills (OCPs)")
                                 )
                             ),
                             span(id = "chev_ocp", class = "tx-chevron", "▼")
                           ),
                           class = "tx-toggle-btn"
                         )
                     ),
                     div(
                       id = "body_ocp",
                       class = "tx-card-body",
                       style = "display: none;",
                       div(class = "tx-badge-row", span(class = "tx-badge badge-first-line", "First-choice treatment")),
                       p(class = "tx-desc",
                         "Combined oral contraceptive pills (OCPs) are considered the first-choice treatment for PCOS. They work by suppressing LH and FSH, reducing ovarian androgen production, and regulating the menstrual cycle. OCPs also increase sex hormone-binding globulin (SHBG), which further lowers free androgen levels, helping to manage symptoms like acne, hirsutism, and irregular periods."
                       ),
                       p(tags$strong("Key benefits:"), style = "font-size:1.05rem;color:#333;margin-bottom:8px;"),
                       div(class = "tx-pills",
                           span(class = "tx-pill pill-pink", "Regulates periods"),
                           span(class = "tx-pill pill-pink", "Reduces androgens"),
                           span(class = "tx-pill pill-pink", "Decrease acne"),
                           span(class = "tx-pill pill-pink", "Reduces hirsutism"),
                           span(class = "tx-pill pill-pink", "Increases SHBG"),
                           span(class = "tx-pill pill-pink", "Protects endometrium")
                       ),
                       div(class = "tx-note",
                           tags$strong("Note: "),
                           "OCPs do not treat the underlying metabolic causes of PCOS such as insulin resistance. They are most effective for symptom management and cycle regulation, and are often used alongside lifestyle interventions."
                       )
                     )
                 ),
                 
                 div(style = "text-align: center; margin-top: 16px;",
                     tags$img(
                       src = "treatment.png",
                       width = "400px",
                       style = "border: 1px solid #e63985; border-radius: 1px;"
                     )
                 )
             )
         )
  ),
  

tabPanel("Data Check Out",
         tags$head(
           tags$style(HTML("
      .dc-page {
        max-width: 1500px;
        margin: 36px auto 72px;
        padding: 0 24px,
        font-family: 'Source Sans 3', sans-serif;
      }
      .dc-page-label {
        font-size: 2.0rem; font-weight: 700;
        letter-spacing: 0.15em; text-transform: uppercase;
        color: #e63985; margin-bottom: 10px;
      }
      .dc-page-heading {
        font-family: 'Playfair Display', serif;
        font-size: 5.0rem; font-weight: 700;
        color: #1a1a2e; margin-bottom: 12px; line-height: 1.25;
      }
      .dc-page-heading span { color: #e63985; }
      .dc-page-intro {
        font-size: 2.0rem; color: #555; line-height: 1.8;
        margin-bottom: 40px; max-width: 2000px;
      }
      .dc-layout {
        display: flex; gap: 28px; align-items: flex-start; flex-wrap: wrap;
      }
      .dc-sidebar { flex: 0 0 300px; min-width: 260px; }
      .dc-main    { flex: 1; min-width: 280px; }

      /* form card */
      .dc-form-card {
        background: #ffffff; border-radius: 20px;
        box-shadow: 0 12px 40px rgba(230,57,133,0.10), 0 2px 10px rgba(0,0,0,0.05);
        border-top: 5px solid #e63985;
        padding: 28px 28px 32px;
      }
      .dc-section-title {
        font-family: 'Playfair Display', serif;
        font-size: 2.0rem; font-weight: 700; color: #1a1a2e;
        margin: 0 0 16px; padding-bottom: 10px;
        border-bottom: 1px solid #fce8f1;
      }
      .dc-form-card label {
        font-size: 1.5rem; font-weight: 600; color: #444;
        margin-bottom: 4px; display: block;
      }
      .dc-form-card input[type='number'],
      .dc-form-card select {
        border: 1.5px solid #f0c0d8 !important;
        border-radius: 10px !important;
        font-size: 1.5rem !important;
        padding: 8px 12px !important;
        color: #333;
        width: 100%;
        margin-bottom: 14px;
        transition: border-color 0.2s;
      }
      .dc-form-card input[type='number']:focus,
      .dc-form-card select:focus {
        border-color: #e63985 !important; outline: none;
        box-shadow: 0 0 0 3px rgba(230,57,133,0.12) !important;
      }
      .dc-divider {
        border: none; border-top: 1px solid #fce8f1; margin: 18px 0;
      }
      .dc-submit-btn {
        width: 100%; padding: 12px;
        background: linear-gradient(135deg, #e63985, #f0699e) !important;
        color: #fff !important; font-weight: 700; font-size: 1.5rem;
        border: none !important; border-radius: 12px !important; cursor: pointer;
        letter-spacing: 0.04em; text-transform: uppercase;
        transition: opacity 0.2s, transform 0.15s;
        margin-top: 6px;
      }
      .dc-submit-btn:hover { opacity: 0.88; transform: translateY(-1px); }

      /* result cards */
      .dc-result-card {
        background: #ffffff; border-radius: 20px;
        box-shadow: 0 12px 40px rgba(230,57,133,0.10), 0 2px 10px rgba(0,0,0,0.05);
        margin-bottom: 24px; overflow: hidden;
        border-top: 5px solid #e63985;
        padding: 26px 30px;
      }
      .dc-result-label {
        font-size: 2.5rem; font-weight: 700;
        letter-spacing: 0.15em; text-transform: uppercase;
        color: #e63985; margin-bottom: 6px;
      }
      .dc-result-title {
        font-family: 'Playfair Display', serif;
        font-size: 2.5rem; font-weight: 700; color: #1a1a2e;
        margin-bottom: 14px;
      }

      /* BMI display */
      .dc-bmi-row { display: flex; align-items: baseline; gap: 14px; }
      .dc-bmi-value {
        font-family: 'Playfair Display', serif;
        font-size: 3.2rem; font-weight: 900; color: #e63985; line-height: 1;
      }
      .dc-bmi-category {
        font-size: 1.5rem; font-weight: 700; text-transform: uppercase;
        letter-spacing: 0.1em; color: #888;
      }
      .dc-placeholder {
        text-align: center; padding: 32px 24px;
        color: #ccc; font-size: 0.95rem;
      }

      /* health summary table */
      .dc-table { width: 100%; border-collapse: collapse; font-size: 2.0rem; color: #444; }
      .dc-table th {
        text-align: left; padding: 10px 12px;
        background: linear-gradient(135deg, #fff0f7, #fff8f0);
        font-size: 2.0rem; font-weight: 700;
        letter-spacing: 0.07em; text-transform: uppercase; color: #e63985;
        border-bottom: 2px solid #fce8f1;
      }
      .dc-table td { padding: 10px 12px; border-bottom: 1px solid #fce8f1; }
      .dc-table tr:last-child td { border-bottom: none; }

      /* conclusions */
      .dc-note {
        background: linear-gradient(135deg, #fff8fb, #fff4f0);
        border-left: 4px solid #e63985; border-radius: 10px;
        padding: 14px 18px; font-size: 2.5rem;
        color: #555; line-height: 1.75;
      }
      .dc-note strong { color: #e63985; }
      .dc-warning {
        background: linear-gradient(135deg, #fffbf0, #fff8e8);
        border-left: 4px solid #f5a623; border-radius: 10px;
        padding: 14px 18px; font-size: 2.5rem;
        color: #555; line-height: 1.75; margin-top: 16px;
      }
      .dc-warning strong { color: #c47d0e; }
      .dc-conclusions-list {
        line-height: 2; padding-left: 18px; margin-bottom: 0;
      }
      .dc-conclusions-list li {font-size: 2.0rem; margin-bottom: 6px; }
      .dc-conclusions-list li b { font-size: 2.0rem;color: #1a1a2e; }
      .dc-conclusions-list li a { font-size: 2.0rem;color: #e63985; }
    "))
         ),
         div(class = "dc-page",
             div(class = "dc-page-label", "Personal Assessment"),
             div(class = "dc-page-heading", "Data ", tags$span("Check Out")),
             p(class = "dc-page-intro",
               "Enter your health information below to get a personalised snapshot based on what the data and research tell us about PCOS risk factors."
             ),
             
             div(class = "dc-layout",
                 
                 # ── Sidebar / Form ──────────────────────────────────────────
                 div(class = "dc-sidebar",
                     div(class = "dc-form-card",
                         div(class = "dc-section-title", "Step 1: Calculate BMI"),
                         numericInput("weight", "Weight (kg):",  value = NULL, min = 1),
                         numericInput("height", "Height (cm):",  value = NULL, min = 1),
                         tags$hr(class = "dc-divider"),
                         div(class = "dc-section-title", "Step 2: Health Information"),
                         numericInput("age", "Age (years):", value = NULL, min = 1, max = 120),
                         selectInput("menstrual", "Menstrual Regularity:",
                                     choices = c("Select..." = "", "Regular", "Irregular")),
                         selectInput("acne", "Acne Severity:",
                                     choices = c("Select..." = "", "None", "Mild", "Moderate", "Severe")),
                         selectInput("stress", "Stress Level:",
                                     choices = c("Select..." = "", "Low", "Medium", "High")),
                         selectInput("fertility", "Fertility Concern:",
                                     choices = c("Select..." = "", "Yes", "No")),
                         selectInput("insulin", "Insulin Resistance:",
                                     choices = c("Select..." = "", "Yes", "No")),
                         actionButton("calculate", "Submit", class = "dc-submit-btn btn")
                     )
                 ),
                 
                 # ── Main / Results ──────────────────────────────────────────
                 div(class = "dc-main",
                     
                     div(class = "dc-result-card",
                         div(class = "dc-result-label", "BMI Result"),
                         div(class = "dc-result-title", "Body Mass Index"),
                         uiOutput("bmi_display")
                     ),
                     
                     div(class = "dc-result-card",
                         div(class = "dc-result-label", "Health Summary"),
                         div(class = "dc-result-title", "Your Inputs at a Glance"),
                         uiOutput("health_summary_styled")
                     ),
                     
                     div(class = "dc-result-card",
                         div(class = "dc-result-label", "Insights"),
                         div(class = "dc-result-title", "What the Data Says About Your Case"),
                         uiOutput("data_conclusions")
                     )
                 )
             )
         )
),
navbarMenu("Risks and Comorbidities",
         tabPanel("Endometrial Cancer",
                  tags$head(
                    tags$style(HTML("
      @import url('https://fonts.googleapis.com/css2?family=Playfair+Display:wght@700;900&family=Source+Sans+3:wght@400;600&display=swap');
      
      body {
        font-family: 'Source Sans 3', sans-serif;
        background: #fff;
      }

      .map-page {
        max-width: 1100px;
        margin: 30px auto 60px;
        padding: 0 24px;
      }

      .map-label {
        font-size: 0.75rem;
        font-weight: 700;
        letter-spacing: 0.15em;
        text-transform: uppercase;
        color: #e63985;
        margin-bottom: 10px;
      }

      .map-heading {
        font-family: 'Playfair Display', serif;
        font-size: 2rem;
        font-weight: 700;
        color: #1a1a2e;
        margin-bottom: 10px;
        line-height: 1.25;
      }

      .map-heading span {
        color: #e63985;
      }

      .map-intro {
        font-size: 1rem;
        color: #555;
        line-height: 1.8;
        margin-bottom: 28px;
        max-width: 780px;
      }

      .map-card {
        background: #ffffff;
        border-radius: 20px;
        box-shadow: 0 12px 40px rgba(230,57,133,0.10),
                    0 2px 10px rgba(0,0,0,0.05);
        overflow: hidden;
        border-top: 5px solid #e63985;
        padding: 8px;
      }

      .map-source {
        font-size: 0.78rem;
        color: #aaa;
        margin-top: 12px;
        text-align: right;
      }

      .leaflet-container {
        background: white !important;
      }
    "))
                  ),
                  
                  div(class = "map-page",
                      
                      div(class = "map-label", "Epidemiology"),
                      
                      div(class = "map-heading",
                          "US Uterine Corpus Cancer ", 
                          tags$span("Incidence by State")
                      ),
                      
                      p(class = "map-intro",
                        "This map shows state-level uterine corpus cancer incidence rates per 100,000 women. Hover over any state to view its incidence rate."
                      ),
                      
                      div(class = "map-card",
                          leafletOutput("stateMap", height = "320px")
                      ),
                      
                      p(class = "map-source",
                        "Source: Uterine Corpus Dataset · Incidence per 100,000 women"
                      )
                  ), 
                  
                  div(class = "map-page",
                      
                      div(class = "map-label", "Epidemiology"),
                      
                      div(class = "map-heading",
                          "US Uterine Corpus Cancer ", 
                          tags$span("Mortality Rate by State")
                      ),
                      
                      p(class = "map-intro",
                        "This map shows state-level uterine corpus cancer mprtality rates per 100,000 women. Hover over any state to view its incidence rate."
                      ),
                      
                      div(class = "map-card",
                          leafletOutput("stateMapMortality", height = "320px")
                      ),
                      
                      p(class = "map-source",
                        "Source: Uterine Corpus Dataset· Mortality Rate per 100,000 women"
                      )
                  ),
                  div(class = "map-page",
                      
                      div(class = "map-label", "Epidemiology"),
                      
                      div(class = "map-heading",
                          "US Uterine Corpus Cancer ", 
                          tags$span("Death Estimates by State")
                      ),
                      
                      p(class = "map-intro",
                        "This map shows state-level uterine corpus cancer mprtality rates per 100,000 women. Hover over any state to view its incidence rate."
                      ),
                      
                      div(class = "map-card",
                          leafletOutput("stateMapDeath", height = "320px")
                      ),
                      
                      p(class = "map-source",
                        "Source: Uterine Corpus Dataset· Mortality Rate per 100,000 women"
                      )
                  ),
                  
                  div(class = "map-page",
                      
                      div(class = "map-label", "Epidemiology"),
                      
                      div(class = "map-heading",
                          "US Uterine Corpus Cancer ", 
                          tags$span("New Cases by State")
                      ),
                      
                      p(class = "map-intro",
                        "This map shows state-level uterine corpus cancer new cases per 100,000 women. Hover over any state to view its incidence rate."
                      ),
                      
                      div(class = "map-card",
                          leafletOutput("stateMapNew", height = "320px")
                      ),
                      
                      p(class = "map-source",
                        "Source: Uterine Corpus Dataset· New cases per 100,000 women"
                      )
                  )
         )
),
tabPanel("About Us",
         
         tags$head(
           tags$style(HTML("

      .team-section {
        max-width: 1200px;
        margin: 50px auto 80px;
        padding: 0 24px;
      }

      .team-hero {
        width: 100%;
        margin-bottom: 60px;
        padding: 80px 20px 60px;
        text-align: center;
        background: #FADADD;
        border-radius: 24px;
        box-shadow: 0 12px 40px rgba(0,0,0,0.06);
      }

      .member-card {
        background: #ffffff;
        border-radius: 24px;
        padding: 48px 52px;
        box-shadow: 0 20px 60px rgba(230,57,133,0.12), 0 4px 16px rgba(0,0,0,0.06);
        border-top: 6px solid #e63985;
        margin-bottom: 48px;
        display: flex;
        gap: 52px;
        align-items: flex-start;
        flex-wrap: wrap;
      }

      .member-photo {
        width: 280px;
        height: 340px;
        object-fit: cover;
        border-radius: 16px;
        flex-shrink: 0;
      }

      .member-info {
        flex: 1;
        min-width: 260px;
      }

      .member-name {
        font-family: 'Playfair Display', serif;
        font-size: 3rem;
        font-weight: 700;
        color: #1a1a2e;
        margin-bottom: 6px;
      }

      .member-detail {
        font-size: 2rem;
        color: #444;
        line-height: 1.8;
        margin-bottom: 4px;
      }

      .member-detail span {
        font-style: italic;
        color: #888;
        margin-right: 6px;
      }

      .member-divider {
        border: none;
        border-top: 2px solid #f7c5de;
        margin: 20px 0;
      }

      .member-question {
        font-family: 'Playfair Display', serif;
        font-size: 1.7rem;
        font-weight: 700;
        color: #e63985;
        margin-bottom: 10px;
      }

      .member-answer {
        font-size: 1.5rem;
        color: #555;
        line-height: 1.85;
      }

      @media (max-width: 700px) {
        .member-card { flex-direction: column; padding: 32px 24px; }
        .member-photo { width: 100%; height: 300px; }
      }

    "))
         ),
         
         div(class = "team-section",
             
             # ── Hero banner ──────────────────────────────────────────
             div(class = "team-hero",
                 div(class = "hero-title", "Our Team"),
                 div(class = "hero-subtitle", "The minds behind Health is Wealth")
             ),
             
             div(class = "about-label", "Meet The Team"),
             div(class = "about-heading",
                 "The people ", tags$span("behind the project")
             ),
             
             # ── MEMBER 1 ─────────────────────────────────────────────
             div(class = "member-card",
                 tags$img(
                   src   = "zanita.png",        # ← rename your file to member1.jpg and drop in www/
                   class = "member-photo",
                   alt   = "Member 1"
                 ),
                 div(class = "member-info",
                     div(class = "member-name",   "Zanita Akinkugbe '27"),        # ← full name + grad year
                     div(class = "member-detail", tags$span("Hometown:"),  "Lagos, Nigeria"),         # ← hometown
                     div(class = "member-detail", tags$span("Majors/Minors:"), "Neuroscience Major/ Education Policy, and Poverty & Human Capability Studies Minors"),  # ← major/minor
                     tags$hr(class = "member-divider"),
                     div(class = "member-question", "What do you like most about this project?"),
                     div(class = "member-answer", "As someone who has been diagnosed with PCOS herself, this project was particularly meaningful to me. PCOS is hard to diagnose, it's even harder when there's essentially no information about it. 
                         I am glad our project can shed light on the disease and hopefully help people understand better")           # ← their answer
                 )
             ),
             
             # ── MEMBER 2 ─────────────────────────────────────────────
             div(class = "member-card",
                 tags$img(
                   src   = "martha.png",        # ← rename your file to member2.jpg and drop in www/
                   class = "member-photo",
                   alt   = "Member 2"
                 ),
                 div(class = "member-info",
                     div(class = "member-name",   "Martha Afoakwa '27"),        # ← full name + grad year
                     div(class = "member-detail", tags$span("Hometown:"),  "Reston, Virginia"),         # ← hometown
                     div(class = "member-detail", tags$span("Majors/Minors:"), "Biology Major/ Philosophy and Poverty & Human Capability Minors"),  # ← major/minor
                     tags$hr(class = "member-divider"),
                     div(class = "member-question", "What do you like most about this project?"),
                     div(class = "member-answer", "I am excited about our project in Polycystic Ovary Syndrome (PCOS) because I believe there is a significant lack of awareness and understanding surrounding this condition. Many people do not fully recognize its symptoms, long-term health effects, or how common it is. More broadly, women’s health has historically been underrepresented and overlooked in both research and public conversation. This gap in knowledge leads to delayed diagnoses and limited support for those affected. Our project hopes to help increase awareness, encourage better education, and contribute to more informed and supportive discussions around women’s health")           # ← their answer
                 )
             ),
             
             # ── MEMBER 3 ─────────────────────────────────────────────
             div(class = "member-card",
                 tags$img(
                   src   = "fatma.png",        # ← rename your file to member3.jpg and drop in www/
                   class = "member-photo",
                   alt   = "Member 3"
                 ),
                 div(class = "member-info",
                     div(class = "member-name",   "Fatma Nayer '27"),        # ← full name + grad year
                     div(class = "member-detail", tags$span("Hometown:"),  "Patna, India"),         # ← hometown
                     div(class = "member-detail", tags$span("Majors/Minors:"), "Biology Major/ Creative Writing Minor "),  # ← major/minor
                     tags$hr(class = "member-divider"),
                     div(class = "member-question", "What do you like most about this project?"),
                     div(class = "member-answer", "Women’s health has always been at the center of my research interests. 
                         Hormonal disorders are both widespread and significantly underdiagnosed, often leaving many individuals without the care and treatment they need. 
                         My efforts to spread awareness about Polycystic Ovary Syndrome (PCOS) have not only deepened my understanding of the condition but also highlighted the gaps in knowledge, diagnosis, and treatment that persist in this field.")           # ← their answer
                 )
             )
             
         )
),
# ── REFERENCES ──────────────────────────────────────────────────────────────
tabPanel("References",
         mainPanel(width = 12,
                   div(class = "tx-page",
                       div(class = "tx-page-label", "Sources & Citations"),
                       div(class = "tx-page-heading", "References"),
                       p(class = "tx-page-intro",
                         "The following sources were used in the development of this application, including clinical literature, public health resources, and data repositories."
                       ),
                       
                       # Card 1: Peer-Reviewed
                       div(class = "tx-card",
                           div(class = "tx-card-header",
                               div(class = "tx-toggle-left",
                                   div(class = "tx-icon tx-icon-purple", "📚"),
                                   div(
                                     p(class = "tx-card-subtitle", "Academic & Clinical Sources"),
                                     h3(class = "tx-card-title", "Peer-Reviewed Literature")
                                   )
                               )
                           ),
                           div(class = "tx-card-body",
                               tags$ol(
                                 tags$li(style = "margin-bottom:14px; font-size:1.5rem; color:#444; line-height:1.75;",
                                         "Genetic Basis of Polycystic Ovary Syndrome (PCOS): Current Perspectives.",
                                         tags$em(" PubMed Central, U.S. National Library of Medicine. "),
                                         tags$a(href="https://pmc.ncbi.nlm.nih.gov/articles/PMC7959048/", target="_blank",
                                                "View article", style="color:#e63985;")
                                 ),
                                 tags$li(style = "margin-bottom:14px; font-size:1.5rem; color:#444; line-height:1.75;",
                                         "Article. PubMed Central, U.S. National Library of Medicine. ",
                                         tags$a(href="https://pmc.ncbi.nlm.nih.gov/articles/PMC12221545/", target="_blank",
                                                "View article", style="color:#e63985;")
                                 ),
                                 tags$li(style = "margin-bottom:14px; font-size:1.5rem; color:#444; line-height:1.75;",
                                         "Genetics and Genomics of Endometriosis.",
                                         tags$em(" PubMed Central, U.S. National Library of Medicine.")
                                 ),
                                 tags$li(style = "margin-bottom:14px; font-size:1.5rem; color:#444; line-height:1.75;",
                                         "Mitochondrial Dysfunction in PCOS: Insights into Reproductive Organ Pathophysiology.",
                                         tags$em(" PubMed Central, U.S. National Library of Medicine.")
                                 ),
                                 tags$li(style = "margin-bottom:14px; font-size:1.5rem; color:#444; line-height:1.75;",
                                         "Polycystic Ovary Syndrome, Metabolic Syndrome, and Inflammation in the Hispanic Community Health Study/Study of Latinos.",
                                         tags$em(" PubMed Central, U.S. National Library of Medicine.")
                                 ),
                                 tags$li(style = "margin-bottom:14px; font-size:1.5rem; color:#444; line-height:1.75;",
                                         "Risk for Premenstrual Dysphoric Disorder is Associated with Genetic Variation in ESR1, the Estrogen Receptor Alpha Gene.",
                                         tags$em(" PubMed Central, U.S. National Library of Medicine.")
                                 )
                               )
                           )
                       ),
                       
                       # Card 2: Medical & Public Health
                       div(class = "tx-card",
                           div(class = "tx-card-header",
                               div(class = "tx-toggle-left",
                                   div(class = "tx-icon tx-icon-pink", "🏥"),
                                   div(
                                     p(class = "tx-card-subtitle", "Health Organisations & Clinics"),
                                     h3(class = "tx-card-title", "Medical & Public Health Sources")
                                   )
                               )
                           ),
                           div(class = "tx-card-body",
                               tags$ol(start = "7",
                                       tags$li(style = "margin-bottom:14px; font-size:1.5rem; color:#444; line-height:1.75;",
                                               "Fact Sheets. Office on Women's Health, U.S. Department of Health & Human Services. ",
                                               tags$a(href="https://womenshealth.gov/patient-materials/resource/fact-sheets", target="_blank",
                                                      "View source", style="color:#e63985;")
                                       ),
                                       tags$li(style = "margin-bottom:14px; font-size:1.5rem; color:#444; line-height:1.75;",
                                               "What Is PCOS? WebMD. ",
                                               tags$a(href="https://www.webmd.com/women/what-is-pcos", target="_blank",
                                                      "View source", style="color:#e63985;")
                                       ),
                                       tags$li(style = "margin-bottom:14px; font-size:1.5rem; color:#444; line-height:1.75;",
                                               "What Is PCOS and Can It Be Cured? OSF HealthCare. ",
                                               tags$a(href="https://www.osfhealthcare.org/blog/what-is-pcos-and-can-it-be-cured", target="_blank",
                                                      "View source", style="color:#e63985;")
                                       ),
                                       tags$li(style = "margin-bottom:14px; font-size:1.5rem; color:#444; line-height:1.75;",
                                               "Premenstrual Dysphoric Disorder (PMDD). Mayo Clinic. ",
                                               tags$a(href="https://www.mayoclinic.org/diseases-conditions/premenstrual-syndrome/expert-answers/pmdd/faq-20058315", target="_blank",
                                                      "View source", style="color:#e63985;")
                                       ),
                                       tags$li(style = "margin-bottom:14px; font-size:1.5rem; color:#444; line-height:1.75;",
                                               "PCOS: What Is It and Can It Affect Fertility? MyOvary. ",
                                               tags$a(href="https://www.myovry.ca/blogs/health-science/pcos-what-is-it-and-can-it-affect-fertility", target="_blank",
                                                      "View source", style="color:#e63985;")
                                       )
                               )
                           )
                       ),
                       
                       # Card 3: Additional Resources
                       div(class = "tx-card",
                           div(class = "tx-card-header",
                               div(class = "tx-toggle-left",
                                   div(class = "tx-icon tx-icon-green", "🔗"),
                                   div(
                                     p(class = "tx-card-subtitle", "Nutrition, PCOS Types & Data"),
                                     h3(class = "tx-card-title", "Additional Resources")
                                   )
                               )
                           ),
                           div(class = "tx-card-body",
                               tags$ol(start = "12",
                                       tags$li(style = "margin-bottom:14px; font-size:1.5rem; color:#444; line-height:1.75;",
                                               "30 Interesting Facts About PCOS. Nutrition Care of Rochester. ",
                                               tags$a(href="https://www.nutritioncareofrochester.com/articles/30-interesting-facts-about-pcos", target="_blank",
                                                      "View source", style="color:#e63985;")
                                       ),
                                       tags$li(style = "margin-bottom:14px; font-size:1.5rem; color:#444; line-height:1.75;",
                                               "4 Types of PCOS and How to Know Which One You Have. Emily Jensen Nutrition. ",
                                               tags$a(href="https://www.emilyjensennutrition.com/blog/4-types-of-pcos-and-how-to-know-which-one-you-have", target="_blank",
                                                      "View source", style="color:#e63985;")
                                       ),
                                       tags$li(style = "margin-bottom:14px; font-size:1.5rem; color:#444; line-height:1.75;",
                                               "The Four Types of PCOS and Their Symptoms. Rosa Gynecology. ",
                                               tags$a(href="https://rosagynecology.com/the-four-types-of-pcos-and-their-symptoms/", target="_blank",
                                                      "View source", style="color:#e63985;")
                                       ),
                                       tags$li(style = "margin-bottom:14px; font-size:1.5rem; color:#444; line-height:1.75;",
                                               "PCOS Prediction Dataset (Top 75 Countries). Kaggle. ",
                                               tags$a(href="https://www.kaggle.com/datasets/ankushpanday1/pcos-prediction-datasettop-75-countries", target="_blank",
                                                      "View source", style="color:#e63985;")
                                       )
                               ),
                               div(class = "tx-note",
                                   tags$strong("Note: "),
                                   "All references were accessed during the development of this application. URLs were correct at time of access. Some links may require institutional access."
                               )
                           )
                       )
                   )
         )
)
) 

