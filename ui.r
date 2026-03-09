library(shiny)
library(bslib)

navbarPage("Health is Wealth",
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
  
navbarPage(
  tags$head(
    tags$link(rel = "preconnect", href = "https://fonts.googleapis.com"),
    tags$link(rel = "stylesheet", href = "https://fonts.googleapis.com/css2?family=Playfair+Display:wght@700;900&family=DM+Sans:wght@400;500;600&display=swap"),
    tags$style(HTML("
      * { margin: 0; padding: 0; box-sizing: border-box; }

      body {
        background-color: #fdf6f0;
        font-family: 'DM Sans', sans-serif;
        color: #1a1a2e;
      }

      /* ── HERO BANNER ── */
      .hero {
        background: linear-gradient(135deg, #e63985 0%, #f7a04b 50%, #f9d423 100%);
        padding: 80px 40px 70px;
        text-align: center;
        position: relative;
        overflow: hidden;
        clip-path: polygon(0 0, 100% 0, 100% 88%, 0 100%);
        padding-bottom: 110px;
      }

      .hero::before {
        content: '';
        position: absolute;
        top: -60px; left: -60px;
        width: 300px; height: 300px;
        border-radius: 50%;
        background: rgba(255,255,255,0.08);
      }

      .hero::after {
        content: '';
        position: absolute;
        bottom: 10px; right: -80px;
        width: 400px; height: 400px;
        border-radius: 50%;
        background: rgba(255,255,255,0.06);
      }

      .hero-title {
        font-family: 'Playfair Display', serif;
        font-size: clamp(3rem, 8vw, 6rem);
        font-weight: 900;
        color: #fff;
        letter-spacing: -1px;
        text-shadow: 3px 4px 0px rgba(0,0,0,0.15);
        line-height: 1;
        margin-bottom: 16px;
        position: relative; z-index: 1;
      }

      .hero-subtitle {
        font-family: 'DM Sans', sans-serif;
        font-size: clamp(1rem, 2.5vw, 1.35rem);
        font-weight: 500;
        color: rgba(255,255,255,0.93);
        letter-spacing: 0.04em;
        text-transform: uppercase;
        position: relative; z-index: 1;
      }

      .hero-tag {
        display: inline-block;
        background: rgba(255,255,255,0.22);
        border: 2px solid rgba(255,255,255,0.5);
        color: #fff;
        border-radius: 999px;
        padding: 6px 20px;
        font-size: 0.85rem;
        font-weight: 600;
        letter-spacing: 0.08em;
        text-transform: uppercase;
        margin-bottom: 20px;
        position: relative; z-index: 1;
      }

      /* ── ABOUT SECTION ── */
      .about-section {
        max-width: 860px;
        margin: -10px auto 60px;
        padding: 0 24px;
      }

      .about-card {
        background: #ffffff;
        border-radius: 24px;
        padding: 48px 52px;
        box-shadow: 0 20px 60px rgba(230, 57, 133, 0.12),
                    0 4px 16px rgba(0,0,0,0.06);
        border-top: 6px solid #e63985;
        position: relative;
        z-index: 2;
      }

      .about-label {
        font-size: 0.75rem;
        font-weight: 700;
        letter-spacing: 0.15em;
        text-transform: uppercase;
        color: #e63985;
        margin-bottom: 12px;
      }

      .about-heading {
        font-family: 'Playfair Display', serif;
        font-size: 2rem;
        font-weight: 700;
        color: #1a1a2e;
        margin-bottom: 24px;
        line-height: 1.25;
      }

      .about-heading span {
        color: #e63985;
      }

      .about-text {
        font-size: 1.05rem;
        line-height: 1.85;
        color: #444;
        margin-bottom: 18px;
      }

      /* ── STAT PILLS ── */
      .stat-row {
        display: flex;
        gap: 16px;
        flex-wrap: wrap;
        margin-top: 32px;
      }

      .stat-pill {
        flex: 1;
        min-width: 150px;
        background: linear-gradient(135deg, #fff0f7, #fff8f0);
        border: 2px solid #f7c5de;
        border-radius: 16px;
        padding: 20px 24px;
        text-align: center;
      }

      .stat-number {
        font-family: 'Playfair Display', serif;
        font-size: 2.2rem;
        font-weight: 900;
        color: #e63985;
        display: block;
      }

      .stat-desc {
        font-size: 0.82rem;
        font-weight: 600;
        color: #888;
        text-transform: uppercase;
        letter-spacing: 0.06em;
        margin-top: 4px;
      }

      /* ── FOOTER STRIP ── */
      .footer-strip {
        background: #1a1a2e;
        color: rgba(255,255,255,0.5);
        text-align: center;
        padding: 18px;
        font-size: 0.82rem;
        letter-spacing: 0.05em;
      }

      @media (max-width: 600px) {
        .about-card { padding: 32px 24px; }
        .hero { padding: 60px 20px 90px; }
      }
    "))
  ),
  
  # ── HERO BLOCK ──
  div(class = "hero",
      div(class = "hero-tag", "Data & Health Equity"),
      div(class = "hero-title", "Health is Wealth"),
      div(class = "hero-subtitle", "An Insight on Polycystic Ovarian Syndrome")
  ),
  
  # ── ABOUT CARD ──
  div(class = "about-section",
      div(class = "about-card",
          
          div(class = "about-label", "About This Project"),
          div(class = "about-heading",
              "Understanding ", tags$span("PCOS"), " Through Data"
          ),
          
          p(class = "about-text",
            "Polycystic Ovary Syndrome (PCOS) is one of the most common hormonal disorders affecting women of reproductive age (typically 15–49), yet it remains widely underdiagnosed and misunderstood. Despite affecting millions of women worldwide, gaps in research, delayed diagnosis, and disparities in healthcare access continue to affect outcomes — particularly for women from marginalized communities."
          ),
          
          p(class = "about-text",
            "This project explores the prevalence, risk factors, and health outcomes associated with PCOS — including metabolic complications, mental health impacts, and reproductive challenges. Using publicly available health datasets, we analyze trends by country, race, and age group to better understand disparities in diagnosis, treatment access, and long-term health outcomes."
          ),
          
          # Stat pills
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
  
  # ── FOOTER ──
  div(class = "footer-strip",
      "Health is Wealth · PCOS Awareness & Data Project"
  )
)




