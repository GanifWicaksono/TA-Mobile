# CareLink — Mobile Fall Detection & Emergency Assistance

**CareLink** adalah aplikasi mobile keselamatan lansia berbasis Flutter dan Dart yang dirancang dengan konsep **Modern Creative Neumorphism** untuk mendeteksi kemungkinan jatuh menggunakan sensor internal smartphone (*accelerometer* dan *gyroscope*) serta mengirimkan notifikasi dan koordinat darurat secara *real-time* kepada anggota keluarga (*caregiver*).

> **Prinsip Utama:** *"Simple to Understand, Easy to Use, Always Ready to Help."*

---

## 1. Arsitektur Proyek & Struktur Kode

Aplikasi dibangun dengan arsitektur modular, scalable, dan clean code principles:

```text
lib/
├── main.dart                               # Entry point aplikasi & dependency injection
├── app/
│   ├── app.dart                            # Konfigurasi MaterialApp, Theme & Router
│   ├── routes/
│   │   └── app_routes.dart                 # Deklarasi rute statis
│   ├── theme/
│   │   ├── app_colors.dart                 # Color palette & konfigurasi dual-shadow Neumorphism
│   │   └── app_theme.dart                  # Material 3 & tipografi Plus Jakarta Sans
│   └── constants/
│       ├── app_constants.dart              # Konstanta layout, key penyimpanan, & timer
│       └── fall_detection_config.dart      # Threshold sensor & parameter algoritma
├── core/
│   ├── models/
│   │   ├── user_model.dart                 # Entitas profil pengguna (Lansia / Caregiver)
│   │   ├── emergency_event_model.dart      # Struktur data insiden & status penanganan
│   │   └── caregiver_model.dart            # Model lansia terhubung & telemetri perangkat
│   ├── services/
│   │   ├── fall_detection_service.dart     # State machine & engine deteksi jatuh
│   │   ├── location_service.dart           # Geolocator & reverse geocoding fallback
│   │   ├── notification_service.dart       # Event bus peringatan darurat & alert listener
│   │   └── storage_service.dart            # Abstraksi persistensi SharedPreferences
│   ├── utils/
│   │   ├── sensor_math.dart                # Perhitungan resultant, sudut tilt, smoothing & varians
│   │   └── date_formatter.dart             # Formatter waktu dan tanggal standar Indonesia
│   └── widgets/
│       ├── neumorphic_container.dart       # Base surface bertekstur dual-direction shadow
│       ├── neumorphic_card.dart            # Kartu elevated dengan border radius 20–24px
│       ├── neumorphic_button.dart          # Tombol sentuh haptic (area minimal 56–62 dp)
│       ├── neumorphic_text_field.dart      # Input field bertekstur inset/embossed
│       ├── neumorphic_toggle.dart          # Sakelar toggle AKTIF / NONAKTIF
│       ├── custom_bottom_nav.dart          # Navigasi bawah ramah lansia
│       ├── status_badge.dart               # Indikator status ganda (warna + teks + ikon)
│       ├── pulse_sos_button.dart           # Tombol darurat Coral Red dengan efek breathing pulse
│       └── carelink_app_bar.dart           # Header standar aplikasi
├── features/
│   ├── splash/
│   │   └── splash_screen.dart              # Layar pembuka & penentuan rute
│   ├── authentication/
│   │   ├── login_screen.dart               # Masuk dengan selektor peran
│   │   ├── register_screen.dart            # Pendaftaran akun Lansia / Caregiver
│   │   └── forgot_password_screen.dart     # Pemulihan kata sandi
│   ├── elderly/
│   │   ├── elderly_main_navigation.dart    # Shell navigasi & listener dialog konfirmasi jatuh
│   │   ├── dashboard/
│   │   │   └── elderly_dashboard_screen.dart # Dashboard status monitoring & tombol SOS
│   │   ├── fall_detection/
│   │   │   ├── fall_confirmation_dialog.dart # Layar konfirmasi countdown 30 detik
│   │   │   └── fall_simulation_sheet.dart  # Lembar uji coba & telemetri sensor
│   │   ├── emergency/
│   │   │   └── sos_confirmation_dialog.dart # Dialog pencegahan salah sentuh SOS
│   │   ├── activity/
│   │   │   └── elderly_activity_screen.dart # Riwayat kejadian bagi lansia
│   │   └── profile/
│   │       └── elderly_profile_screen.dart  # Pengaturan profil, izin & switch peran
│   └── caregiver/
│       ├── caregiver_main_navigation.dart   # Shell caregiver & banner darurat melayang
│       ├── dashboard/
│       │   └── caregiver_dashboard_screen.dart # Status lansia, baterai & insiden terkini
│       ├── emergency_detail/
│       │   └── emergency_detail_screen.dart # Detail kejadian, peta lokasi, navigasi & telepon
│       ├── history/
│       │   └── caregiver_history_screen.dart # Filter riwayat insiden (Aktif, Ditangani, Batal)
│       ├── notifications/
│       │   └── emergency_banner_notification.dart # Banner notifikasi push simulasi
│       └── profile/
│           └── caregiver_profile_screen.dart # Profil caregiver & switch peran
└── data/
    ├── repositories/
    │   ├── auth_repository.dart            # Manajemen sesi akun
    │   └── emergency_repository.dart       # Pengelolaan insiden & antrean offline
    └── providers/
        └── app_state_provider.dart         # Global state notifier (ChangeNotifier)
```

---

