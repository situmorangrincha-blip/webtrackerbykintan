# LANU · Content Calendar Dr. Andreas & Dr. Ogi (Vercel + Supabase)

Isi repo (4 file, tanpa build, Vercel otomatis deteksi sebagai static site):

- `index.html`  : webnya (kalender, preview grid, tabel, status, key message & pillar)
- `foto.jpg`    : foto di header kanan atas
- `schema.sql`  : tabel + fungsi Supabase (password dicek di server)
- `README.md`   : panduan ini

## 1. Supabase (pakai project yang sudah ada)
1. Supabase > project lu > **SQL Editor** > New query > paste isi `schema.sql` > **Run**
   (aman dijalankan ulang, hasilnya `Success. No rows returned`).
2. **Settings > API Keys**: salin **Publishable key** (`sb_publishable_...`).
   Project URL sudah terisi di `index.html`; kalau pakai project lain, ganti juga.

## 2. Isi kunci di index.html
Cari baris ini (sekitar baris 300) dan ganti `PASTE_PUBLISHABLE_KEY`:

    var CFG={url:'https://khjzguakrzpsvyjcvzjg.supabase.co',key:'PASTE_PUBLISHABLE_KEY'};

Pakai publishable key saja. **Jangan** pernah pakai secret / service_role key.

## 3. GitHub
1. github.com > New repository (misal `lanu-dokter-calendar`) > Create.
2. **Add file > Upload files**: upload `index.html`, `foto.jpg`, `schema.sql`, `README.md` > Commit.

## 4. Vercel
1. vercel.com > **Add New > Project** > pilih repo tadi > **Deploy** (tanpa ubah pengaturan).
2. Selesai: dapat link `xxx.vercel.app`. Buka, masukkan password.

## Catatan
- Password awal: `theojames`. Ganti: ubah nilainya di `schema.sql` (baris `insert into public.app_config`), lalu Run ulang.
- Password dicek di database lewat fungsi `check_pw`, tidak ada di kode web. Tabel dikunci (RLS), akses cuma lewat fungsi yang minta password.
- Data tersimpan otomatis tiap diubah, dan layar disegarkan dari server tiap 15 detik (tidak menimpa form/sel yang lagi dibuka).
- Daftar Key message & Content pillar disimpan sebagai satu baris khusus (`__lists__`) di tabel `posts`.
- Data dari versi link Claude tidak ikut pindah; versi ini mulai dari kosong.
- Update web: edit `index.html` di GitHub, Commit; Vercel otomatis deploy ulang.
