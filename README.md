# Prompt prem by kenzz — HTML edition

Project ini memakai HTML, CSS, dan JavaScript biasa. Upload isi ZIP ini ke root repository GitHub, lalu impor repository di Vercel.

## File
- `index.html`: beranda, katalog, generator, favorit, dashboard Owner.
- `style.css`: desain responsif.
- `app.js`: fitur katalog, salin, berbagi, generator, dan integrasi Supabase.
- `supabase/schema.sql`: database dan aturan keamanan.

## Upload dan deploy
1. Ekstrak ZIP.
2. Upload `index.html`, `style.css`, `app.js`, `README.md`, dan folder `supabase` ke root repository GitHub.
3. Impor repository di https://vercel.com/new. Ini situs statis, jadi Build Command kosong dan file `index.html` berada di root.

## Fitur yang langsung dapat dicoba
Katalog contoh, pencarian/filter, generator prompt teks, favorit lokal, salin prompt, bagikan prompt/website, dan menu ☰.

## Aktifkan Owner dan penerbitan online
1. Buat project di https://supabase.com/.
2. Jalankan seluruh `supabase/schema.sql` di SQL Editor.
3. Di Project Settings → API, salin Project URL dan anon/publishable key.
4. Isi `SUPABASE_URL` dan `SUPABASE_ANON_KEY` di bagian atas `app.js`. Jangan pernah masukkan `service_role` key ke kode browser.
5. Buat akun Owner di Supabase Authentication → Users.
6. Salin UUID akun tersebut dan jalankan: `update public.profiles set role='owner' where id='UUID-AKUN-OWNER';` (ganti dengan UUID asli).
7. Commit perubahan `app.js` ke GitHub agar Vercel deploy ulang.
8. Login di bagian Dashboard Owner. Hanya akun role owner yang boleh menerbitkan/mengedit/menghapus; RLS di database mengamankan tindakan tersebut.

Website ini gratis untuk tahap awal dan tidak ada fitur pembayaran/paywall. Prompt contoh dapat dilihat tanpa Supabase, tetapi penyimpanan online dan login Owner perlu konfigurasi Supabase.