## 2. Identitas Visual & Desain Neumorphism

CareLink mengombinasikan estetika **Modern Creative Neumorphism** dengan prinsip desain aksesibilitas medis:

- **Soft Medical Blue (`#6C9FE6`):** Tombol aksi utama, tab aktif, dan identitas brand.
- **Soft Sky Blue (`#B9D8F2`):** Kartu informasi sekunder dan elemen ilustrasi.
- **Soft Cloud (`#EDF2F8`):** Warna kanvas latar belakang yang memberikan kontras halus bagi bayangan neumorphic.
- **Fresh Mint (`#76C9A5`):** Indikator status aman (*Safe*), normal, dan monitoring aktif.
- **Soft Coral Red (`#E97979`):** Aksen peringatan bahaya, tombol SOS darurat, dan banner alarm.
- **Aksesibilitas Kontras (WCAG AA/AAA):** Teks utama menggunakan warna Charcoal Slate (`#1E293B`) yang menghasilkan rasio kontras `11.5:1` terhadap latar belakang `#EDF2F8` (melampaui standar minimal `4.5:1`).
- **Dimensi Sentuh:** Seluruh tombol interaktif utama lansia memiliki tinggi minimal `56–64 dp` untuk meminimalkan *miss-tap*.

---

## 3. Algoritma Deteksi Kemungkinan Jatuh (*Fall Detection Logic*)

Modul `FallDetectionService` menerapkan algoritma berbasis aturan (*rule-based & threshold-based*) tanpa ketergantungan machine learning berat, sehingga sangat efisien dalam konsumsi daya baterai:

### Tahapan Perhitungan:

1. **Pengukuran Akselerasi Resultan:**
   $$A = \sqrt{a_x^2 + a_y^2 + a_z^2}$$
2. **Penyaringan Noise (Moving Average Smoothing):**
   Menerapkan *window buffer* (default 5 sampel) untuk menyaring getaran mikro saat berjalan normal.
3. **Fase 1 — Deteksi Penurunan Gravitasi (Free-fall Dip):**
   Ketika tubuh mulai terjatuh bebas, resultan akselerasi turun drastis ($A < 6.0\text{ m/s}^2$). Sistem mencatat sudut kemiringan sebelum benturan (*pre-impact tilt*).
4. **Fase 2 — Deteksi Puncak Benturan (High Impact Spike):**
   Saat tubuh membentur permukaan lantai, terjadi lonjakan akselerasi tajam ($A > 22.0\text{ m/s}^2$) bersamaan dengan lonjakan kecepatan sudut giroskop ($\omega > 3.5\text{ rad/s}$).
5. **Fase 3 — Observasi Ketidakaktifan (Inactivity Observation Window):**
   Sistem mengamati varians pergerakan pengguna selama 2.500 ms setelah benturan. Jika varians pergerakan mendekati nol (lansia tidak bergerak atau terbaring lemas) dan terjadi perubahan sudut orientasi ponsel ($\Delta \text{tilt} > 30^\circ$), status **`POSSIBLE_FALL`** dinyatakan.

### Siklus State Machine:
$$\text{IDLE} \longrightarrow \text{MONITORING} \longrightarrow \text{POSSIBLE\_FALL} \longrightarrow \text{CONFIRMATION} \longrightarrow \begin{cases} \text{EMERGENCY} & \text{(Butuh Bantuan / Timeout 30s)} \\ \text{CANCELLED} & \text{(Saya Baik-baik Saja)} \end{cases}$$

---

## 4. Alur Layar Konfirmasi & Eskalasi Darurat

Ketika kondisi `POSSIBLE_FALL` terdeteksi:
1. Layar dialog konfirmasi segera muncul dengan suara haptic peringatan dan penghitung waktu mundur (**30 detik**).
2. **Jika Lansia memilih "SAYA BAIK-BAIK SAJA":**
   - Alarm dibatalkan.
   - Kejadian dicatat sebagai *Cancelled* di riwayat.
   - Sistem kembali ke mode monitoring aktif.
3. **Jika Lansia memilih "BUTUH BANTUAN" ATAU waktu 30 detik habis tanpa respon:**
   - Sistem segera meminta koordinat GPS terkini melalui `LocationService`.
   - Objek `EmergencyEvent` dibuat dengan status `RECEIVED`.
   - Caregiver menerima notifikasi darurat prioritas tinggi berisi nama, waktu, koordinat, dan tautan langsung ke halaman **Emergency Detail**.

---

## 5. Cara Menjalankan & Menguji Aplikasi

### Prasyarat:
- Flutter SDK (versi >= 3.19.0)
- Dart SDK (versi >= 3.3.0)
- Android Studio / VS Code dengan ekstensi Flutter

### Langkah Menjalankan:
```bash
# 1. Unduh seluruh dependensi pubspec
flutter pub get

# 2. Jalankan unit test untuk memverifikasi kalkulasi sensor dan model
flutter test

# 3. Jalankan aplikasi pada perangkat Android atau Chrome
flutter run
```

### Fitur Pengujian Tanpa Melempar Smartphone:
Di layar **Elderly Dashboard**, terdapat tombol **"Panel Uji Coba & Simulasi Sensor Jatuh"**. Menekan tombol ini akan menampilkan telemetri sensor saat ini serta tombol pemicu simulasi **`PICU SIMULASI JATUH`**, memungkinkan demonstrasi alur konfirmasi dan pengiriman alarm tanpa membenturkan perangkat nyata.
