# Kode R untuk aplikasi Mestika (Mesin Titik Acak) versi 0.1 ini
# ditulis oleh Abdur Rohman dan Faiq Abdillah dengan mengambil inspirasi dari 
# berbagai sumber dan dengan masukan-masukan dari Ibu Cantika Almas Fildzah. 
# Kode R untuk Mestika ini dibagikan oleh penulis
# dengan secara gratis dan open source dengan jenis lisensi Apache versi 2.0.
# Tentang Mestika: https://enviro.teknik.unej.ac.id/mestika/
# ----
# Copyright 2025 Abdur Rohman, Faiq Abdillah, and Cantika Almas Fildzah
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#----

source("MestikaProject/fungsi_utama.R")
source("MestikaProject/server.R")
source("MestikaProject/ui.R")


# Ukuran maksimum file yang diunggah (300 MB)
options(shiny.maxRequestSize = 300*1024^2)

# Jalankan aplikasi Shiny
shinyApp(ui = ui, server = server, 
         options = list(launch.browser = TRUE, 
                        display.mode = "normal"))
