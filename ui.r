library(shiny)
library(bslib)

navbarPage("Health is Wealth",
  tabPanel("About",
         
         tabPanel("About",
                  tags$head(
                    tags$style(HTML("
        .about-section {
          max-width: 860px;
          margin: 30px auto 60px;
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

        @media (max-width: 600px) {
          .about-card { padding: 32px 24px; }
        }
      "))
                  ),
                  
                    mainPanel(
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
                      )
                    )
                
         ),
         
         
),
tabPanel("Summary",
         verbatimTextOutput("summary")
)
)
<<<<<<< HEAD
  
=======
>>>>>>> 3f182b8ee478021e34dd320ab7bc72cd40343b84
