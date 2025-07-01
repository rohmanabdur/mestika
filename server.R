fpaket(
  "shiny", "shinyjs", "leaflet", "s2", "terra", "sf", "openxlsx", "bslib",
  "tools", "waiter", "reactable"
)


server <- function(input, output, session) {
  onSessionEnded(function() {
    stopApp()
  })

  observeEvent(input$peta_file, {
    enable("upload_button")
  })

  # --- Observer untuk tombol "Unggah Petamu" (akan memanggil fungsi proses) ---
  observeEvent(input$upload_button, {
    req(input$peta_file)
    file_path <- input$peta_file$datapath
    file_name <- input$peta_file$name

    print(paste("DEBUG: Nama file diunggah:", file_name))
    print(paste("DEBUG: Path sementara:", file_path))
    if (tools::file_ext(file_name) == "kml") {
      peta_input <<- reactive(f_baca_peta(file_path))
    }
    if (tools::file_ext(file_name) == "zip") {
      temp_dir_for_shp <- tempdir()
      list.files(temp_dir_for_shp, full.names = TRUE) |>
        vapply(file.remove, logical(1)) |>
        try(silent = TRUE)
      print("DEBUG: Pembersihan folder sementara selesai.")

      tryCatch(
        {
          unzip(file_path, exdir = temp_dir_for_shp)
          print("DEBUG: Unzip berhasil.")
        },
        error = function(e) {
          showNotification(paste0("Gagal mengekstrak file .zip: ", e$message), type = "error")
          shp_data <- reactiveVal(NULL)
          print(paste("ERROR: Gagal mengekstrak file .zip:", e$message))
          return(FALSE)
        }
      )

      daftar_file_shp <- list.files(temp_dir_for_shp, pattern = "\\.shp$", full.names = TRUE, recursive = TRUE)
      print(paste("DEBUG: File .shp ditemukan:", paste(daftar_file_shp, collapse = ", ")))

      peta_input <<- reactive(f_baca_peta(daftar_file_shp[1]))
    }

    if (!is.null(peta_input())) { # Hanya pindah halaman jika proses berhasil
      updateNavbarPage(session, "nav_panel", selected = "openmap")
      print("DEBUG: Berhasil memproses peta dan pindah ke halaman 'openmap'.")
    } else {
      print("DEBUG: Gagal memproses peta, tidak pindah halaman.")
    }
    updateSelectInput(inputId = "kolom_nama_poligon", choices = colnames(peta_input()))
    output$petaIndo_openmap <- renderLeaflet(f_tampilkan_peta_leaflet(peta_input()))
  })

  observeEvent(input$btn_lihat_hasil, {
    luas_tiap_poligon_peta <- reactive(as.numeric(st_area(peta_input())))

    ntitik_acak <<- f_titik_acak(
      input$jumlah_titik, luas_tiap_poligon_peta(),
      input$jenis_sebaran
    )$titik_poligon_akhir

    if (abs(sum(ntitik_acak) - input$jumlah_titik) > 0) {
      stop(paste(
        "Jumlah titik yang dihasilkan", ntitik_acak,
        "sedangkan yang diminta", input$jumlah_titik
      ))
    }

    positif <- which(ntitik_acak > 0)
    sampelku <- mapply(
      st_sample, peta_input()$geometry[positif],
      ntitik_acak[positif]
    ) |>
      lapply(function(dat) {
        st_coordinates(dat) |>
          as.data.frame()
      }) |>
      do.call(rbind, args = _) |>
      setNames(c("Longitude", "Latitude"))

    sampelku$Nama_Poligon <- rep(peta_input()[[input$kolom_nama_poligon]], ntitik_acak)
    sampelku$Nama_Titik <- paste0("T", 1:sum(ntitik_acak))
    sampelku <<- sampelku[, c("Nama_Titik", "Nama_Poligon", "Longitude", "Latitude")]
    output$petaIndo_openmap <- renderLeaflet(
      f_tampilkan_peta_leaflet(peta_input()) |>
        addMarkers(sampelku$Longitude, sampelku$Latitude,
          label = sampelku$Nama_Titik
        )
    )
  })

  output$unduh_tabel_hasil_excel <- downloadHandler(
    filename = function() {
      paste0("titik_sampel_acak_mestika_", as.POSIXct(Sys.time(), tz = "Asia/Jakarta"), ".xlsx")
    },
    content = function(file) {
      print("DEBUG: Unduh tabel Excel terpicu.")
      req(sampelku)
      hasil_tabel_titik <- as.data.frame(sampelku)
      write.xlsx(hasil_tabel_titik, file)
      print("DEBUG: File Excel berhasil dibuat.")
    }
  )

  output$unduh_tabel_hasil_csv <- downloadHandler(
    filename = function() {
      paste0("titik_sampel_acak_mestika_", as.POSIXct(Sys.time(), tz = "Asia/Jakarta"), ".csv")
    },
    content = function(file) {
      print("DEBUG: Unduh tabel CSV terpicu.")
      req(sampelku)
      hasil_tabel_titik <- as.data.frame(sampelku)
      write.csv(hasil_tabel_titik, file)
      print("DEBUG: File CSV berhasil dibuat.")
    }
  )

  output$unduh_peta_hasil_shp <- downloadHandler(
    filename = function() {
      paste0("titik_sampel_mestika_", as.POSIXct(Sys.time(), tz = "Asia/Jakarta"), ".zip")
    },
    content = function(file) {
      print("DEBUG: Unduh SHP terpicu.")
      hasil_titik_semua_poligon <- mapply(
        st_sample, peta_input()$geometry,
        ntitik_acak
      )
      for (k in seq_along(hasil_titik_semua_poligon)) {
        st_crs(hasil_titik_semua_poligon[[k]]) <- 4326
      }
      gabungan_titik_semua_poligon <- do.call("c", hasil_titik_semua_poligon)
      req(gabungan_titik_semua_poligon)

      folder_shp_sementara <- file.path(tempdir(), "titik_shp_acak")
      dir.create(folder_shp_sementara, showWarnings = FALSE)

      st_write(gabungan_titik_semua_poligon,
        file.path(folder_shp_sementara, "titik_sampel.shp"),
        delete_dsn = TRUE, quiet = TRUE
      )
      print("DEBUG: Shapefile titik sampel berhasil ditulis.")
      semua_file_zip <- list.files(folder_shp_sementara, full.names = TRUE)
      zip(file, semua_file_zip, flags = "-j")
      print("DEBUG: File ZIP SHP berhasil dibuat.")
      unlink(folder_shp_sementara, recursive = TRUE)
    },
    contentType = "application/zip"
  )

  output$unduh_peta_hasil_kml <- downloadHandler(
    filename = function() {
      paste0("peta_titik_sampel_acak_mestika_", as.POSIXct(Sys.time(), tz = "Asia/Jakarta"), ".kml")
    },
    content = function(file) {
      hasil_titik_semua_poligon <- mapply(
        st_sample, peta_input()$geometry,
        ntitik_acak
      )
      for (k in seq_along(hasil_titik_semua_poligon)) {
        st_crs(hasil_titik_semua_poligon[[k]]) <- 4326
      }
      gabungan_titik_semua_poligon <- do.call("c", hasil_titik_semua_poligon)
      print("DEBUG: Unduh peta KML terpicu.")
      req(gabungan_titik_semua_poligon)
      st_write(gabungan_titik_semua_poligon, file)
      print("DEBUG: File KML berhasil dibuat.")
    }
  )

  # Observer untuk Overlay Tabel Hasil Titik Koordinat



  # 2. Observer untuk tombol "Buka Tabel" (btn_tabel)
  #    Ketika tombol ini diklik, modal akan muncul.
  observeEvent(input$btn_tabel, {
    req(sampelku)
    print(paste("DEBUG: Tabel hasil memiliki", nrow(sampelku), "baris."))
    showModal(
      modalDialog(
        renderReactable(reactable(sampelku, striped = TRUE, groupBy = "Nama_Poligon")),
        title = "Data Tabel Titik Acak Terpilih", # Judul modal
        footer = modalButton("Tutup"), # Tombol untuk menutup modal
        size = "l"
      ) # Ukuran modal: "s" (small), "m" (medium), "l" (large), "xl" (extra large)
    )
  })

  # 3. Logika untuk merender tabel di dalam modal
  #    Output ini akan mengisi `tableOutput("modal_data_table")` di atas.


  # Observer untuk tombol "Beranda" (global menu)
  observeEvent(input$btn_beranda, {
    updateNavbarPage(session, "nav_panel", selected = "homepage")

    # Reset data saat kembali ke homepage jika diperlukan

    sampelku <- NULL
    # Reset nilai input di OpenMap
    updateNumericInput(session, "jumlah_titik", value = 10)
    updateSelectInput(session, "jenis_sebaran", selected = "Sebaran Acak Berstrata")
  })

  # Observer untuk tombol "Bantuan" (global menu)
  current_bantuan_img_idx <- reactiveVal(1)

  observeEvent(input$btn_bantuan, {
    current_bantuan_img_idx(1)
    showModal(modalDialog(
      title = "Bantuan Penggunaan Mestika",
      footer = modalButton("Tutup"),
      div(
        class = "bantuan-carousel",
        actionButton("prev_bantuan_img", "<", class = "carousel-nav-button"),
        uiOutput("bantuan_image_display"),
        actionButton("next_bantuan_img", ">", class = "carousel-nav-button")
      ),
      a(
        href = "http://enviro.teknik.unej.ac.id/wp-content/uploads/sites/13/2025/06/Buku-Panduan-Aplikasi-Mestika-versi-0.1.pdf", "Panduan Lengkap Aplikasi Mestika",
        target = "_blank", class = "bantuan-link"
      )
    ))
  })

  # Logika untuk menampilkan gambar bantuan di carousel
  output$bantuan_image_display <- renderUI({
    img_name <- paste0("Bantuan", current_bantuan_img_idx(), ".png")
    tags$img(src = img_name, alt = paste("Bantuan", current_bantuan_img_idx()))
  })

  # Observer untuk tombol "Next" di carousel bantuan
  observeEvent(input$next_bantuan_img, {
    current_idx <- current_bantuan_img_idx()
    if (current_idx < 9) { # Asumsi ada 3 gambar bantuan
      current_bantuan_img_idx(current_idx + 1)
    } else {
      current_bantuan_img_idx(1) # Kembali ke awal jika sudah di akhir
    }
  })

  # Observer untuk tombol "Previous" di carousel bantuan
  observeEvent(input$prev_bantuan_img, {
    current_idx <- current_bantuan_img_idx()
    if (current_idx > 1) {
      current_bantuan_img_idx(current_idx - 1)
    } else {
      current_bantuan_img_idx(9) # Kembali ke akhir jika sudah di awal
    }
  })

  # Observer untuk tombol "Tentang Kami" (global menu)
  observeEvent(input$btn_about_us, {
    showModal(modalDialog(
      title = "Tentang Mestika",
      footer = modalButton("Tutup"),
      div(
        class = "about-us-content",
        p("MESTIKA (Mesin Titik Acak) adalah sebuah aplikasi yang dikembangkan untuk membantu pengguna memilih titik acak dari peta dengan mudah dan tepat."),
        div(
          class = "about-us-photos",
          div(
            class = "person-card",
            tags$img(src = "Abdur_Rohman.jpeg", alt = "Abdur Rohman"),
            p(class = "name", "Abdur Rohman, S.T., M.Agr, Ph.D."),
            p("Founder & Technical Lead")
          ),
          div(
            class = "person-card",
            tags$img(src = "Faiq_Abdillah.jpg", alt = "Faiq Abdillah"),
            p(class = "name", "Faiq Abdillah, S.T."),
            p("UI Designer & Technical Assistant")
          ),
          div(
            class = "person-card",
            tags$img(src = "Cantika_Almas.jpg", alt = "Cantika Almas Fildzah"),
            p(class = "name", "Cantika Almas Fildzah, S.T., M.T."),
            p("UX Advisor & Guide Book Writer")
          )
        ),
        a(
          href = "https://enviro.teknik.unej.ac.id/mestika/",
          "Kunjungi Website Aplikasi Mestika", target = "_blank", class = "about-us-link"
        )
      )
    ))
  })
}