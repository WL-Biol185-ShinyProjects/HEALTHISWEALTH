library(shiny)
library(bslib)
library(leaflet)

navbarPage("Health is Wealth",
  tabPanel("About",
           tags$head(
             tags$style(HTML("
        @import url('https://fonts.googleapis.com/css2?family=Playfair+Display:wght@700;900&family=Source+Sans+3:wght@400;600&display=swap');

        body { font-family: 'Source Sans 3', sans-serif; }

        .about-section {
          max-width: 1100px;
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
          font-size: 0.75rem; font-weight: 700;
          letter-spacing: 0.15em; text-transform: uppercase;
          color: #e63985; margin-bottom: 12px;
        }
        .about-heading {
          font-family: 'Playfair Display', serif;
          font-size: 2rem; font-weight: 700;
          color: #1a1a2e; margin-bottom: 24px; line-height: 1.25;
        }
        .about-heading span { color: #e63985; }
        .about-text { font-size: 1.05rem; line-height: 1.85; color: #444; margin-bottom: 18px; }
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
          max-width: 1100px;
          margin: 30px auto 60px;
          padding: 0 24px;
          font-family: 'Source Sans 3', sans-serif;
        }
        .map-label {
          font-size: 0.75rem; font-weight: 700;
          letter-spacing: 0.15em; text-transform: uppercase;
          color: #e63985; margin-bottom: 10px;
        }
        .map-heading {
          font-family: 'Playfair Display', serif;
          font-size: 2rem; font-weight: 700;
          color: #1a1a2e; margin-bottom: 10px; line-height: 1.25;
        }
        .map-heading span { color: #e63985; }
        .map-intro {
          font-size: 1rem; color: #555; line-height: 1.8;
          margin-bottom: 28px; max-width: 780px;
        }
        .map-card {
          background: #ffffff;
          border-radius: 20px;
          box-shadow: 0 12px 40px rgba(230,57,133,0.10), 0 2px 10px rgba(0,0,0,0.05);
          overflow: hidden;
          border-top: 5px solid #e63985;
          padding: 8px;
        }
        .map-card .leaflet-container {
          border-radius: 14px;
        }
        .map-source {
          font-size: 0.78rem; color: #aaa;
          margin-top: 12px; text-align: right;
        }
      "))
    
           ),
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
        ),
  # ── 4. MAP 1990 ──
  
  div(class = "map-page",
      div(class = "map-label", "Epidemiology"),
      div(class = "map-heading", "Global PCOS ", tags$span("Incidence (1990)")),
      p(class = "map-intro",
        "This map shows country-level PCOS incidence rates per 100,000 women of reproductive age in 1990. Hover over any country to see its specific values."
      ),
      div(class = "map-card",
          leafletOutput("pcosMap1990", height = "520px")   # <-- pcosMap1990
      ),
      p(class = "map-source", "Source: PCOS Dataset · Values per 100,000 women aged 15–49")
  ),
  # ── 3. MAP 2021 ──
 
           div(class = "map-page",
               div(class = "map-label", "Epidemiology"),
               div(class = "map-heading", "Global PCOS ", tags$span("Incidence (2021)")),
               p(class = "map-intro",
                 "This map shows country-level PCOS incidence rates per 100,000 women of reproductive age in 2021. Hover over any country to see its specific values."
               ),
               div(class = "map-card",
                   leafletOutput("pcosMap", height = "520px")   # <-- pcosMap
               ),
               p(class = "map-source", "Source: PCOS Dataset · Values per 100,000 women aged 15–49")
           ),

  
  # ── 2. TYPES OF PCOS ──────────────────────────────────────────────────────
  navbarMenu("Types of PCOS",
             tabPanel("Insulin Resistant PCOS"),
             tabPanel("Post-pill PCOS"),
             tabPanel("Adrenal PCOS"),
             tabPanel("Inflammatory PCOS")
  ),
  # ── 4. TREATMENT ──────────────────────────────────────────────────────────
  tabPanel("Treatment",
           tags$head(
             tags$style(HTML("
        @import url('https://fonts.googleapis.com/css2?family=Playfair+Display:wght@700;900&family=Source+Sans+3:wght@400;600&display=swap');

        .tx-page {
          max-width: 900px; margin: 36px auto 72px;
          padding: 0 24px; font-family: 'Source Sans 3', sans-serif;
        }
        .tx-page-label {
          font-size: 0.75rem; font-weight: 700;
          letter-spacing: 0.15em; text-transform: uppercase;
          color: #e63985; margin-bottom: 10px;
        }
        .tx-page-heading {
          font-family: 'Playfair Display', serif;
          font-size: 2rem; font-weight: 700;
          color: #1a1a2e; margin-bottom: 12px; line-height: 1.25;
        }
        .tx-page-heading span { color: #e63985; }
        .tx-page-intro {
          font-size: 1.05rem; color: #555; line-height: 1.8;
          margin-bottom: 40px; max-width: 720px;
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
          display: flex; align-items: center; gap: 18px;
          padding: 28px 32px 22px; border-bottom: 1px solid #fce8f1;
        }
        .tx-icon {
          width: 52px; height: 52px; border-radius: 14px;
          display: flex; align-items: center; justify-content: center;
          font-size: 1.6rem; flex-shrink: 0;
        }
        .tx-icon-green  { background: linear-gradient(135deg, #e8f8f0, #d0f0e0); }
        .tx-icon-pink   { background: linear-gradient(135deg, #fff0f7, #fcd8eb); }
        .tx-icon-purple { background: linear-gradient(135deg, #f3f0ff, #e2d9fb); }
        .tx-card-title {
          font-family: 'Playfair Display', serif;
          font-size: 1.35rem; font-weight: 700; color: #1a1a2e; margin: 0 0 4px;
        }
        .tx-card-subtitle {
          font-size: 0.82rem; font-weight: 600;
          letter-spacing: 0.08em; text-transform: uppercase;
          color: #e63985; margin: 0;
        }
        .tx-card-body { padding: 24px 32px 28px; }
        .tx-desc { font-size: 1rem; color: #444; line-height: 1.8; margin-bottom: 20px; }
        .tx-pills { display: flex; flex-wrap: wrap; gap: 8px; margin-bottom: 20px; }
        .tx-pill {
          font-size: 0.82rem; font-weight: 600;
          padding: 5px 14px; border-radius: 999px; border: 1.5px solid;
        }
        .pill-green  { color: #1a7a4a; border-color: #7ecfa0; background: #edfbf2; }
        .pill-pink   { color: #c0185f; border-color: #f0a0c8; background: #fff0f7; }
        .pill-purple { color: #5b3bbf; border-color: #b8a8f0; background: #f3f0ff; }
        .tx-note {
          background: linear-gradient(135deg, #fff8fb, #fff4f0);
          border-left: 4px solid #e63985; border-radius: 10px;
          padding: 14px 18px; font-size: 0.92rem; color: #555; line-height: 1.7;
        }
        .tx-note strong { color: #e63985; }
        .tx-badge-row { display: flex; align-items: center; gap: 10px; margin-bottom: 16px; }
        .tx-badge {
          font-size: 0.78rem; font-weight: 700; padding: 4px 12px;
          border-radius: 999px; text-transform: uppercase; letter-spacing: 0.06em;
        }
        .badge-first-line  { background: #e8f8f0; color: #1a7a4a; }
        .badge-surgical    { background: #fce8f1; color: #b01e5c; }
        .badge-specialized { background: #ede8ff; color: #4b2eb5; }
        @media (max-width: 600px) {
          .tx-card-header { padding: 20px 20px 16px; flex-direction: column; align-items: flex-start; }
          .tx-card-body   { padding: 16px 20px 22px; }
        }
      "))
           ),
           div(class = "tx-page",
               div(class = "tx-page-label", "Managing PCOS"),
               div(class = "tx-page-heading", "Treatment ", tags$span("Options")),
               p(class = "tx-page-intro",
                 "PCOS management is highly individual. Treatment goals vary from regulating cycles and managing symptoms to supporting fertility. Below are three key approaches used by clinicians worldwide."
               ),
               
               # Card 1: Dietary Therapy
               div(class = "tx-card",
                   div(class = "tx-card-header",
                       div(class = "tx-icon tx-icon-green", "🥗"),
                       div(
                         p(class = "tx-card-subtitle", "Lifestyle Intervention"),
                         h3(class = "tx-card-title", "Dietary Therapy")
                       )
                   ),
                   div(class = "tx-card-body",
                       div(class = "tx-badge-row", span(class = "tx-badge badge-first-line", "First-line treatment")),
                       p(class = "tx-desc",
                         "Dietary therapy is typically the first recommended approach for managing PCOS, particularly for those with insulin resistance or elevated BMI. A low-glycemic, anti-inflammatory diet can reduce androgen levels, improve menstrual regularity, and support metabolic health — often without medication. Obesity has been reported in 30% of PCOS patients. However, dieting and exercise alone does not always show long-term results; bariatric surgery has been introduced in cases where conservative approaches fall short."
                       ),
                       p(tags$strong("Key dietary approaches:"), style = "font-size:0.92rem;color:#333;margin-bottom:8px;"),
                       div(class = "tx-pills",
                           span(class = "tx-pill pill-green", "Low-GI diet"),
                           span(class = "tx-pill pill-green", "Anti-inflammatory foods"),
                           span(class = "tx-pill pill-green", "Reduced refined carbs"),
                           span(class = "tx-pill pill-green", "High fiber intake"),
                           span(class = "tx-pill pill-green", "Omega-3 rich foods"),
                           span(class = "tx-pill pill-green", "Caloric balance")
                       ),
                       div(class = "tx-note",
                           tags$strong("Important: "), "A 5–10% reduction in body weight can restore ovulation and improve hormonal balance in women with PCOS. Diet changes are most effective when combined with regular physical activity."
                       )
                   )
               ),
               
               # Card 2: LOD
               div(class = "tx-card",
                   div(class = "tx-card-header",
                       div(class = "tx-icon tx-icon-pink", "🔬"),
                       div(
                         p(class = "tx-card-subtitle", "Surgical Procedure"),
                         h3(class = "tx-card-title", "Laparoscopic Ovarian Drilling (LOD)")
                       )
                   ),
                   div(class = "tx-card-body",
                       div(class = "tx-badge-row", span(class = "tx-badge badge-surgical", "Surgical option")),
                       p(class = "tx-desc",
                         "LOD is a minimally invasive surgical procedure performed under general anesthesia. Small holes are made in the ovarian tissue using heat or a laser to destroy androgen-producing tissue. LOD was introduced in 1984 and is successful in approximately 84% of patients, improving insulin resistance and increasing SHBG levels. Lower miscarriage rates have also been reported with LOD."
                       ),
                       p(tags$strong("Typical candidates & outcomes:"), style = "font-size:0.92rem;color:#333;margin-bottom:8px;"),
                       div(class = "tx-pills",
                           span(class = "tx-pill pill-pink", "Clomiphene-resistant PCOS"),
                           span(class = "tx-pill pill-pink", "Anovulatory infertility"),
                           span(class = "tx-pill pill-pink", "Elevated LH levels"),
                           span(class = "tx-pill pill-pink", "No multiple pregnancy risk"),
                           span(class = "tx-pill pill-pink", "Laparoscopic access")
                       ),
                       div(class = "tx-note",
                           tags$strong("Note: "), "LOD does not treat all PCOS symptoms — it primarily targets ovulation. Effects may be temporary. It is generally considered after first-line drug therapies have failed."
                       )
                   )
               ),
               
               # Card 3: ART
               div(class = "tx-card",
                   div(class = "tx-card-header",
                       div(class = "tx-icon tx-icon-purple", "🧬"),
                       div(
                         p(class = "tx-card-subtitle", "Fertility Treatment"),
                         h3(class = "tx-card-title", "Assisted Reproductive Technology (ART)")
                       )
                   ),
                   div(class = "tx-card-body",
                       div(class = "tx-badge-row", span(class = "tx-badge badge-specialized", "Specialized care")),
                       p(class = "tx-desc",
                         "ART encompasses a range of fertility treatments that handle eggs, sperm, or embryos outside the body. For women with PCOS struggling to conceive, IVF is the most common ART option. PCOS patients often respond strongly to ovarian stimulation, requiring careful monitoring to prevent ovarian hyperstimulation syndrome (OHSS)."
                       ),
                       p(tags$strong("Common ART approaches for PCOS:"), style = "font-size:0.92rem;color:#333;margin-bottom:8px;"),
                       div(class = "tx-pills",
                           span(class = "tx-pill pill-purple", "IVF"),
                           span(class = "tx-pill pill-purple", "Ovulation induction"),
                           span(class = "tx-pill pill-purple", "Embryo freezing"),
                           span(class = "tx-pill pill-purple", "Egg freezing"),
                           span(class = "tx-pill pill-purple", "ICSI"),
                           span(class = "tx-pill pill-purple", "Frozen embryo transfer")
                       ),
                       div(class = "tx-note",
                           tags$strong("OHSS Risk: "), "Women with PCOS are at higher risk for ovarian hyperstimulation during ART. Clinicians use low-dose stimulation protocols and close monitoring to minimize this risk."
                       )
                   )
               )
           )
  )
)
