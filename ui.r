library(shiny)
library(bslib)
library(leaflet)
library(shinyjs)
library(wordcloud2)
library(tm)
library(RColorBrewer)
library(plotly)

# ══════════════════════════════════════════════════════════════════════════════
#  RISKS & COMORBIDITIES — helpers defined BEFORE navbarPage()
# ══════════════════════════════════════════════════════════════════════════════

risks_css <- "
@import url('https://fonts.googleapis.com/css2?family=Playfair+Display:wght@700;900&family=DM+Sans:wght@300;400;500;600&display=swap');
.risks-hero { background: #F8D7E8; border-radius: 18px; margin: 2rem 2rem 0; padding: 3.5rem 3rem; text-align: center; }
.risks-hero .overline { font-size: 0.72rem; letter-spacing: 0.18em; text-transform: uppercase; color: #D81B7A; font-weight: 600; margin-bottom: 0.6rem; }
.risks-hero h1 { font-family: 'Playfair Display', Georgia, serif; font-size: clamp(2.2rem, 5vw, 3.5rem); color: #D81B7A; margin: 0 0 0.8rem; line-height: 1.15; }
.risks-hero p { font-size: 1.05rem; color: #1A1A2E; max-width: 600px; margin: 0 auto; line-height: 1.7; font-weight: 300; }
.risks-section-wrap { max-width: 1080px; margin: 0 auto; padding: 0 1.5rem 4rem; }
.risks-intro-card { border: 1.5px solid #EDBED6; border-top: 4px solid #D81B7A; border-radius: 16px; padding: 2.5rem 2.8rem; margin-top: 2.5rem; background: #fff; }
.risks-intro-card .overline { font-size: 0.7rem; letter-spacing: 0.18em; text-transform: uppercase; color: #D81B7A; font-weight: 600; }
.risks-intro-card h2 { font-family: 'Playfair Display', Georgia, serif; font-size: 1.75rem; color: #1A1A2E; margin: 0.35rem 0 1rem; }
.risks-intro-card h2 span { color: #D81B7A; }
.risks-intro-card p { font-size: 1.92rem; line-height: 1.75; color: #444; }
.risks-stat-row { display: flex; gap: 1.2rem; flex-wrap: wrap; margin-top: 1.8rem; }
.risks-stat-badge { flex: 1 1 160px; background: #F8D7E8; border-radius: 12px; padding: 1.3rem 1rem; text-align: center; }
.risks-stat-badge .stat-num { font-family: 'Playfair Display', Georgia, serif; font-size: 1.7rem; color: #D81B7A; font-weight: 900; line-height: 1; display: block; }
.risks-stat-badge .stat-label { font-size: 0.68rem; letter-spacing: 0.1em; text-transform: uppercase; color: #1A1A2E; margin-top: 0.4rem; font-weight: 600; display: block; }
.risks-tab-wrap { margin-top: 2.8rem; }
.risks-tab-wrap .nav-tabs { border-bottom: 2px solid #EDBED6; flex-wrap: nowrap; overflow-x: auto; -webkit-overflow-scrolling: touch; scrollbar-width: none; }
.risks-tab-wrap .nav-tabs::-webkit-scrollbar { display: none; }
.cond-card { border: 1.5px solid #EDBED6; border-radius: 16px; padding: 2.2rem 2.5rem; background: #fff; margin-top: 1.5rem; animation: riskFadeUp 0.35s ease both; }
@keyframes riskFadeUp { from { opacity: 0; transform: translateY(14px); } to { opacity: 1; transform: translateY(0); } }
.cond-card .cond-overline { font-size: 0.7rem; letter-spacing: 0.18em; text-transform: uppercase; color: #D81B7A; font-weight: 600; }
.cond-card h3 { font-family: 'Playfair Display', Georgia, serif; font-size: 1.6rem; margin: 0.3rem 0 1.1rem; color: #1A1A2E; }
.cond-card h3 span { color: #D81B7A; }
.cond-card p { font-size: 1.92rem; line-height: 1.78; color: #444; margin-bottom: 1rem; }
.risk-chips { display: flex; flex-wrap: wrap; gap: 0.55rem; margin: 1.4rem 0; }
.risk-chip { background: #F8D7E8; color: #D81B7A; border-radius: 999px; padding: 0.35rem 1rem; font-size: 1.6rem; font-weight: 600; letter-spacing: 0.02em; }
.risks-highlight-box { background: #FDF4F8; border-left: 4px solid #D81B7A; border-radius: 0 12px 12px 0; padding: 1.1rem 1.4rem; margin: 1.5rem 0; font-size: 1.86rem; color: #1A1A2E; line-height: 1.65; }
.risks-highlight-box strong { color: #D81B7A; }
.risks-or-table-wrap { margin-top: 1.5rem; overflow-x: auto; }
.risks-or-table { width: 100%; border-collapse: collapse; font-size: 0.88rem; }
.risks-or-table thead th { background: #F8D7E8; color: #D81B7A; font-weight: 700; font-size: 0.72rem; letter-spacing: 0.1em; text-transform: uppercase; padding: 0.7rem 1rem; text-align: left; border-bottom: 2px solid #EDBED6; }
.risks-or-table tbody tr { border-bottom: 1px solid #EDBED6; }
.risks-or-table tbody tr:last-child { border-bottom: none; }
.risks-or-table tbody td { padding: 0.7rem 1rem; color: #444; }
.risks-or-table tbody td:first-child { font-weight: 600; color: #1A1A2E; }
.risks-prevention-card { background: linear-gradient(135deg, #F8D7E8 0%, #fff 100%); border: 1.5px solid #EDBED6; border-radius: 16px; padding: 2rem 2.4rem; margin-top: 2rem; }
.risks-prevention-card h4 { font-family: 'Playfair Display', Georgia, serif; color: #1A1A2E; font-size: 1.25rem; margin: 0.4rem 0 1rem; }
.risks-prevention-card h4 span { color: #D81B7A; }
.risks-prevention-card ul { padding-left: 1.2rem; font-size: 1.86rem; color: #444; line-height: 2; }
.risks-prevention-card ul li::marker { color: #D81B7A; }
@media(max-width:640px){ .risks-hero { margin: 1rem; padding: 2rem 1.4rem; } .risks-intro-card, .cond-card { padding: 1.5rem 1.2rem; } }
"

# ── Helper: build one condition tabPanel ─────────────────────────────────────
cond_panel <- function(overline, title_plain, title_pink,
                       paragraphs, chips = NULL,
                       highlight = NULL, table_data = NULL,
                       prevention = NULL) {
  tabPanel(
    title = overline,
    div(class = "cond-card",
        div(class = "cond-overline", overline),
        h3(title_plain, tags$span(title_pink)),
        lapply(paragraphs, function(p) tags$p(HTML(p))),
        if (!is.null(chips))
          div(class = "risk-chips",
              lapply(chips, function(ch) div(class = "risk-chip", ch))),
        if (!is.null(highlight))
          div(class = "risks-highlight-box", HTML(highlight)),
        if (!is.null(table_data))
          div(class = "risks-or-table-wrap",
              tags$table(class = "risks-or-table",
                         tags$thead(tags$tr(lapply(names(table_data), function(h) tags$th(h)))),
                         tags$tbody(
                           lapply(seq_len(nrow(table_data)), function(i)
                             tags$tr(lapply(seq_len(ncol(table_data)), function(j)
                               tags$td(as.character(table_data[i, j]))
                             ))
                           )
                         )
              )
          ),
        if (!is.null(prevention))
          div(class = "risks-prevention-card",
              div(class = "cond-overline", "MANAGEMENT INSIGHT"),
              h4(prevention$title, tags$span(prevention$title_pink)),
              tags$ul(lapply(prevention$items, tags$li))
          )
    )
  )
}

# ══════════════════════════════════════════════════════════════════════════════
#  MAIN UI
# ══════════════════════════════════════════════════════════════════════════════

navbarPage("Health is Wealth",
           tags$head(tags$style(HTML(risks_css))),
           
           # ── 1. ABOUT ──────────────────────────────────────────────────────────────
           tabPanel("About",
                    tags$head(tags$style(HTML("
      @import url('https://fonts.googleapis.com/css2?family=Playfair+Display:wght@700;900&family=Source+Sans+3:wght@400;600&display=swap');
      body { font-family: 'Source Sans 3', sans-serif; }
      .about-section { max-width: 1500px; margin: 30px auto 60px; padding: 0 24px; }
      .about-card { background: #ffffff; border-radius: 24px; padding: 48px 52px; box-shadow: 0 20px 60px rgba(230,57,133,0.12), 0 4px 16px rgba(0,0,0,0.06); border-top: 6px solid #e63985; }
      .about-label { font-size: 1.5rem; font-weight: 700; letter-spacing: 0.15em; text-transform: uppercase; color: #e63985; margin-bottom: 12px; }
      .about-heading { font-family: 'Playfair Display', serif; font-size: 3rem; font-weight: 700; color: #1a1a2e; margin-bottom: 24px; line-height: 1.25; }
      .about-heading span { color: #e63985; }
      .about-text { font-size: 2.0rem; line-height: 1.85; color: #444; margin-bottom: 18px; }
      .stat-row { display: flex; gap: 16px; flex-wrap: wrap; margin-top: 32px; }
      .stat-pill { flex: 1; min-width: 150px; background: linear-gradient(135deg, #fff0f7, #fff8f0); border: 2px solid #f7c5de; border-radius: 16px; padding: 20px 24px; text-align: center; }
      .stat-number { font-family: 'Playfair Display', serif; font-size: 2.2rem; font-weight: 900; color: #e63985; display: block; }
      .stat-desc { font-size: 0.82rem; font-weight: 600; color: #888; text-transform: uppercase; letter-spacing: 0.06em; margin-top: 4px; }
      .map-page { max-width: 1500px; margin: 30px auto 60px; padding: 0 24px; font-family: 'Source Sans 3', sans-serif; }
      .map-label { font-size:10rem; font-weight: 700; letter-spacing: 0.15em; text-transform: uppercase; color: #e63985; margin-bottom: 10px; }
      .map-heading { font-family: 'Playfair Display', serif; font-size: 3rem; font-weight: 700; color: #1a1a2e; margin-bottom: 24px; line-height: 1.25; }
      .map-heading span { color: #e63985; }
      .map-intro { font-size: 2.0rem; color: #555; line-height: 1.8; margin-bottom: 28px; max-width: 780px; }
      .map-card { background: #ffffff; border-radius: 24px; box-shadow: 0 20px 60px rgba(230,57,133,0.12), 0 4px 16px rgba(0,0,0,0.06); overflow: hidden; border-top: 6px solid #e63985; margin-top: 20px; padding: 0; width: 100%; }
      .map-card .leaflet-container { border-radius: 14px; }
      .hero-section { width: 100%; margin-bottom: 60px; padding: 80px 20px 60px; text-align: center; background: #FADADD; border-radius: 24px; box-shadow: 0 12px 40px rgba(0,0,0,0.06); }
      .hero-title { font-family: 'Playfair Display', serif; font-size: 10rem; font-weight: 800; color: #e63985; margin-bottom: 18px; }
      .hero-subtitle { font-family: 'Playfair Display', serif; font-size: 5rem; color: #333; font-weight: 400; }
      .hero-link { display: inline-block; margin-top: 10px; font-size: 3.0rem; font-family: 'Playfair Display', serif; color: #e63985; text-decoration: none; font-weight: 600; border-bottom: 2px solid #e63985; padding-bottom: 4px; transition: all 0.2s ease; }
      .hero-link:hover { color: #c2185b; border-color: #c2185b; }
      .types-hero { text-align: center; padding: 60px 20px 30px 20px; }
      .types-hero-heading { font-family: 'Playfair Display', serif; font-size: 5.0rem; font-weight: 700; color: #e63985; margin-bottom: 10px; }
      .types-hero-label { font-size: 2.0rem; font-weight: 700; letter-spacing: 0.14em; text-transform: uppercase; color: #e63985; margin-bottom: 10px; }
      .types-hero-subtext { font-size: 2.0rem; color: #555; max-width: 650px; margin: 0 auto; }
      .nav-tabs > li > a { color: #DC5987; font-weight: 600; font-size: 3.0rem !important; }
      .nav-tabs > li.active > a, .nav-tabs > li.active > a:hover { color: #C71585; border-bottom: 3px solid #C71585; font-weight: 300; }
    "))),
                    div(class = "about-section",
                        div(class = "hero-section",
                            div(class = "hero-title", "PCOS"),
                            div(class = "hero-subtitle", "The risk you don't see")
                        ),
                        div(style = "text-align: center; margin-top: 10px; margin-bottom: 20px;",
                            tags$a(href = "#globalMaps", "Checkout Global PCOS Data", class = "hero-link")
                        ),
                        div(class = "about-card",
                            div(class = "about-label", "About This Project"),
                            div(class = "about-heading", "Understanding ", tags$span("PCOS"), "Through Data"),
                            p(class = "about-text",
                              "Polycystic Ovary Syndrome (PCOS) is one of the most common hormonal disorders affecting women of reproductive age (typically 15-49), yet it remains widely underdiagnosed and misunderstood. Despite affecting millions of women worldwide, gaps in research, delayed diagnosis, and disparities in healthcare access continue to affect outcomes particularly for women from marginalized communities."),
                            p(class = "about-text",
                              "This project explores the prevalence, risk factors, and health outcomes associated with PCOS including metabolic complications, mental health impacts, and reproductive challenges. Using publicly available health datasets, we analyze trends by country, race, and age group to better understand disparities in diagnosis, treatment access, and long-term health outcomes."),
                            div(class = "stat-row",
                                div(class = "stat-pill",
                                    tags$span(class = "stat-number", "1 in 10"),
                                    tags$span(class = "stat-desc", "Women affected globally")),
                                div(class = "stat-pill",
                                    tags$a(href = "https://www.who.int/news-room/fact-sheets/detail/polycystic-ovary-syndrome",
                                           target = "_blank", class = "stat-link",
                                           tags$span(class = "stat-number", "70%")),
                                    tags$span(class = "stat-desc", "Cases go undiagnosed")),
                                div(class = "stat-pill",
                                    tags$span(class = "stat-number", "15-49"),
                                    tags$span(class = "stat-desc", "Reproductive age range"))
                            )
                        ),
                        div(style = "height: 60px;"),
                        div(style = "text-align: center;",
                            div(class = "about-label", "Word Cloud"),
                            div(class = "about-heading", "PCOS ", tags$span("Key Terms")),
                            p(class = "about-text",
                              "A visual snapshot of the most common terms associated with PCOS - from symptoms and hormones to diagnosis and treatment."),
                            div(style = "margin-top: 20px;",
                                plotOutput("wordcloud", width = "100%", height = "400px"))
                        ),
                        div(style = "height: 60px;"),
                        div(class = "about-card",
                            div(class = "about-label", "Causes"),
                            div(class = "about-heading", "What causes ", tags$span("PCOS"), "?"),
                            div(style = "display: flex; align-items: center; gap: 40px; flex-wrap: wrap;",
                                div(style = "flex: 1; min-width: 100px; font-size: 3rem; font-family: 'Times New Roman', serif;",
                                    p(class = "about-text", "The exact cause of PCOS is unknown. It is thought to happen due to a mix of:",
                                      tags$ol(
                                        tags$li("Genetic (inherited)"),
                                        tags$li("Hormonal"),
                                        tags$li("Lifestyle"),
                                        tags$li("Environmental factors")),
                                      tags$p(tags$strong("Source: "),
                                             tags$a(href = "https://www.healthdirect.gov.au/polycystic-ovarian-syndrome-pcos",
                                                    "Healthdirect Australia", target = "_blank",
                                                    style = "color:#e63985; text-decoration: none;"),
                                             style = "margin-top: 8px; font-size: 1.5rem; color: #666;"))),
                                div(style = "flex: 1; min-width: 200px; min-height: 60%; text-align: center;",
                                    tags$img(src = "polycystic-ovarian-syndrome-pcos-bae428.png",
                                             style = "max-width: 80%; height: 50%;"))
                            )
                        ),
                        div(id = "globalMaps", class = "about-section",
                            div(class = "map-label", "Epidemiology"),
                            div(class = "map-heading", "Global PCOS ", tags$span("Incidence (1990)"), style = "font-size: 3.0rem;"),
                            p(class = "map-intro", style = "font-size: 1.5rem;",
                              "This map shows country-level PCOS incidence rates per 100,000 women of adolescence age in 1990. Hover over any country to see its specific values."),
                            div(class = "map-card", leafletOutput("pcosMap1990", height = "650px")),
                            p(class = "map-source", style = "font-size: 1.5rem; color: #e36895",
                              tags$strong("Source: "),
                              tags$a(href = "https://pmc.ncbi.nlm.nih.gov/articles/PMC12104063/", target = "_blank",
                                     tags$strong("PCOS Dataset - PCOS in adolescents and young adults aged 10-24 years in 1990")))
                        ),
                        div(class = "about-section",
                            div(class = "map-label", "Epidemiology"),
                            div(class = "map-heading", "Global PCOS ", tags$span("Incidence (2021)"), style = "font-size: 3.0rem;"),
                            p(class = "map-intro", style = "font-size: 1.5rem;",
                              "This map shows country-level PCOS incidence rates per 100,000 women of adolescence age in 2021. Hover over any country to see its specific values."),
                            div(class = "map-card", leafletOutput("pcosMap", height = "650px")),
                            p(class = "map-source", style = "font-size: 1.5rem; color: #e36895",
                              tags$strong("Source: "),
                              tags$a(href = "https://pmc.ncbi.nlm.nih.gov/articles/PMC12104063/", target = "_blank",
                                     tags$strong("PCOS Dataset - PCOS in adolescents and young adults aged 10-24 years in 2021")))
                        ),
                        div(style = "text-align: center; margin-top: 20px; margin-bottom: 50px;",
                            tags$a(href = "#", "Explore PCOS Trends Over Time", class = "hero-link",
                                   onclick = "document.querySelector('a[data-value=\"Trends\"]').click(); return false;")
                        )
                    )
           ),
           
           # ── 2. TRENDS ─────────────────────────────────────────────────────────────
           tabPanel("Trends",
                    div(class = "types-hero",
                        div(class = "types-hero-label", "Data Analysis"),
                        h1(class = "types-hero-heading", "PCOS Trends"),
                        p(class = "types-hero-subtext",
                          "Explore how PCOS incidence and prevalence have changed globally from 1990 to 2021.",
                          tags$br(),
                          tags$strong("Source: "),
                          tags$a(href = "https://pmc.ncbi.nlm.nih.gov/articles/PMC12104063/", target = "_blank",
                                 tags$strong("Evolving global trends in PCOS burden: a three-decade analysis (1990-2021)")))
                    ),
                    div(class = "types-tabs-wrap",
                        mainPanel(width = 12,
                                  tabsetPanel(id = "trends_tabs",
                                              tabPanel("Baseline Incidence vs AAPC",
                                                       mainPanel(width = 12,
                                                                 div(class = "about-section",
                                                                     div(class = "map-label", "Trend Analysis"),
                                                                     div(class = "map-heading", style = "font-size: 3.0rem;",
                                                                         "Baseline Incidence ", tags$span("vs AAPC")),
                                                                     p(class = "map-intro", style = "font-size: 1.5rem;",
                                                                       "This plot shows how baseline PCOS incidence in 1990 relates to long-term average annual percent change from 1990 to 2021."),
                                                                     div(class = "map-card", plotlyOutput("scatter_aapc", height = "500px")),
                                                                     p(class = "map-source", "Source: PCOS Dataset - AAPC = Average Annual Percent Change")
                                                                 ),
                                                                 div(class = "map-card", style = "padding: 32px 36px; margin-top: 20px;",
                                                                     div(style = "font-size: 1.5rem; font-weight: 700; letter-spacing: 0.15em; text-transform: uppercase; color: #e63985; margin-bottom: 8px;", "Analysis"),
                                                                     div(style = "font-family: 'Playfair Display', serif; font-size: 4.0rem; font-weight: 700; color: #1a1a2e; margin-bottom: 20px; padding-bottom: 12px; border-bottom: 2px solid #fce8f1;",
                                                                         "Baseline Incidence vs AAPC ",
                                                                         tags$span("(Spearman p = -0.228, p = 0.001)", style = "color: #e63985; font-size: 2.0rem;")),
                                                                     div(style = "margin-bottom: 20px;",
                                                                         div(style = "font-size: 3.0rem; font-weight: 700; color: #1a1a2e; margin-bottom: 10px;", "Correlation Interpretation"),
                                                                         tags$ul(style = "padding-left: 20px; margin: 0;",
                                                                                 tags$li(style = "font-size: 2.0rem; color: #444; line-height: 1.85; margin-bottom: 6px;",
                                                                                         "Spearman correlation measures rank-based (monotonic) relationships rather than exact values."),
                                                                                 tags$li(style = "font-size: 2.0rem; color: #444; line-height: 1.85; margin-bottom: 6px;",
                                                                                         "The ", tags$strong("negative correlation (rho = -0.228)"), " indicates that as baseline incidence (1990) increases, AAPC tends to decrease slightly."),
                                                                                 tags$li(style = "font-size: 2.0rem; color: #444; line-height: 1.85;",
                                                                                         "The magnitude is ", tags$strong("small to moderate"), ", meaning the relationship is present but not strong.")
                                                                         )
                                                                     ),
                                                                     tags$hr(style = "border: none; border-top: 1px solid #fce8f1; margin: 16px 0;"),
                                                                     div(style = "margin-bottom: 20px;",
                                                                         div(style = "font-size: 3.0rem; font-weight: 700; color: #1a1a2e; margin-bottom: 10px;", "Statistical Significance"),
                                                                         tags$ul(style = "padding-left: 20px; margin: 0;",
                                                                                 tags$li(style = "font-size: 2.0rem; color: #444; line-height: 1.85; margin-bottom: 6px;",
                                                                                         tags$strong("p = 0.001"), " indicates a 0.1% probability that the relationship is due to chance."),
                                                                                 tags$li(style = "font-size: 2.0rem; color: #444; line-height: 1.85;",
                                                                                         "Since ", tags$strong("p < 0.05"), ", the result is statistically significant and reliable.")
                                                                         )
                                                                     ),
                                                                     tags$hr(style = "border: none; border-top: 1px solid #fce8f1; margin: 16px 0;"),
                                                                     div(
                                                                       div(style = "font-size: 3.0rem; font-weight: 700; color: #1a1a2e; margin-bottom: 10px;", "Trend and Uncertainty"),
                                                                       tags$ul(style = "padding-left: 20px; margin: 0;",
                                                                               tags$li(style = "font-size: 2.0rem; color: #444; line-height: 1.85; margin-bottom: 6px;",
                                                                                       "The ", tags$strong(style = "color: #d7191c;", "red line"), " represents the best-fit trend between incidence (1990) and AAPC."),
                                                                               tags$li(style = "font-size: 2.0rem; color: #444; line-height: 1.85; margin-bottom: 6px;",
                                                                                       "The ", tags$strong("shaded region"), " is the 95% confidence interval, showing uncertainty around the trend."),
                                                                               tags$li(style = "font-size: 2.0rem; color: #444; line-height: 1.85;",
                                                                                       "The widening band at higher incidence values reflects ", tags$strong("greater variability and fewer data points"), ".")
                                                                       )
                                                                     )
                                                                 )
                                                       )
                                              ),
                                              tabPanel("Regional Trend",
                                                       mainPanel(width = 12,
                                                                 div(class = "about-section",
                                                                     div(class = "map-label", "Regional Analysis"),
                                                                     div(class = "map-heading", style = "font-size: 3.0rem;",
                                                                         "PCOS Prevalence ", tags$span("by Region")),
                                                                     p(class = "map-intro", style = "font-size: 1.5rem;",
                                                                       "This bar graph compares PCOS prevalence across regions in 1990 and 2021."),
                                                                     div(class = "map-card", plotOutput("regionBarPlot", height = "500px")),
                                                                     div(style = "height: 30px;"),
                                                                     div(class = "map-card", plotOutput("regionDiffPlot", height = "500px")),
                                                                     div(style = "height: 30px;"),
                                                                     div(class = "map-card", verbatimTextOutput("regionTTest")),
                                                                     p(class = "map-source", "Source: PCOS Dataset")
                                                                 )
                                                       )
                                              ),
                                              tabPanel("SDI Trend",
                                                       mainPanel(width = 12,
                                                                 div(class = "about-section",
                                                                     div(class = "map-label", "SDI Trends"),
                                                                     div(class = "map-heading", style = "font-size: 3.0rem;",
                                                                         "PCOS Prevalence ", tags$span("by SDI Level")),
                                                                     p(class = "map-intro", style = "font-size: 1.5rem;",
                                                                       "This section compares PCOS prevalence across SDI levels in 1990 and 2021."),
                                                                     div(class = "map-card", plotOutput("sdiBarPlot", height = "500px")),
                                                                     div(style = "height: 30px;"),
                                                                     div(class = "map-card", plotOutput("sdiDiffPlot", height = "500px")),
                                                                     div(style = "height: 30px;"),
                                                                     div(class = "map-card", verbatimTextOutput("sdiTTest")),
                                                                     p(class = "map-source", "Source: PCOS Dataset - SDI = Socio-Demographic Index")
                                                                 )
                                                       )
                                              )
                                  )
                        )
                    )
           ),
           
           # ── 3. TYPES OF PCOS ──────────────────────────────────────────────────────
           tabPanel("Types of PCOS",
                    div(class = "types-hero",
                        div(class = "types-hero-label", "PCOS Guide"),
                        h1(class = "types-hero-heading", "Types of PCOS"),
                        p(class = "types-hero-subtext", "Learn about the four main types of PCOS and how each one differs",
                          tags$br(),
                          tags$strong("Source: "),
                          tags$a(href = "https://www.emilyjensennutrition.com/blog/4-types-of-pcos-and-how-to-know-which-one-you-have", target = "_blank",
                                 tags$strong("4 Types of PCOS")),
                        tags$br(),
                        tags$strong("Source: "),
                        tags$a(href = "https://www.osfhealthcare.org/blog/what-is-pcos-and-can-it-be-cured", target = "_blank",
                               tags$strong("What are the types of PCOS, and can they be cured?")))
                    ),
                    div(class = "types-tabs-wrap",
                        tabsetPanel(id = "pcos_type_tabs",
                                    tabPanel("Overview",
                                             mainPanel(width = 12,
                                                       div(class = "about-section",
                                                           style = "max-width: 63%; margin: 30px auto 60px; padding: 0 24px;",
                                                           div(class = "about-card",
                                                               div(class = "about-label", "About This Section"),
                                                               div(class = "about-heading", "PCOS", tags$span("Overview")),
                                                               p(class = "about-text",
                                                                 "Polycystic Ovary Syndrome (PCOS) is a hormonal disorder that affects how the ovaries function. It can cause irregular periods, high levels of androgens, and cysts on the ovaries. However, PCOS is not the same for everyone, and there are different types based on underlying causes."),
                                                               div(class = "stat-row",
                                                                   div(class = "stat-pill",
                                                                       tags$span(class = "stat-number", "1 in 10"),
                                                                       tags$span(class = "stat-desc", "Women affected globally")),
                                                                   div(class = "stat-pill",
                                                                       tags$span(class = "stat-number", "70%"),
                                                                       tags$span(class = "stat-desc", "Cases go undiagnosed")),
                                                                   div(class = "stat-pill",
                                                                       tags$span(class = "stat-number", "15-49"),
                                                                       tags$span(class = "stat-desc", "Reproductive age range"))
                                                               )
                                                           )
                                                       ),
                                                       div(style = "display: flex; gap: 16px; justify-content: center; align-items: center; margin-bottom: 40px;",
                                                           tags$img(src = "symptoms.png", width = "30%", height = "600px",
                                                                    style = "border: 1px solid #000000; border-radius: 8px;"),
                                                           tags$img(src = "types_of_pcos.png", width = "30%", height = "600px",
                                                                    style = "border: 1px solid #000000; border-radius: 8px;")
                                                       )
                                             )
                                    ),
                                    tabPanel("Insulin Resistant PCOS",
                                             mainPanel(width = "15",
                                                       div(class = "tx-page",
                                                           div(class = "tx-page-heading", "Insulin Resistant ", tags$span("PCOS")),
                                                           p(class = "tx-page-intro", "The most common type, accounting for ~70% of PCOS cases."),
                                                           div(class = "tx-card",
                                                               div(class = "tx-card-header",
                                                                   div(p(class = "tx-card-subtitle", style = "text-align: center; width: 100%;", "Most Common Type"))),
                                                               div(class = "tx-card-body",
                                                                   div(class = "tx-badge-row", span(class = "tx-badge", "~70% of Cases")),
                                                                   p(class = "tx-desc", "Insulin resistant PCOS occurs when the body's cells don't respond properly to insulin, leading to elevated insulin levels. High insulin then signals the ovaries to overproduce androgens, disrupting ovulation and causing the hallmark symptoms of PCOS."),
                                                                   p(tags$strong("Key symptoms:"), style = "font-size:0.92rem;color:#333;margin-bottom:8px;"),
                                                                   div(class = "tx-pills",
                                                                       span(class = "tx-pill", "Belly weight gain"), span(class = "tx-pill", "Irregular periods"),
                                                                       span(class = "tx-pill", "Acne & oily skin"), span(class = "tx-pill", "Hair thinning"),
                                                                       span(class = "tx-pill", "Brain fog"), span(class = "tx-pill", "Sugar cravings")),
                                                                   p(tags$strong("Management approaches:"), style = "font-size:0.92rem;color:#333;margin-bottom:8px;margin-top:12px;"),
                                                                   div(class = "tx-pills",
                                                                       span(class = "tx-pill", "Low-carb diet"), span(class = "tx-pill", "Regular exercise"),
                                                                       span(class = "tx-pill", "Prioritise sleep"), span(class = "tx-pill", "Inositol"),
                                                                       span(class = "tx-pill", "Berberine"), span(class = "tx-pill", "Magnesium")),
                                                                   div(class = "tx-note",
                                                                       tags$strong("Key marker: "), "Elevated fasting insulin is the hallmark diagnostic indicator. Also check HbA1c, triglycerides, and ALT.")
                                                               )
                                                           )
                                                       )
                                             )
                                    ),
                                    tabPanel("Post-pill PCOS",
                                             mainPanel(width = "12",
                                                       div(class = "tx-page",
                                                           div(class = "tx-page-heading", "Post-Pill ", tags$span("PCOS")),
                                                           p(class = "tx-page-intro", "Develops after stopping hormonal contraceptives."),
                                                           div(class = "tx-card",
                                                               div(class = "tx-card-header",
                                                                   div(p(class = "tx-card-subtitle", style = "text-align: center; width: 100%;", "Temporary Type"))),
                                                               div(class = "tx-card-body",
                                                                   div(class = "tx-badge-row", span(class = "tx-badge", "Often Reversible")),
                                                                   p(class = "tx-desc", "Post-pill PCOS develops when the body's hormones take time to rebalance after stopping hormonal contraceptives. This is not permanent PCOS and typically resolves within 3-6 months."),
                                                                   p(tags$strong("Key symptoms:"), style = "font-size:0.92rem;color:#333;margin-bottom:8px;"),
                                                                   div(class = "tx-pills",
                                                                       span(class = "tx-pill", "Cycle irregularity"), span(class = "tx-pill", "Increased acne"),
                                                                       span(class = "tx-pill", "Elevated testosterone"), span(class = "tx-pill", "Mood changes"),
                                                                       span(class = "tx-pill", "Temporary hair loss")),
                                                                   p(tags$strong("Management approaches:"), style = "font-size:0.92rem;color:#333;margin-bottom:8px;margin-top:12px;"),
                                                                   div(class = "tx-pills",
                                                                       span(class = "tx-pill", "Natural hormone reset"), span(class = "tx-pill", "Seed cycling"),
                                                                       span(class = "tx-pill", "Vitex (chasteberry)"), span(class = "tx-pill", "Liver-supporting foods")),
                                                                   div(class = "tx-note",
                                                                       tags$strong("Important: "), "Reassessment after 6 months is recommended before confirming a PCOS diagnosis.")
                                                               )
                                                           )
                                                       )
                                             )
                                    ),
                                    tabPanel("Adrenal PCOS",
                                             mainPanel(width = "12",
                                                       div(class = "tx-page",
                                                           div(class = "tx-page-heading", "Adrenal ", tags$span("PCOS")),
                                                           p(class = "tx-page-intro", "Driven by an overactive stress response rather than insulin."),
                                                           div(class = "tx-card",
                                                               div(class = "tx-card-header",
                                                                   div(p(class = "tx-card-subtitle", style = "text-align: center; width: 100%;", "Stress-Driven Type"))),
                                                               div(class = "tx-card-body",
                                                                   div(class = "tx-badge-row", span(class = "tx-badge", "Adrenal Androgen Excess")),
                                                                   p(class = "tx-desc", "Adrenal PCOS is rooted in a dysregulated stress response. The adrenal glands produce excess DHEA-S, an androgen that disrupts the hormonal balance needed for regular ovulation."),
                                                                   p(tags$strong("Key symptoms:"), style = "font-size:0.92rem;color:#333;margin-bottom:8px;"),
                                                                   div(class = "tx-pills",
                                                                       span(class = "tx-pill", "Anxiety & fatigue"), span(class = "tx-pill", "Irregular periods"),
                                                                       span(class = "tx-pill", "Acne & facial hair"), span(class = "tx-pill", "Poor stress tolerance"),
                                                                       span(class = "tx-pill", "Sleep disturbances")),
                                                                   p(tags$strong("Management approaches:"), style = "font-size:0.92rem;color:#333;margin-bottom:8px;margin-top:12px;"),
                                                                   div(class = "tx-pills",
                                                                       span(class = "tx-pill", "Stress reduction"), span(class = "tx-pill", "Ashwagandha"),
                                                                       span(class = "tx-pill", "Adequate sleep"), span(class = "tx-pill", "Magnesium"),
                                                                       span(class = "tx-pill", "Vitamin C"), span(class = "tx-pill", "Vitamin B5")),
                                                                   div(class = "tx-note",
                                                                       tags$strong("Key marker: "), "Elevated DHEA-S with normal insulin levels points to adrenal PCOS.")
                                                               )
                                                           )
                                                       )
                                             )
                                    ),
                                    tabPanel("Inflammatory PCOS",
                                             mainPanel(width = "12",
                                                       div(class = "tx-page",
                                                           div(class = "tx-page-heading", "Inflammatory ", tags$span("PCOS")),
                                                           p(class = "tx-page-intro", "Chronic low-grade inflammation disrupts ovulation and stimulates androgens."),
                                                           div(class = "tx-card",
                                                               div(class = "tx-card-header",
                                                                   div(p(class = "tx-card-subtitle", style = "text-align: center; width: 100%;", "Immune-Driven Type"))),
                                                               div(class = "tx-card-body",
                                                                   div(class = "tx-badge-row", span(class = "tx-badge", "Chronic Inflammation")),
                                                                   p(class = "tx-desc", "Inflammatory PCOS is driven by persistent low-grade inflammation, triggered by gut issues, food sensitivities, or environmental toxins, which stimulates androgen production and impairs ovulation."),
                                                                   p(tags$strong("Key symptoms:"), style = "font-size:0.92rem;color:#333;margin-bottom:8px;"),
                                                                   div(class = "tx-pills",
                                                                       span(class = "tx-pill", "Fatigue & joint pain"), span(class = "tx-pill", "Headaches"),
                                                                       span(class = "tx-pill", "Digestive problems"), span(class = "tx-pill", "Mood disorders"),
                                                                       span(class = "tx-pill", "Unexplained weight gain")),
                                                                   p(tags$strong("Management approaches:"), style = "font-size:0.92rem;color:#333;margin-bottom:8px;margin-top:12px;"),
                                                                   div(class = "tx-pills",
                                                                       span(class = "tx-pill", "Anti-inflammatory diet"), span(class = "tx-pill", "Omega-3"),
                                                                       span(class = "tx-pill", "Gut health support"), span(class = "tx-pill", "Turmeric"),
                                                                       span(class = "tx-pill", "Zinc"), span(class = "tx-pill", "Vitamin D")),
                                                                   div(class = "tx-note",
                                                                       tags$strong("Note: "), "Inflammatory markers like CRP, white blood cell count, and homocysteine should be tested.")
                                                               )
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
                    tags$head(tags$style(HTML("
      @import url('https://fonts.googleapis.com/css2?family=Playfair+Display:wght@700;900&family=Source+Sans+3:wght@400;600&display=swap');
      .tx-page { max-width: 1100px; margin: 36px auto 72px; padding: 0 32px; font-family: 'Source Sans 3', sans-serif; }
      .tx-page-label { font-size: 1.0rem; font-weight: 700; letter-spacing: 0.15em; text-transform: uppercase; color: #e63985; margin-bottom: 10px; }
      .tx-page-heading { font-family: 'Playfair Display', serif; font-size: 3.0rem; font-weight: 700; color: #1a1a2e; margin-bottom: 15px; line-height: 1.25; }
      .tx-page-heading span { color: #e63985; }
      .tx-page-intro { font-size: 2.0rem; color: #555; line-height: 1.8; margin-bottom: 40px; max-width: 860px; }
      .tx-card { background: #ffffff; border-radius: 20px; box-shadow: 0 12px 40px rgba(230,57,133,0.10), 0 2px 10px rgba(0,0,0,0.05); margin-bottom: 28px; overflow: hidden; transition: transform 0.2s ease, box-shadow 0.2s ease; }
      .tx-card:hover { transform: translateY(-3px); }
      .tx-card-header { padding: 0; border-bottom: 1px solid #fce8f1; }
      .tx-toggle-btn { width: 100%; background: none; border: none; padding: 28px 32px 22px; display: flex; align-items: center; justify-content: space-between; gap: 18px; text-align: left; }
      .tx-toggle-left { display: flex; align-items: center; gap: 18px; }
      .tx-icon { width: 60px; height: 60px; border-radius: 14px; display: flex; align-items: center; justify-content: center; font-size: 3.0rem; flex-shrink: 0; }
      .tx-icon-green { background: linear-gradient(135deg, #e8f8f0, #d0f0e0); }
      .tx-icon-pink  { background: linear-gradient(135deg, #fff0f7, #fcd8eb); }
      .tx-icon-purple{ background: linear-gradient(135deg, #f3f0ff, #e2d9fb); }
      .tx-card-title { font-family: 'Playfair Display', serif; font-size: 3.0rem; font-weight: 700; color: #1a1a2e; margin: 0 0 4px; }
      .tx-card-subtitle { font-size: 1.88rem; font-weight: 600; letter-spacing: 0.08em; text-transform: uppercase; color: #e63985; margin: 0; }
      .tx-card-body { padding: 24px 32px 28px; }
      .tx-desc { font-size: 1.88rem; color: #444; line-height: 1.85; margin-bottom: 20px; }
      .tx-pills { display: flex; flex-wrap: wrap; gap: 8px; margin-bottom: 20px; }
      .tx-pill { font-size: 1.33rem; font-weight: 600; padding: 6px 16px; border-radius: 999px; border: 1.5px solid #f0a0c8; background: #fff0f7; color: #c0185f; }
      .tx-note { background: linear-gradient(135deg, #fff8fb, #fff4f0); border-left: 4px solid #e63985; border-radius: 10px; padding: 16px 20px; font-size: 1.88rem; color: #555; line-height: 1.75; margin-top: 10px; }
      .tx-note strong { color: #e63985; }
      .tx-badge { font-size: 1.2rem; font-weight: 700; padding: 5px 14px; border-radius: 999px; text-transform: uppercase; letter-spacing: 0.08em; background: linear-gradient(135deg, #fff0f7, #ffe3ef); color: #e63985; border: 1.5px solid #f0a0c8; }
      .tx-chevron { font-size: 1.4rem; color: #e63985; transition: transform 0.3s ease; display: inline-block; flex-shrink: 0; }
      .tx-chevron.open { transform: rotate(180deg); }
    "))),
                    mainPanel(width = 12,
                              div(class = "tx-page",
                                  div(class = "tx-page-label", "Managing PCOS"),
                                  div(class = "tx-page-heading", "Treatment ", tags$span("Options")),
                                  p(class = "tx-page-intro",
                                    "PCOS management is highly individual. Treatment goals vary from regulating cycles and managing symptoms to supporting fertility. Below are key approaches used by clinicians worldwide."),
                                  p(class = "subtext",
                                    tags$strong("Source: "),
                                    tags$a(href = "https://pmc.ncbi.nlm.nih.gov/articles/PMC3277302/", target = "_blank",
                                           tags$strong("All Women With PCOS Should Be Treated For Insulin Resistance"))),
                                  div(class = "tx-card",
                                      div(class = "tx-card-header",
                                          actionButton("toggle_diet", label = tagList(
                                            div(class = "tx-toggle-left",
                                                div(class = "tx-icon tx-icon-pink", "\U0001F957"),
                                                div(p(class = "tx-card-subtitle", "Lifestyle Intervention"), h3(class = "tx-card-title", "Dietary Therapy"))),
                                            span(id = "chev_diet", class = "tx-chevron", "v")), class = "tx-toggle-btn")),
                                      div(id = "body_diet", class = "tx-card-body", style = "display: none;",
                                          div(class = "tx-badge-row", span(class = "tx-badge", "First-line treatment")),
                                          p(class = "tx-desc", "Dietary therapy is typically the first recommended approach for managing PCOS. A low-glycemic, anti-inflammatory diet can reduce androgen levels, improve menstrual regularity, and support metabolic health."),
                                          p(tags$strong("Key dietary approaches:"), style = "font-size:1.05rem;color:#333;margin-bottom:8px;"),
                                          div(class = "tx-pills",
                                              span(class = "tx-pill", "Low-GI diet"), span(class = "tx-pill", "Anti-inflammatory foods"),
                                              span(class = "tx-pill", "Reduced refined carbs"), span(class = "tx-pill", "High fiber intake"),
                                              span(class = "tx-pill", "Omega-3 rich foods"), span(class = "tx-pill", "Caloric balance")),
                                          div(class = "tx-note",
                                              tags$strong("Important: "), "A 5-10% reduction in body weight can restore ovulation and improve hormonal balance in women with PCOS."))
                                  ),
                                  div(class = "tx-card",
                                      div(class = "tx-card-header",
                                          actionButton("toggle_lod", label = tagList(
                                            div(class = "tx-toggle-left",
                                                div(class = "tx-icon tx-icon-pink", "\U0001F52C"),
                                                div(p(class = "tx-card-subtitle", "Surgical Procedure"), h3(class = "tx-card-title", "Laparoscopic Ovarian Drilling (LOD)"))),
                                            span(id = "chev_lod", class = "tx-chevron", "v")), class = "tx-toggle-btn")),
                                      div(id = "body_lod", class = "tx-card-body", style = "display: none;",
                                          div(class = "tx-badge-row", span(class = "tx-badge", "Surgical option")),
                                          p(class = "tx-desc", "LOD is a minimally invasive surgical procedure performed under general anesthesia. Introduced in 1984, it is successful in approximately 84% of patients, improving insulin resistance and increasing SHBG levels."),
                                          p(tags$strong("Typical candidates & outcomes:"), style = "font-size:1.05rem;color:#333;margin-bottom:8px;"),
                                          div(class = "tx-pills",
                                              span(class = "tx-pill", "Clomiphene-resistant PCOS"), span(class = "tx-pill", "Anovulatory infertility"),
                                              span(class = "tx-pill", "Elevated LH levels"), span(class = "tx-pill", "No multiple pregnancy risk")),
                                          div(class = "tx-note",
                                              tags$strong("Note: "), "LOD does not treat all PCOS symptoms - it primarily targets ovulation."))
                                  ),
                                  div(class = "tx-card",
                                      div(class = "tx-card-header",
                                          actionButton("toggle_art", label = tagList(
                                            div(class = "tx-toggle-left",
                                                div(class = "tx-icon tx-icon-pink", "\U0001F9EC"),
                                                div(p(class = "tx-card-subtitle", "Fertility Treatment"), h3(class = "tx-card-title", "Assisted Reproductive Technology (ART)"))),
                                            span(id = "chev_art", class = "tx-chevron", "v")), class = "tx-toggle-btn")),
                                      div(id = "body_art", class = "tx-card-body", style = "display: none;",
                                          div(class = "tx-badge-row", span(class = "tx-badge", "Specialized care")),
                                          p(class = "tx-desc", "ART encompasses a range of fertility treatments. For women with PCOS, IVF is the most common option. PCOS patients often respond strongly to ovarian stimulation, requiring careful monitoring to prevent OHSS."),
                                          p(tags$strong("Common ART approaches for PCOS:"), style = "font-size:1.05rem;color:#333;margin-bottom:8px;"),
                                          div(class = "tx-pills",
                                              span(class = "tx-pill", "IVF"), span(class = "tx-pill", "Ovulation induction"),
                                              span(class = "tx-pill", "Embryo freezing"), span(class = "tx-pill", "Egg freezing"),
                                              span(class = "tx-pill", "ICSI"), span(class = "tx-pill", "Frozen embryo transfer")),
                                          div(class = "tx-note",
                                              tags$strong("OHSS Risk: "), "Women with PCOS are at higher risk for ovarian hyperstimulation during ART."))
                                  ),
                                  div(class = "tx-card",
                                      div(class = "tx-card-header",
                                          actionButton("toggle_ocp", label = tagList(
                                            div(class = "tx-toggle-left",
                                                div(class = "tx-icon tx-icon-pink", "\U0001F48A"),
                                                div(p(class = "tx-card-subtitle", "Hormonal Treatment"), h3(class = "tx-card-title", "Combined Oral Contraceptive Pills (OCPs)"))),
                                            span(id = "chev_ocp", class = "tx-chevron", "v")), class = "tx-toggle-btn")),
                                      div(id = "body_ocp", class = "tx-card-body", style = "display: none;",
                                          div(class = "tx-badge-row", span(class = "tx-badge", "First-choice treatment")),
                                          p(class = "tx-desc", "Combined oral contraceptive pills (OCPs) are considered the first-choice treatment for PCOS. They suppress LH and FSH, reduce ovarian androgen production, and regulate the menstrual cycle."),
                                          p(tags$strong("Key benefits:"), style = "font-size:1.05rem;color:#333;margin-bottom:8px;"),
                                          div(class = "tx-pills",
                                              span(class = "tx-pill", "Regulates periods"), span(class = "tx-pill", "Reduces androgens"),
                                              span(class = "tx-pill", "Decreases acne"), span(class = "tx-pill", "Reduces hirsutism"),
                                              span(class = "tx-pill", "Increases SHBG"), span(class = "tx-pill", "Protects endometrium")),
                                          div(class = "tx-note",
                                              tags$strong("Note: "), "OCPs do not treat the underlying metabolic causes of PCOS such as insulin resistance."))
                                  ),
                                  div(style = "text-align: center; margin-top: 16px;",
                                      tags$img(src = "treatment.png", width = "400px",
                                               style = "border: 1px solid #e63985; border-radius: 1px;"))
                              )
                    )
           ),
           
           # ── 5. DATA CHECK OUT ─────────────────────────────────────────────────────
           tabPanel("Data Check Out",
                    tags$head(tags$style(HTML("
      .dc-page { max-width: 1500px; margin: 36px auto 72px; padding: 0 24px; font-family: 'Source Sans 3', sans-serif; }
      .dc-page-label { font-size: 2.0rem; font-weight: 700; letter-spacing: 0.15em; text-transform: uppercase; color: #e63985; margin-bottom: 10px; }
      .dc-page-heading { font-family: 'Playfair Display', serif; font-size: 5.0rem; font-weight: 700; color: #1a1a2e; margin-bottom: 12px; line-height: 1.25; }
      .dc-page-heading span { color: #e63985; }
      .dc-page-intro { font-size: 2.0rem; color: #555; line-height: 1.8; margin-bottom: 40px; max-width: 2000px; }
      .dc-layout { display: flex; gap: 28px; align-items: flex-start; flex-wrap: wrap; }
      .dc-sidebar { flex: 0 0 300px; min-width: 260px; }
      .dc-main { flex: 1; min-width: 280px; }
      .dc-form-card { background: #ffffff; border-radius: 20px; box-shadow: 0 12px 40px rgba(230,57,133,0.10), 0 2px 10px rgba(0,0,0,0.05); border-top: 5px solid #e63985; padding: 28px 28px 32px; }
      .dc-section-title { font-family: 'Playfair Display', serif; font-size: 2.0rem; font-weight: 700; color: #1a1a2e; margin: 0 0 16px; padding-bottom: 10px; border-bottom: 1px solid #fce8f1; }
      .dc-form-card label { font-size: 1.5rem; font-weight: 600; color: #444; margin-bottom: 4px; display: block; }
      .dc-form-card input[type='number'], .dc-form-card select { border: 1.5px solid #f0c0d8 !important; border-radius: 10px !important; font-size: 1.5rem !important; padding: 8px 12px !important; color: #333; width: 100%; margin-bottom: 14px; }
      .dc-submit-btn { width: 100%; padding: 12px; background: linear-gradient(135deg, #e63985, #f0699e) !important; color: #fff !important; font-weight: 700; font-size: 1.5rem; border: none !important; border-radius: 12px !important; cursor: pointer; text-transform: uppercase; margin-top: 6px; }
      .dc-result-card { background: #ffffff; border-radius: 20px; box-shadow: 0 12px 40px rgba(230,57,133,0.10), 0 2px 10px rgba(0,0,0,0.05); margin-bottom: 24px; overflow: hidden; border-top: 5px solid #e63985; padding: 26px 30px; }
      .dc-result-label { font-size: 2.5rem; font-weight: 700; letter-spacing: 0.15em; text-transform: uppercase; color: #e63985; margin-bottom: 6px; }
      .dc-result-title { font-family: 'Playfair Display', serif; font-size: 2.5rem; font-weight: 700; color: #1a1a2e; margin-bottom: 14px; }
      .dc-bmi-value { font-family: 'Playfair Display', serif; font-size: 3.2rem; font-weight: 900; color: #e63985; line-height: 1; }
      .dc-table { width: 100%; border-collapse: collapse; font-size: 2.0rem; color: #444; }
      .dc-table th { text-align: left; padding: 10px 12px; background: linear-gradient(135deg, #fff0f7, #fff8f0); font-size: 2.0rem; font-weight: 700; text-transform: uppercase; color: #e63985; border-bottom: 2px solid #fce8f1; }
      .dc-table td { padding: 10px 12px; border-bottom: 1px solid #fce8f1; }
      .dc-note { background: linear-gradient(135deg, #fff8fb, #fff4f0); border-left: 4px solid #e63985; border-radius: 10px; padding: 14px 18px; font-size: 2.5rem; color: #555; line-height: 1.75; }
      .dc-note strong { color: #e63985; }
      .dc-warning { background: linear-gradient(135deg, #fffbf0, #fff8e8); border-left: 4px solid #f5a623; border-radius: 10px; padding: 14px 18px; font-size: 2.5rem; color: #555; line-height: 1.75; margin-top: 16px; }
      .dc-conclusions-list { line-height: 2; padding-left: 18px; margin-bottom: 0; }
      .dc-conclusions-list li { font-size: 2.0rem; margin-bottom: 6px; }
    "))),
                    div(class = "dc-page",
                        div(class = "dc-page-label", "Personal Assessment"),
                        div(class = "dc-page-heading", "Data ", tags$span("Check Out")),
                        p(class = "dc-page-intro",
                          "Enter your health information below to get a personalised snapshot based on what the data and research tell us about PCOS risk factors."),
                        div(class = "dc-layout",
                            div(class = "dc-sidebar",
                                div(class = "dc-form-card",
                                    div(class = "dc-section-title", "Step 1: Calculate BMI"),
                                    numericInput("weight", "Weight (kg):", value = NULL, min = 1),
                                    numericInput("height", "Height (cm):", value = NULL, min = 1),
                                    tags$hr(style = "border: none; border-top: 1px solid #fce8f1; margin: 18px 0;"),
                                    div(class = "dc-section-title", "Step 2: Health Information"),
                                    numericInput("age", "Age (years):", value = NULL, min = 1, max = 120),
                                    selectInput("menstrual", "Menstrual Regularity:", choices = c("Select..." = "", "Regular", "Irregular")),
                                    selectInput("acne", "Acne Severity:", choices = c("Select..." = "", "None", "Mild", "Moderate", "Severe")),
                                    selectInput("stress", "Stress Level:", choices = c("Select..." = "", "Low", "Medium", "High")),
                                    selectInput("fertility", "Fertility Concern:", choices = c("Select..." = "", "Yes", "No")),
                                    selectInput("insulin", "Insulin Resistance:", choices = c("Select..." = "", "Yes", "No")),
                                    actionButton("calculate", "Submit", class = "dc-submit-btn btn")
                                )
                            ),
                            div(class = "dc-main",
                                div(class = "dc-result-card",
                                    div(class = "dc-result-label", "BMI Result"),
                                    div(class = "dc-result-title", "Body Mass Index"),
                                    uiOutput("bmi_display")),
                                div(class = "dc-result-card",
                                    div(class = "dc-result-label", "Health Summary"),
                                    div(class = "dc-result-title", "Your Inputs at a Glance"),
                                    uiOutput("health_summary_styled")),
                                div(class = "dc-result-card",
                                    div(class = "dc-result-label", "Insights"),
                                    div(class = "dc-result-title", "What the Data Says About Your Case"),
                                    uiOutput("data_conclusions"))
                            )
                        )
                    )
           ),
           
           # ── 6. RISKS AND COMORBIDITIES ────────────────────────────────────────────
           navbarMenu("Risks and Comorbidities",
                      
                      tabPanel("Overview",
                               div(class = "risks-hero",
                                   div(class = "overline", "PCOS Guide"),
                                   tags$h1("Risks & Comorbidities"),
                                   tags$p("PCOS extends far beyond reproductive health. Explore the systemic conditions linked to PCOS and how they affect long-term wellbeing.")
                               ),
                               div(class = "risks-section-wrap",
                                   div(class = "risks-intro-card",
                                       div(class = "overline", "ABOUT THIS SECTION"),
                                       tags$h2("PCOS ", tags$span("Comorbidities Overview")),
                                       tags$p("Polycystic Ovary Syndrome is not limited to reproductive dysfunction. Research shows it significantly elevates risk for several serious non-communicable diseases. Understanding these connections is critical for early detection, prevention, and comprehensive care."),
                                       div(class = "risks-stat-row",
                                           div(class = "risks-stat-badge",
                                               tags$span(class = "stat-num", "2.7x"),
                                               tags$span(class = "stat-label", "Higher risk of endometrial cancer")),
                                           div(class = "risks-stat-badge",
                                               tags$span(class = "stat-num", "70%"),
                                               tags$span(class = "stat-label", "PCOS women affected by dyslipidemia")),
                                           div(class = "risks-stat-badge",
                                               tags$span(class = "stat-num", "80%"),
                                               tags$span(class = "stat-label", "Obese PCOS women with insulin resistance")),
                                           div(class = "risks-stat-badge",
                                               tags$span(class = "stat-num", "35-80%"),
                                               tags$span(class = "stat-label", "PCOS women experience insulin resistance"))
                                       )
                                   ),
                                   div(class = "risks-tab-wrap",
                                       tabsetPanel(id = "conditions_tabs", type = "tabs",
                                                   cond_panel(
                                                     overline = "Cardiovascular Disease",
                                                     title_plain = "PCOS & ", title_pink = "Cardiovascular Disease",
                                                     paragraphs = c(
                                                       "Beyond reproductive dysfunction, PCOS significantly increases the risk of myocardial infarction, ischemic heart disease, and stroke. Endothelial dysfunction arises due to elevated homocysteine, reduced superoxide dismutase activity, and higher C-reactive protein.",
                                                       "From 1990 to 2019, the CVD burden in PCOS patients grew from <strong>1.02 to 3.2 million cases</strong> globally. CVD accounts for approximately 35% of female mortality. PCOS patients are 1.51-1.37x more prone to CVD risk than non-PCOS women aged 10-54."),
                                                     chips = c("Hyperandrogenism", "Hyperinsulinemia", "Dyslipidemia", "Menstrual Irregularities", "Metabolic Syndrome"),
                                                     highlight = "<strong>Key pathways:</strong> Hyperandrogenism and hyperinsulinemia collectively drive cardiometabolic dysfunction primarily through adverse effects on lipid profiles and the development of metabolic syndrome.",
                                                     table_data = data.frame(
                                                       Condition = c("Overall CVD", "Myocardial Infarction", "Ischemic Heart Disease", "Stroke"),
                                                       `Odds Ratio` = c("1.66", "2.57", "2.77", "1.96"),
                                                       `95% CI` = c("1.32-2.08", "1.37-4.82", "2.12-3.61", "1.56-2.47"),
                                                       check.names = FALSE),
                                                     prevention = list(title = "Monitoring & ", title_pink = "Prevention",
                                                                       items = c("Regular blood pressure monitoring at every clinical visit",
                                                                                 "Annual lipid panel to track cholesterol and triglyceride levels",
                                                                                 "Lifestyle interventions including aerobic exercise and heart-healthy diet",
                                                                                 "Screening for metabolic syndrome components"))
                                                   ),
                                                   cond_panel(
                                                     overline = "Insulin Resistance",
                                                     title_plain = "PCOS & ", title_pink = "Insulin Resistance",
                                                     paragraphs = c(
                                                       "In PCOS, persistently elevated gonadotropin-releasing hormone increases luteinizing hormone while reducing follicle-stimulating hormone. These changes drive excess androgen production and ovarian dysfunction.",
                                                       "A phenomenon called the <strong>'ovarian paradox'</strong> occurs: while peripheral tissues resist insulin, ovarian theca cells remain responsive, allowing insulin to stimulate testosterone biosynthesis and worsen hyperandrogenism.",
                                                       "Studies confirm that <strong>35-80% of women with PCOS</strong> experience insulin resistance. Gene variants rs2059807 and rs1799817 are strongly linked to insulin resistance in PCOS patients."),
                                                     chips = c("Hyperinsulinemia", "Ovarian Paradox", "Hyperandrogenism", "Type 2 Diabetes Risk", "Cardiovascular Risk", "Adverse Pregnancy Outcomes"),
                                                     highlight = "<strong>Obese vs. Lean:</strong> Approximately <strong>80%</strong> of obese women with PCOS exhibit insulin resistance, compared to <strong>30-40%</strong> of lean women. Asian women demonstrate a higher predisposition than their European counterparts.",
                                                     prevention = list(title = "Management ", title_pink = "Strategies",
                                                                       items = c("Blood glucose testing and insulin sensitivity assessments",
                                                                                 "Dietary modifications: low glycaemic index foods",
                                                                                 "Regular physical activity to improve peripheral insulin sensitivity",
                                                                                 "Metformin therapy where clinically indicated",
                                                                                 "Weight management to reduce insulin resistance burden"))
                                                   ),
                                                   cond_panel(
                                                     overline = "Diabetes",
                                                     title_plain = "PCOS & ", title_pink = "Diabetes",
                                                     paragraphs = c(
                                                       "Gestational diabetes mellitus (GDM) and PCOS both increase the risk of Type 2 diabetes through shared pathophysiological mechanisms, primarily beta-cell dysfunction characterised by decreased insulin secretion.",
                                                       "PCOS significantly reduces insulin sensitivity, leading to higher prevalence of glucose intolerance and diabetes. Elevated insulin, decreased growth hormone, and increased ghrelin secretion all raise diabetes risk."),
                                                     chips = c("Type 2 Diabetes", "Gestational Diabetes", "Beta-cell Dysfunction", "Glucose Intolerance", "Hyperinsulinemia"),
                                                     highlight = "<strong>Quantified Risk:</strong> PCOS patients face a significantly higher risk of diabetes progression than non-PCOS women (<strong>OR = 2.87</strong>, 95% CI 1.44-5.72). Careful monitoring of glucose metabolism is especially important during pregnancy.",
                                                     prevention = list(title = "Screening & ", title_pink = "Monitoring",
                                                                       items = c("Regular fasting glucose and HbA1c testing",
                                                                                 "Oral glucose tolerance test (OGTT) every 1-3 years",
                                                                                 "Enhanced monitoring during pregnancy for gestational diabetes",
                                                                                 "Early lifestyle interventions to delay Type 2 diabetes onset"))
                                                   ),
                                                   cond_panel(
                                                     overline = "Hypertension",
                                                     title_plain = "PCOS & ", title_pink = "Hypertension",
                                                     paragraphs = c(
                                                       "The pathophysiology of hypertension in PCOS involves multiple complex mechanisms: activation of the renin-angiotensin system, insulin resistance with compensatory hyperinsulinemia, hyperandrogenism, sympathetic nervous system activation, and insufficient nitric oxide release.",
                                                       "During pregnancy, hyperinsulinemia reduces prostaglandin production, increasing peripheral vascular resistance and elevating blood pressure. A Northern California study (2013-2019) found a <strong>7.2% higher prevalence</strong> of hypertension in PCOS adolescents aged 13-17."),
                                                     chips = c("Renin-Angiotensin Activation", "Hyperinsulinemia", "Hyperandrogenism", "Endothelial Dysfunction", "Vascular Resistance", "Pregnancy Complications"),
                                                     highlight = "<strong>Obesity amplifier:</strong> PCOS women with obesity face a <strong>37% higher risk</strong> of developing hypertension compared to healthy women. International PCOS guidelines recommend regular blood pressure monitoring and annual haemoglobin checks.",
                                                     prevention = list(title = "Clinical ", title_pink = "Recommendations",
                                                                       items = c("Annual blood pressure and haemoglobin monitoring per international PCOS guidelines",
                                                                                 "Weight management to reduce obesity-related hypertension risk",
                                                                                 "Dietary sodium restriction",
                                                                                 "Regular cardiovascular exercise",
                                                                                 "Pharmacological intervention when lifestyle measures are insufficient"))
                                                   ),
                                                   cond_panel(
                                                     overline = "Dyslipidemia",
                                                     title_plain = "PCOS & ", title_pink = "Dyslipidemia",
                                                     paragraphs = c(
                                                       "Dyslipidemia - characterised by high total cholesterol, elevated LDL, high triglycerides, and reduced HDL - affects <strong>70% of women with PCOS</strong>. Research has established a clear correlation between androgen levels and elevated total cholesterol.",
                                                       "A study of 286 participants aged 18-35 found that 24.13% had abnormal lipid profiles. Women aged 18-27 with a BMI of 21-23 kg/m2 were most susceptible."),
                                                     chips = c("High LDL", "Low HDL", "Elevated Triglycerides", "High Total Cholesterol", "Atherosclerosis Risk"),
                                                     highlight = "<strong>Non-obese PCOS patients</strong> also show elevated serum triglyceride/HDL ratios, indicating that dyslipidemia risk in PCOS is <strong>independent of BMI</strong>.",
                                                     table_data = data.frame(
                                                       Biomarker = c("Total Cholesterol", "LDL", "Triglycerides", "HDL"),
                                                       Direction = c("Elevated", "Elevated", "Elevated", "Reduced"),
                                                       `CVD Impact` = c("Atherosclerosis", "Plaque formation", "Metabolic syndrome", "Reduced cardioprotection"),
                                                       check.names = FALSE),
                                                     prevention = list(title = "Lipid ", title_pink = "Management",
                                                                       items = c("Annual fasting lipid panel for all PCOS patients",
                                                                                 "Dietary interventions: reduce saturated fats, increase fibre and omega-3 intake",
                                                                                 "Physical activity to raise HDL and lower triglycerides",
                                                                                 "Statin therapy where clinically indicated for elevated LDL"))
                                                   ),
                                                   cond_panel(
                                                     overline = "Liver Disease (MAFLD)",
                                                     title_plain = "PCOS & ", title_pink = "Liver Disease",
                                                     paragraphs = c(
                                                       "Metabolic-Associated Fatty Liver Disease (MAFLD), previously called NAFLD, encompasses conditions from simple hepatic steatosis to advanced liver damage. The first significant association with PCOS was established in 2005.",
                                                       "MAFLD affects up to <strong>39% of lean PCOS patients</strong>. Hyperandrogenemia (HA) - present in approximately 80% of patients - acts as a major endocrine disruptor, increasing hepatic steatosis risk through upregulation of key proteins including Fas, SCD, ACC1, ACC2, and SREBP1."),
                                                     chips = c("Hepatic Steatosis", "Insulin Resistance", "Hyperandrogenemia", "Central Obesity", "TG Dysregulation", "Liver Fibrosis Risk"),
                                                     highlight = "<strong>Lean patients at risk:</strong> MAFLD in PCOS is not limited to obese women - up to 39% of lean PCOS patients are affected, highlighting the independent role of hormonal dysregulation.",
                                                     prevention = list(title = "Liver Health ", title_pink = "Monitoring",
                                                                       items = c("Liver function tests and hepatic ultrasound in at-risk PCOS patients",
                                                                                 "Minimise alcohol intake and maintain a liver-protective diet",
                                                                                 "Treatment of insulin resistance and hyperandrogenism",
                                                                                 "Consider liver screening even in lean, young PCOS patients"))
                                                   ),
                                                   cond_panel(
                                                     overline = "Mental Health",
                                                     title_plain = "PCOS & ", title_pink = "Mental Health",
                                                     paragraphs = c(
                                                       "PCOS is strongly associated with elevated rates of depression and anxiety, driven by hormonal imbalances, physical symptoms such as hirsutism and weight gain, chronic illness burden, and fertility concerns.",
                                                       "The incidence of mental health disorders is significantly higher in PCOS patients. In Pakistan, depression and anxiety rates among PCOS patients are documented at <strong>56.9%</strong> and <strong>61.8%</strong> respectively - substantially higher than the global average."),
                                                     chips = c("Depression", "Anxiety", "Body Image Concerns", "Fertility Stress", "Hormonal Imbalance", "Chronic Illness Burden"),
                                                     highlight = "<strong>Mental health is often overlooked</strong> in PCOS management. The psychological burden of living with a chronic, frequently misunderstood condition contributes significantly to reduced quality of life.",
                                                     prevention = list(title = "Psychological ", title_pink = "Support",
                                                                       items = c("Routine screening for depression and anxiety in all PCOS patients",
                                                                                 "Referral to mental health professionals when indicated",
                                                                                 "Cognitive behavioural therapy (CBT) has demonstrated effectiveness",
                                                                                 "Peer support groups and patient education on PCOS",
                                                                                 "Holistic treatment that addresses both physical and psychological symptoms"))
                                                   )
                                       )
                                   )
                               )
                      ),
                      
                      tabPanel("Endometrial Cancer",
                               tags$head(tags$style(HTML("
        .map-page { max-width: 1100px; margin: 30px auto 60px; padding: 0 24px; }
        .map-label { font-size: 0.75rem; font-weight: 700; letter-spacing: 0.15em; text-transform: uppercase; color: #e63985; margin-bottom: 10px; }
        .map-heading { font-family: 'Playfair Display', serif; font-size: 2rem; font-weight: 700; color: #1a1a2e; margin-bottom: 10px; line-height: 1.25; }
        .map-heading span { color: #e63985; }
        .map-intro { font-size: 1rem; color: #555; line-height: 1.8; margin-bottom: 28px; max-width: 780px; }
        .map-card { background: #ffffff; border-radius: 20px; box-shadow: 0 12px 40px rgba(230,57,133,0.10), 0 2px 10px rgba(0,0,0,0.05); overflow: hidden; border-top: 5px solid #e63985; padding: 8px; }
        .map-source { font-size: 0.78rem; color: #aaa; margin-top: 12px; text-align: right; }
      "))),
                               div(class = "map-page",
                                   div(class = "map-label", "Epidemiology"),
                                   div(class = "map-heading", "US Uterine Corpus Cancer ", tags$span("Incidence by State")),
                                   p(class = "map-intro", "This map shows state-level uterine corpus cancer incidence rates per 100,000 women. Hover over any state to view its incidence rate."),
                                   div(class = "map-card", leafletOutput("stateMap", height = "320px")),
                                   p(class = "map-source", style = "font-size: 1.5rem; color: #e36895",
                                     tags$strong("Source: "),
                                     tags$a(href = "https://cancerstatisticscenter.cancer.org/types/uterine-corpus", target = "_blank",
                                            tags$strong("Uterine Corpus cancer statistics")))
                               ),
                               div(class = "map-page",
                                   div(class = "map-label", "Epidemiology"),
                                   div(class = "map-heading", "US Uterine Corpus Cancer ", tags$span("Mortality Rate by State")),
                                   p(class = "map-intro", "This map shows state-level uterine corpus cancer mortality rates per 100,000 women."),
                                   div(class = "map-card", leafletOutput("stateMapMortality", height = "320px")),
                                   p(class = "map-source", style = "font-size: 1.5rem; color: #e36895",
                                     tags$strong("Source: "),
                                     tags$a(href = "https://cancerstatisticscenter.cancer.org/types/uterine-corpus", target = "_blank",
                                            tags$strong("Uterine Corpus cancer statistics")))
                               ),
                               div(class = "map-page",
                                   div(class = "map-label", "Epidemiology"),
                                   div(class = "map-heading", "US Uterine Corpus Cancer ", tags$span("Death Estimates by State")),
                                   p(class = "map-intro", "This map shows state-level uterine corpus cancer death estimates."),
                                   div(class = "map-card", leafletOutput("stateMapDeath", height = "320px")),
                                   p(class = "map-source", style = "font-size: 1.5rem; color: #e36895",
                                     tags$strong("Source: "),
                                     tags$a(href = "https://cancerstatisticscenter.cancer.org/types/uterine-corpus", target = "_blank",
                                            tags$strong("Uterine Corpus cancer statistics")))
                               ),
                               div(class = "map-page",
                                   div(class = "map-label", "Epidemiology"),
                                   div(class = "map-heading", "US Uterine Corpus Cancer ", tags$span("New Cases by State")),
                                   p(class = "map-intro", "This map shows state-level uterine corpus cancer new cases per 100,000 women."),
                                   div(class = "map-card", leafletOutput("stateMapNew", height = "320px")),
                                   p(class = "map-source", style = "font-size: 1.5rem; color: #e36895",
                                     tags$strong("Source: "),
                                     tags$a(href = "https://cancerstatisticscenter.cancer.org/types/uterine-corpus", target = "_blank",
                                            tags$strong("Uterine Corpus cancer statistics")))
                               )
                      ),
                      tabPanel("CVD & Cancer Data",
                               div(class = "map-page",
                                   div(class = "map-label", "Data Exploration"),
                                   div(class = "map-heading",
                                       "CVD Mortality ", tags$span("& Uterine Cancer Overlap"),
                                       style = "font-size: 3.0rem;"),
                                   p(class = "map-intro", style = "font-size: 1.5rem;",
                                     "This scatter plot shows the relationship between state-level CVD mortality
       and uterine corpus cancer mortality rates (2019-2023). Hover over points
       to see state names."),
                                   div(class = "map-card", plotlyOutput("cvd_uc_scatter", height = "500px")),
                                   p(class = "map-source", style = "font-size: 1.5rem; color: #e36895",
                                     tags$strong("Source: "), "CVD & Uterine Corpus Mortality Data 2019-2023"),
                                   
                                   div(style = "height: 30px;"),
                                   
                                   div(class = "map-heading",
                                       "Heart Disease Mortality ", tags$span("by Race & Sex"),
                                       style = "font-size: 3.0rem; margin-top: 20px;"),
                                   p(class = "map-intro", style = "font-size: 1.5rem;",
                                     "Distribution of heart disease mortality rates among US adults (35+)
       stratified by race/ethnicity and sex (2019-2021)."),
                                   div(class = "map-card", plotOutput("cvd_race_box", height = "500px")),
                                   p(class = "map-source", style = "font-size: 1.5rem; color: #e36895",
                                     tags$strong("Source: "),
                                     "Heart Disease Mortality Data Among US Adults 35+, 2019-2021"),
                                   
                                   div(style = "height: 30px;"),
                                   
                                   div(class = "map-card", style = "padding: 32px 36px;",
                                       div(style = "font-size: 1.5rem; font-weight: 700; letter-spacing: 0.15em;
                   text-transform: uppercase; color: #e63985; margin-bottom: 8px;",
                                           "Analysis"),
                                       div(style = "font-family: 'Playfair Display', serif; font-size: 3.0rem;
                   font-weight: 700; color: #1a1a2e; margin-bottom: 20px;
                   padding-bottom: 12px; border-bottom: 2px solid #fce8f1;",
                                           "CVD & Endometrial Cancer — ", tags$span("Correlation Results",
                                                                                    style = "color:#e63985; font-size:2.0rem;")),
                                       div(style = "font-size: 2.0rem; color: #444; line-height: 1.85;",
                                           verbatimTextOutput("cvd_uc_corr"))
                                   )
                               )
                      )
                      
           ), # end navbarMenu "Risks and Comorbidities"
           
           # ── 7. ABOUT US ───────────────────────────────────────────────────────────
           tabPanel("About Us",
                    tags$head(tags$style(HTML("
      .team-section { max-width: 1200px; margin: 50px auto 80px; padding: 0 24px; }
      .team-hero { width: 100%; margin-bottom: 60px; padding: 80px 20px 60px; text-align: center; background: #FADADD; border-radius: 24px; box-shadow: 0 12px 40px rgba(0,0,0,0.06); }
      .member-card { background: #ffffff; border-radius: 24px; padding: 48px 52px; box-shadow: 0 20px 60px rgba(230,57,133,0.12), 0 4px 16px rgba(0,0,0,0.06); border-top: 6px solid #e63985; margin-bottom: 48px; display: flex; gap: 52px; align-items: flex-start; flex-wrap: wrap; }
      .member-photo { width: 280px; height: 340px; object-fit: cover; border-radius: 16px; flex-shrink: 0; }
      .member-info { flex: 1; min-width: 260px; }
      .member-name { font-family: 'Playfair Display', serif; font-size: 3rem; font-weight: 700; color: #1a1a2e; margin-bottom: 6px; }
      .member-detail { font-size: 2rem; color: #444; line-height: 1.8; margin-bottom: 4px; }
      .member-detail span { font-style: italic; color: #888; margin-right: 6px; }
      .member-divider { border: none; border-top: 2px solid #f7c5de; margin: 20px 0; }
      .member-question { font-family: 'Playfair Display', serif; font-size: 1.7rem; font-weight: 700; color: #e63985; margin-bottom: 10px; }
      .member-answer { font-size: 1.5rem; color: #555; line-height: 1.85; }
      @media (max-width: 700px) { .member-card { flex-direction: column; padding: 32px 24px; } .member-photo { width: 100%; height: 300px; } }
    "))),
                    div(class = "team-section",
                        div(class = "team-hero",
                            div(class = "hero-title", "Our Team"),
                            div(class = "hero-subtitle", "The minds behind Health is Wealth")),
                        div(class = "about-label", "Meet The Team"),
                        div(class = "about-heading", "The people ", tags$span("behind the project")),
                        div(class = "member-card",
                            tags$img(src = "zanita.png", class = "member-photo", alt = "Zanita"),
                            div(class = "member-info",
                                div(class = "member-name", "Zanita Akinkugbe '27"),
                                div(class = "member-detail", tags$span("Hometown:"), "Lagos, Nigeria"),
                                div(class = "member-detail", tags$span("Majors/Minors:"), "Neuroscience Major / Education Policy, and Poverty & Human Capability Studies Minors"),
                                tags$hr(class = "member-divider"),
                                div(class = "member-question", "What do you like most about this project?"),
                                div(class = "member-answer", "As someone who has been diagnosed with PCOS herself, this project was particularly meaningful to me. PCOS is hard to diagnose, it's even harder when there's essentially no information about it. I am glad our project can shed light on the disease and hopefully help people understand better.")
                            )
                        ),
                        div(class = "member-card",
                            tags$img(src = "martha.png", class = "member-photo", alt = "Martha"),
                            div(class = "member-info",
                                div(class = "member-name", "Martha Afoakwa '27"),
                                div(class = "member-detail", tags$span("Hometown:"), "Reston, Virginia"),
                                div(class = "member-detail", tags$span("Majors/Minors:"), "Biology Major / Philosophy and Poverty & Human Capability Minors"),
                                tags$hr(class = "member-divider"),
                                div(class = "member-question", "What do you like most about this project?"),
                                div(class = "member-answer", "I am excited about our project in Polycystic Ovary Syndrome (PCOS) because I believe there is a significant lack of awareness and understanding surrounding this condition. Many people do not fully recognize its symptoms, long-term health effects, or how common it is. More broadly, women’s health has historically been underrepresented and overlooked in both research and public conversation. This gap in knowledge leads to delayed diagnoses and limited support for those affected. Our project hopes to help increase awareness, encourage better education, and contribute to more informed and supportive discussions around women’s health")
                            )
                        ),
                        div(class = "member-card",
                            tags$img(src = "fatma.png", class = "member-photo", alt = "Fatma"),
                            div(class = "member-info",
                                div(class = "member-name", "Fatma Nayer '27"),
                                div(class = "member-detail", tags$span("Hometown:"), "Patna, India"),
                                div(class = "member-detail", tags$span("Majors/Minors:"), "Biology Major / Creative Writing Minor"),
                                tags$hr(class = "member-divider"),
                                div(class = "member-question", "What do you like most about this project?"),
                                div(class = "member-answer", "Women's health has always been at the center of my research interests. Hormonal disorders are both widespread and significantly underdiagnosed, often leaving many individuals without the care and treatment they need.")
                            )
                        )
                    )
           ),
           
           # ── 8. REFERENCES ─────────────────────────────────────────────────────────
           tabPanel("References",
                    mainPanel(width = 12,
                              div(class = "tx-page",
                                  div(class = "tx-page-label", "Sources & Citations"),
                                  div(class = "tx-page-heading", "References"),
                                  p(class = "tx-page-intro",
                                    "The following sources were used in the development of this application, including clinical literature, public health resources, and data repositories."),
                                  div(class = "tx-card",
                                      div(class = "tx-card-header",
                                          div(class = "tx-toggle-left",
                                              div(class = "tx-icon tx-icon-purple", "\U0001F4DA"),
                                              div(p(class = "tx-card-subtitle", "Academic & Clinical Sources"),
                                                  h3(class = "tx-card-title", "Peer-Reviewed Literature")))),
                                      div(class = "tx-card-body",
                                          tags$ol(
                                            tags$li(style = "margin-bottom:14px; font-size:1.5rem; color:#444; line-height:1.75;",
                                                    "Genetic Basis of Polycystic Ovary Syndrome (PCOS): Current Perspectives. ", tags$em("PubMed Central. "),
                                                    tags$a(href = "https://pmc.ncbi.nlm.nih.gov/articles/PMC7959048/", target = "_blank", "View article", style = "color:#e63985;")),
                                            tags$li(style = "margin-bottom:14px; font-size:1.5rem; color:#444; line-height:1.75;",
                                                    "Naeem, I., et al. (2025). Polycystic ovarian syndrome a risk factor for non-communicable diseases. ", tags$em("Journal of ovarian research, 18(1), 219. "),
                                                    tags$a(href = "https://doi.org/10.1186/s13048-025-01741-z", target = "_blank", "View article", style = "color:#e63985;")),
                                            tags$li(style = "margin-bottom:14px; font-size:1.5rem; color:#444; line-height:1.75;",
                                                    "Johnson, J. E., et al. (2023). Risk of endometrial cancer in patients with PCOS: A meta-analysis. ", tags$em("Oncology letters, 25(4), 168. "),
                                                    tags$a(href = "https://doi.org/10.3892/ol.2023.13754", target = "_blank", "View article", style = "color:#e63985;"))
                                          )
                                      )
                                  ),
                                  div(class = "tx-card",
                                      div(class = "tx-card-header",
                                          div(class = "tx-toggle-left",
                                              div(class = "tx-icon tx-icon-pink", "\U0001F3E5"),
                                              div(p(class = "tx-card-subtitle", "Health Organisations & Clinics"),
                                                  h3(class = "tx-card-title", "Medical & Public Health Sources")))),
                                      div(class = "tx-card-body",
                                          tags$ol(start = "4",
                                                  tags$li(style = "margin-bottom:14px; font-size:1.5rem; color:#444; line-height:1.75;",
                                                          "Fact Sheets. Office on Women's Health, U.S. Department of Health & Human Services. ",
                                                          tags$a(href = "https://womenshealth.gov/patient-materials/resource/fact-sheets", target = "_blank", "View source", style = "color:#e63985;")),
                                                  tags$li(style = "margin-bottom:14px; font-size:1.5rem; color:#444; line-height:1.75;",
                                                          "What Is PCOS? WebMD. ",
                                                          tags$a(href = "https://www.webmd.com/women/what-is-pcos", target = "_blank", "View source", style = "color:#e63985;")),
                                                  tags$li(style = "margin-bottom:14px; font-size:1.5rem; color:#444; line-height:1.75;",
                                                          "PCOS Prediction Dataset (Top 75 Countries). Kaggle. ",
                                                          tags$a(href = "https://www.kaggle.com/datasets/ankushpanday1/pcos-prediction-datasettop-75-countries", target = "_blank", "View source", style = "color:#e63985;"))
                                          ),
                                          div(class = "tx-note",
                                              tags$strong("Note: "), "All references were accessed during the development of this application. URLs were correct at time of access.")
                                      )
                                  )
                              )
                    )
           )
           
) 