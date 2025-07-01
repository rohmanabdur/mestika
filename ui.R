ui <- fluidPage(
  # Mengaktifkan shinyjs
  useShinyjs(),
  autoWaiter(),
  tags$head(
    tags$link(rel = "preconnect", href = "https://fonts.googleapis.com"),
    tags$link(rel = "preconnect", href = "https://fonts.gstatic.com", crossorigin = TRUE),
    tags$link(
      href = "https://fonts.googleapis.com/css2?family=Montserrat:ital,wght@0,100..900;1,100..900&display=swap",
      rel = "stylesheet"
    ),
    tags$style(HTML("
      body, html {
        font-family: 'Montserrat';
        height: 100%;
        margin: 0;
        padding: 0;
      }
      .container-fluid {
        height: 100%;
        margin: 0;
        padding: 0;
      }
      
  /*Dasar*/
      body {
        background-color: #00468B;
      }
      .app-container {
        background-color: #182633;
        width: 98vw;
        height: 98vh;
        margin: 1vh auto;
        display: flex;
        flex-direction: row;
        align-items: center;
        justify-content: center;
        border-radius: 20px;
        padding: 10px;
        position: relative;
      }
      
  /* Delete Shiny Navbar */
      .navbar {
        display: none;
      }
      .tab-content {
        height: 100%;
        width: 100%;
      }
      .tab-pane {
        height: 100%;
        width: 100%;
        display: flex;
        flex-direction: row;
        align-items: center;
        justify-content: center;
      }

  /*display utama - Homepage */
      .main-display.homepage {
        background-color: white;
        width: 80%;
        height: 100%;
        border-radius: 15px;
        display: flex;
        flex-direction: column;
        align-items: center;
        justify-content: center;
        padding: 20px;
        margin-right: 10px;
      }
      .logo-img {
        max-width: 65%;
        height: auto;
        margin-bottom: 20px;
      }
      .upload-button {
        background-image: linear-gradient(to bottom, #a8ff9e, #19ae5d);
        color: white;
        padding: 15px 30px;
        border: none;
        border-radius: 8px;
        font-size: 2em;
        cursor: pointer;
        transition: background-image 0.3s ease;
      }
      .upload-button:hover {
        background-image: linear-gradient(to bottom, #228b22, #19ae5d);
      }

  /* display utama - OpenMap */
      .main-display.map-page {
        background-color: white;
        width: 100%;
        height: 100%;
        border-radius: 15px;
        display: flex;
        flex-direction: column;
        align-items: flex-start;
        justify-content: flex-start;
        padding: 20px;
        margin-right: 10px;
        position: relative;
      }
      #petaIndo_openmap, #petaIndo_result { /* Menggunakan ID unik untuk peta */
        border-radius: 15px;
        width: 100%;
        height: 100%;
      }

  /*Pengaturan / Info Bar (Sisi Kanan)*/
      .info-bar-container, .setting-bar-container {
        display: flex;
        flex-direction: column;
        width: 300px;
        height: 100%;
        border-radius: 15px;
        justify-content: space-between;
      }
      .info-box-top, .setting-header {
        background-color: white;
        height: 10%;
        border-radius: 15px;
        display: flex;
        align-items: center;
        justify-content: center;
        margin-bottom: 10px;
      }
      .mestika-typography {
        max-height: 100%;
        object-fit: contain;
        padding: 0;
      }
      .info-box-bottom {
        background-color: white;
        border-radius: 15px;
        padding: 40px;
        color: black;
        font-size: 1em;
        overflow-y: auto;
        display: flex;
        flex-direction: column;
        height: 100%;
        flex-grow: 1;
      }
      .info-text {
        flex-grow: 0.8;
        text-align: justify;
        font-weight: 400;
      }
      .author-info {
        text-align: right;
        font-size: 0.8em;
        margin-top: auto;
        font-weight: 600;
      }

  /* Setting Controls (OpenMap & Result) */
      .setting-controls {
        background-color: white;
        border-radius: 15px;
        padding: 10px;
        margin-bottom: 10px;
      }
      .setting-text {
        text-align: left;
        font-weight: 600;
        margin-bottom: 5px;
      }
      #jumlah_titik, #jumlah_titik_result { /* ID unik untuk result */
        -webkit-appearance: none;
        -moz-appearance: none;
        appearance: none;
        background-color: #9df3ff;
        border-radius: 15px;
        padding: 5px;
        height: 35px;
        font-size: 1.2em;
        font-weight: 600;
        text-align: center;
        width: 100%;
        border: none;
        outline: none;
        color: #333;
      }
      #jumlah_titik:hover, #jumlah_titik_result:hover {
        background-image: linear-gradient(to bottom, #00468B, 10%, #9df3ff);
        color: black;
      }
      #jenis_sebaran, #jenis_sebaran_result { /* ID unik untuk result */
        -webkit-appearance: none;
        -moz-appearance: none;
        appearance: none;
        background-color: #9df3ff;
        border-radius: 15px;
        padding: 5px;
        height: 35px;
        font-size: 1.2em;
        font-weight: 600;
        text-align: center;
        text-align-last: center;
        width: 100%;
        border: none;
        outline: none;
        cursor: pointer;
        color: #333; /* Ubah warna default agar terlihat */
      }
      #jenis_sebaran:hover, #jenis_sebaran_result:hover {
        background-image: linear-gradient(to bottom, #00468B, 10%, #9df3ff) !important;
        color: black !important;
      }
      .selectize-input {
        background-color: #9df3ff !important;
        border: none !important;
        border-radius: 15px !important;
        padding: 5px !important;
        font-size: 1.2em !important;
        font-weight: 600 !important;
        text-align: center !important;
        cursor: pointer !important;
        height: 35px !important;
        display: flex;
        align-items: center;
        justify-content: center;
      }
      .selectize-dropdown-content .option {
        text-align: center !important;
      }
      #jenis_sebaran + .selectize-control .selectize-input::after,
      #jenis_sebaran_result + .selectize-control .selectize-input::after {
        content: !important;
        position: absolute !important;
        right: 15px !important;
        top: 50% !important;
        transform: translateY(-50%) !important;
        pointer-events: none !important;
        color: #333 !important;
        cursor: pointer !important;
      }

  /* Tombol Lihat Hasil */
      .run-hasil {
        background-color: #9df3ff;
        border-radius: 15px;
        padding: 15px;
        margin-bottom: 10px;
        font-size: 1.5em;
        text-align: center;
        font-weight: 800;
        cursor: pointer;
        border: none;
        width: 100%;
      }
      .run-hasil:hover {
        background-image: linear-gradient(to bottom, #00468B, 20%, #9df3ff);
        color: black;
      }
      .blank-page {
        background-color: white;
        padding: 10px;
        align-items: center;
        justify-content: center;
        border-radius: 15px;
        height: 60%;
        flex-grow: 1;
      }

  /* Lihat Tabel */
      .lihat-tabel {
        background-color: #9df3ff;
        border-radius: 15px;
        padding: 10px;
        font-size: 1.5em;
        text-align: center;
        font-weight: 800;
        cursor: pointer;
        border: none;
        width: 100%;
        heigt: 40px;
      }
      .lihat-tabel:hover {
        background-image: linear-gradient(to bottom, #00468B, 20%, #9df3ff);
        color: black;
      }
      #tabel_container {
        overflow-x: auto;
        flex-grow: 1;
      }
      #tabel_container table {
        width: 100%;
        border-collapse: collapse;
        margin-bottom: 10px;
      }
      #tabel_container th, #tabel_container td {
        border: 1px solid #ddd; /* Warna border tabel yang lebih lembut */
        padding: 8px;
        text-align: left;
      }
      #tabel_container th {
        background-color: #f2f2f2; /* Warna header tabel */
        font-weight: bold;
      }
      .download-setting {
        display: flex;
        flex-direction: row;
        justify-content: space-around;
        align-items: center;
        width: 100%;
        margin-top: auto;
      }
      .pembagian-dl-set {
        padding: 5px;
        display: flex;
        flex-direction: column;
        justify-content: space-around;
        align-items: center;
        height: 100%;
        width: 100%;
        margin-top: auto;
      }
      .download-button {
        height: 45%;
        width: 100%;
        background-color: #9df3ff;
        color: black;
        border-radius: 10px;
        padding: 5px 5px;
        text-align: center;
        cursor: pointer;
        transition: background-color 0.3s ease;
        font-size: 1em;
        font-weight: 600;
        border: none;
        display: flex;
        align-items: center;
        justify-content: center;
        margin-bottom: 5px;
      }
      .download-button:hover {
        background-image: linear-gradient(to bottom, #00468B, 20%, #9df3ff);
        color: black;
      }
      .download-button p {
        margin: 0px;
      }

  /* Menu Utama (Global) */
      .menu {
        background-color: white;
        display: flex;
        flex-direction: column;
        width: 50px;
        height: 100%;
        justify-content: center;
        align-items: center;
        padding: 5px;
        border-radius: 15px;
        margin-left: 10px;
      }
      .menu-items {
        border-color: #9df3ff;
        border-radius: 15px;
        cursor: pointer;
        position: relative;
        display: flex;
        justify-content: center;
        align-items: center;
        height: 200px;
        width: 40px;
        margin-top: 15px;
        margin-bottom: 15px;
        border: none;
        background: none;
      }
      .menu-items:hover {
        background-image: linear-gradient(to bottom, #00468B, 10%, #9df3ff);
      }
      
  /* Modal (Overlay) */
      .modal-dialog {
        width: 80% !important; /* Lebar modal */
        max-width: 800px; /* Lebar maksimum */
      }
      .modal-content {
        border-radius: 15px;
        padding: 20px;
        background-color: #f8f8f8;
      }
      .modal-header {
        border-bottom: none;
        padding-bottom: 0;
      }
      .modal-title {
        font-size: 2em;
        font-weight: bold;
        color: #00468B;
      }
      .modal-body {
        padding-top: 10px;
        text-align: center;
      }
      .modal-footer {
        border-top: none;
        padding-top: 0;
      }
      .modal-footer .btn {
        background-color: #00468B;
        color: white;
        border-radius: 8px;
        padding: 10px 20px;
        font-size: 1.1em;
      }
      .modal-footer .btn:hover {
        background-color: #003366;
      }
      
  /* Styling untuk Carousel Bantuan */
      .bantuan-carousel {
        display: flex;
        align-items: center;
        justify-content: center;
        margin-bottom: 20px;
      }
      .bantuan-carousel img {
        max-width: 100%;
        height: auto;
        border-radius: 10px;
        box-shadow: 0 4px 8px rgba(0,0,0,0.1);
      }
      .carousel-nav-button {
        background-color: white;
        color: #00468B;
        border: none;
        padding: 10px 15px;
        border-radius: 10%;
        font-size: 1.5em;
        cursor: pointer;
        margin: 0 10px;
        transition: background-color 0.3s ease;
      }
      .carousel-nav-button:hover {
        background-color: #003366;
        color: white;
      }
      .bantuan-link {
        font-size: 1.1em;
        color: #00468B;
        text-decoration: underline;
      }
      
  /* Styling untuk Tentang Kami */
      .about-us-content {
        text-align: center;
      }
      .about-us-photos {
        display: flex;
        justify-content: space-around;
        align-items: flex-start;
        flex-wrap: wrap;
        margin-top: 20px;
      }
      .person-card {
        margin: 10px;
        text-align: center;
        flex: 1 1 30%;
        min-width: 150px;
      }
      .person-card img {
        width: 120px;
        height: 120px;
        border-radius: 50%;
        object-fit: cover;
        border: 3px solid #00468B;
        box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        margin-bottom: 10px;
      }
      .person-card p {
        margin: 0;
        font-size: 0.9em;
        color: #333;
      }
      .person-card .name {
        font-weight: bold;
        font-size: 1em;
        color: #00468B;
      }
      .about-us-link {
        margin-top: 20px;
        font-size: 1.1em;
        color: #00468B;
        text-decoration: underline;
      }
    "))
  ),

  # Struktur utama navbarPage
  navbarPage(
    title = NULL,
    id = "nav_panel",
    collapsible = FALSE,
    header = NULL,
    footer = NULL,
    selected = "homepage",

    # Homepage Tab
    tabPanel(
      title = NULL,
      value = "homepage",
      div(
        class = "app-container",
        # Display Utama####
        div(
          class = "main-display homepage",
          tags$img(src = "logo_mestika.png", class = "logo-img"),
          div(
            id = "step1",
            fileInput("peta_file", HTML("<h3>Pilihlah sebuah petamu.</h3><h5><i>(.kml untuk KML atau .zip untuk SHP)</i></h5>"),
              multiple = FALSE,
              accept = c(".zip", ".kml"),
              buttonLabel = "Pilih...",
              placeholder = "Belum ada file yang dipilih."
            )
          ),
          actionButton("upload_button", "Unggah Petamu", class = "upload-button")
        ),
        # Display Info (Sisi Kanan)####
        div(
          class = "info-bar-container",
          div(
            class = "info-box-top",
            tags$img(src = "mestika_project.png", class = "mestika-typography")
          ),
          div(
            class = "info-box-bottom",
            div(
              class = "info-text",
              HTML("Mestika (Mesin Titik Acak) adalah sebuah aplikasi berbasis bahasa pemrograman R untuk membantu pengguna memilih titik acak dari poligon dalam peta dengan mudah dan tepat. Ide dasar Mestika adalah memudahkan pemilihan sampel berbasis lokasi secara acak dalam sebuah penelitian dan survei. 
                   <br><br>")
            ),
            div(
              class = "author-info",
              HTML("Tim Pengembang Mestika")
            )
          )
        ),
        # Menu Utama (GLOBAL) - Akan selalu terlihat
        div(
          class = "menu",
          actionButton("btn_beranda", class = "menu-items", label = " ", icon = icon("home")),
          actionButton("btn_bantuan", class = "menu-items", label = " ", icon = icon("question")),
          actionButton("btn_about_us", class = "menu-items", label = " ", icon = icon("users"))
        )
      )
    ),

    # OpenMap Tab
    tabPanel(
      title = NULL,
      value = "openmap", # ID untuk tab ini
      div(
        class = "app-container",
        # Display Utama####
        div(
          class = "main-display map-page",
          leafletOutput("petaIndo_openmap",
            width = "100%",
            height = "100%"
          )
        ),
        # Display Pengaturan####
        div(
          class = "setting-bar-container",
          div(
            class = "setting-header",
            tags$img(src = "mestika_project.png", class = "mestika-typography")
          ),
          div(
            class = "setting-controls",
            div(
              class = "setting-text",
              HTML("Atur Jumlah Titik")
            ),
            numericInput("jumlah_titik", label = NULL, value = 10, min = 1), 
            # Default 10, min 1
            div(
              class = "setting-text",
              HTML("Pilih Kolom dalam Poligon")
            ),
            selectInput("kolom_nama_poligon", label = NULL, choices = NULL, 
                        selected = NULL),
            div(
              class = "setting-text",
              HTML("Pilih Sebaran Titik")
            ),
            selectInput("jenis_sebaran",
              label = NULL,
              choices = c(
                "Sebaran Acak Berstrata",
                "Sebaran Acak Merata"
              ),
              selected = NULL
            )
          ),
          actionButton("btn_lihat_hasil", "Lihat Hasil", class = "run-hasil"),
          div(
            class = "blank-page",
            actionButton("btn_tabel", class = "lihat-tabel", label = "Buka Tabel", 
                         icon = icon("table")),
            div(
              class = "download-setting",
              div(
                class = "pembagian-dl-set",
                div(class = "setting-text", HTML("Unduh Peta")),
                downloadButton("unduh_peta_hasil_shp", "File Peta .shp", 
                               class = "download-button"),
                downloadButton("unduh_peta_hasil_kml", "File Peta .kml", 
                               class = "download-button")
              ),
              div(
                class = "pembagian-dl-set",
                div(class = "setting-text", HTML("Unduh Tabel")),
                downloadButton("unduh_tabel_hasil_excel", "File Tabel .xlsx", 
                               class = "download-button"),
                downloadButton("unduh_tabel_hasil_csv", "File Tabel .csv", 
                               class = "download-button")
              )
            )
          )
        ),
        # Menu Utama (GLOBAL) - Akan selalu terlihat
        div(
          class = "menu",
          actionButton("btn_beranda", class = "menu-items", label = " ", 
                       icon = icon("home")),
          actionButton("btn_bantuan", class = "menu-items", label = " ", 
                       icon = icon("question")),
          actionButton("btn_about_us", class = "menu-items", label = " ", 
                       icon = icon("users"))
        )
      )
    )
  )
)