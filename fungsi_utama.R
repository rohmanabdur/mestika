fpaket <- function(paket1, ...) {
  nama_paket <- c(paket1, ...)
  for (k in seq_along(nama_paket)) {
    if (isFALSE(suppressWarnings(require(nama_paket[k],
      character.only = TRUE
    )))) {
      try({
        install.packages(nama_paket[k], repos = "https://cloud.r-project.org")
        library(nama_paket[k], character.only = TRUE)
      })
    }
  }
}

f_unzip_shp <- function(file_zip, token) {
  if (tools::file_ext(file_zip) != "zip") {
    print("DEBUG: Unggahan bukan .zip.")
    return(FALSE)
  }
  folder_sementara <- tempdir()
  daftar_file_sementara <- list.files(folder_sementara, full.names = TRUE)
  daftar_file_sementara |>
    vapply(file.remove, logical(1)) |>
    try(silent = TRUE) |>
    suppressWarnings()
  if (length(daftar_file_sementara) > 0) {
    unlink(folder_sementara, recursive = TRUE)
    folder_sementara <- tempdir()
  }
  print("DEBUG: Pembersihan folder sementara selesai.")

  tryCatch(
    {
      unzip(file_zip, exdir = folder_sementara)
      print("DEBUG: Unzip berhasil.")
    },
    error = function(e) {
      print(paste("ERROR: Gagal mengekstrak file .zip:"))
      return(FALSE)
    }
  )

  nama_semua_shp_dalam_zip <- list.files(folder_sementara,
    pattern = "\\.shp$", full.names = TRUE,
    recursive = TRUE
  )
  print(paste(
    "DEBUG: File .shp ditemukan:",
    paste(nama_semua_shp_dalam_zip, collapse = ", ")
  ))

  if (length(nama_semua_shp_dalam_zip) < 1) {
    print(HTML("<b>Kesalahan:</b>
                 Tidak ada file .shp ditemukan di dalam file .zip yang diunggah. 
                 Pastikan file .shp, .dbf, .shx, dll. berada langsung di dalam 
                 .zip atau dalam subfolder."))

    print("ERROR: Tidak ada file .shp ditemukan di ZIP.")
    return(FALSE)
  }
  # Sementara diambil satu shp yaitu shp pertama saja.
  return(nama_semua_shp_dalam_zip[1])
}

f_baca_peta <- function(nama_file_input) {
  print(paste("DEBUG: Nama file input:", nama_file_input))
  if (file_ext(nama_file_input) != "kml" && file_ext(nama_file_input) != "shp") {
    stop("Untuk saat ini Mestika hanya menerima file KML atau SHP.")
  }

  file_input_terbaca <- read_sf(nama_file_input)

  if (is.na(st_crs(file_input_terbaca))) {
    print("CRS shapefile tidak terdefinisi. 
           Mengatur default ke WGS84 (EPSG:4326) untuk tampilan peta.")
    file_input_terbaca <- st_set_crs(file_input_terbaca, 4326)
    print("DEBUG: CRS tidak terdefinisi, diatur ke WGS84.")
  }
  if (!grepl("WGS 84", st_crs(file_input_terbaca)$input)) {
    print(
      HTML(paste0("Mengubah proyeksi peta ke <b>WGS84 (EPSG:4326)</b> 
                    untuk kompatibilitas tampilan peta."))
    )
    file_input_terbaca <- st_transform(file_input_terbaca, 4326)
  }
  if (length(st_z_range(file_input_terbaca) > 0)) {
    file_input_terbaca <- st_zm(file_input_terbaca)
  }
  return(file_input_terbaca)
}


f_tampilkan_peta_leaflet <- function(file_peta_terbaca) {
  if (is.data.frame(file_peta_terbaca) && inherits(file_peta_terbaca, "sf")) {
    file_peta_terbaca |>
      leaflet() |>
      addTiles() |>
      addPolygons()
  } else {
    stop("File harus berupa data.frame hasil pembacaan read_sf().")
  }
}

f_titik_acak <- function(n_titik_total, luas_tiap_poligon,
                         jenis_sampling = "Sebaran Acak Berstrata") {
  n_titik_total <- as.integer(round(n_titik_total))
  stopifnot(
    "Jumlah titik acak harus berupa angka tidak negatif dan bukan pecahan." = n_titik_total >= 0
  )
  stopifnot(
    "Luas tiap poligon harus berupa angka lebih dari 0." =
      is.numeric(luas_tiap_poligon) & all(luas_tiap_poligon > 0)
  )
  if (jenis_sampling == "Sebaran Acak Merata") {
    banyak_poligon <- length(luas_tiap_poligon)
    persentase_luas <- rep(1 / banyak_poligon, banyak_poligon)
  } else {
    persentase_luas <- proportions(luas_tiap_poligon)
  }
  ntitik_per_poligon_awal <- ntitik_per_poligon_akhir <-
    round(persentase_luas * n_titik_total)
  selisih <- sum(ntitik_per_poligon_awal) - n_titik_total
  if (abs(selisih) > 0) {
    sebaran_sisa <- ifelse(selisih > 0, rep(-1, times = abs(selisih)),
      rep(1, times = abs(selisih))
    )
    luas_poligon_positif <- luas_tiap_poligon[which(luas_tiap_poligon > 0)]
    pilihan_urutan <- sample(1:length(luas_poligon_positif),
      size = abs(selisih)
    )
    ntitik_per_poligon_akhir[pilihan_urutan] <-
      ntitik_per_poligon_akhir[pilihan_urutan] + sebaran_sisa
  }

  hasil <- list(
    persentase_luas = persentase_luas,
    titik_poligon_awal = ntitik_per_poligon_awal,
    titik_poligon_akhir = ntitik_per_poligon_akhir,
    sisa = selisih,
    total_titik_hasil = sum(ntitik_per_poligon_akhir)
  )
  return(hasil)
}
