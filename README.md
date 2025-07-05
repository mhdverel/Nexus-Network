# 🚀 Nexus Testnet III Deployment Script

Shell script otomatis untuk setup dan menjalankan beberapa instance **Nexus Network Node** menggunakan `screen`. Skrip ini akan:

- Memasang dependencies sistem
- Memastikan `cargo` & `rust` terinstal
- Membangun binary dari repo [`nexus-cli`](https://github.com/nexus-xyz/nexus-cli)
- Menyalin binary `nexus-network` ke `/usr/local/bin`
- Menjalankan masing-masing node menggunakan `screen`

---

## 📂 Struktur

Repository ini berisi file utama:

```bash
nexus.sh    # Script deploy node nexus-network
```

---

## ⚙️ Prasyarat

### 🖥️ Minimum Spesifikasi Server

- CPU: 2 vCPU
- RAM: 4 GB
- Penyimpanan: 20 GB (disarankan SSD)
- Koneksi Internet stabil

### 🐧 Distro yang Direkomendasikan

- Ubuntu 22.04 LTS atau Ubuntu 24.04 LTS



Pastikan server kamu menjalankan OS **Ubuntu/Debian-based** dan sudah memiliki akses `sudo`.

---

## 🛠️ Cara Menggunakan

1. **Clone Repository**:

```bash
git clone https://github.com/mhdverel/Nexus-Network.git
cd Nexus-Network
```

2. **Beri permission eksekusi & jalankan**:

```bash
chmod +x nexus.sh
./nexus.sh
```

3. **Masukkan ID node saat diminta**, contoh:

```bash
Masukkan Node ID (pisahkan dengan spasi jika lebih dari satu): 123456 654321
```

---

## 🧪 Cek Status Node

Untuk melihat log node tertentu:

```bash
screen -r nexus-node-123456
```

Untuk keluar dari screen tanpa menghentikan proses:

```
Ctrl + A, lalu tekan D
```

Untuk melihat semua session screen:

```bash
screen -ls
```

---

## 🧹 Menghentikan Node

Untuk menghentikan node tertentu:

```bash
screen -S nexus-node-123456 -X quit
```

---

## 📌 Catatan Tambahan

- Script ini akan **mengambil tag terbaru** dari repo [nexus-cli](https://github.com/nexus-xyz/nexus-cli).
- Backup otomatis binary lama ke `/usr/local/bin/nexus-network.bak`.
- Script bisa dijalankan berulang untuk node baru tanpa konflik.
