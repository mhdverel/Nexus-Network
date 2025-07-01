#!/bin/bash

# Meminta input Node ID
read -p "Masukkan Node ID (pisahkan dengan spasi jika lebih dari satu): " -a NODE_IDS

echo "🔄 Menyiapkan sistem..."
sudo apt update
sudo apt upgrade -y
sudo apt install -y build-essential pkg-config libssl-dev git-all protobuf-compiler curl screen

# Setup Rust dan Cargo jika belum terpasang
if ! command -v cargo &> /dev/null; then
  echo "📦 Menginstal Rust via rustup..."
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
  source "$HOME/.cargo/env"
else
  source "$HOME/.cargo/env"
fi

# Clone dan build Nexus CLI
echo "📁 Menyiapkan source code Nexus CLI..."
cd "$HOME"
rm -rf nexus-cli
git clone https://github.com/nexus-xyz/nexus-cli.git
cd nexus-cli
git fetch --all --tags
LATEST_TAG=$(git describe --tags "$(git rev-list --tags --max-count=1)")
git checkout "$LATEST_TAG"

echo "⚙️ Build binary nexus-network..."
cd clients/cli
cargo clean
cargo build --release --features build_proto

# Cek hasil build
BIN_PATH=$(find target/release -maxdepth 1 -type f -executable -name 'nexus-*' | grep nexus-network)
if [ -z "$BIN_PATH" ]; then
  echo "❌ Gagal menemukan binary nexus-network setelah build!"
  exit 1
fi

# Hentikan service lama dan screen yang masih berjalan
echo "🧹 Membersihkan node lama..."
sudo systemctl stop nexus-node.service 2>/dev/null

for id in "${NODE_IDS[@]}"; do
  sudo screen -S "nexus-node-$id" -X quit 2>/dev/null
done

sudo mv /usr/local/bin/nexus-network /usr/local/bin/nexus-network.bak 2>/dev/null
sudo cp "$BIN_PATH" /usr/local/bin/

# Jalankan node dalam screen session
cd ~

echo "🚀 Menjalankan node dalam screen:"
for id in "${NODE_IDS[@]}"; do
  echo "   ➤ Menjalankan node ID: $id"
  screen -dmS "nexus-node-$id" nexus-network start --node-id "$id"
done

# Output akhir
echo ""
echo "✅ Semua node berhasil dijalankan!"
echo "👉 Gunakan perintah berikut untuk melihat log masing-masing node:"
for id in "${NODE_IDS[@]}"; do
  echo "   screen -r nexus-node-$id"
done
echo ""
echo "👉 Tekan Ctrl+A lalu D untuk keluar dari screen tanpa menghentikan proses."
