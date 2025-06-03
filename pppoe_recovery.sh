#!/bin/bash

# =============================================================
# PPPoE Şifre Çözüm ve Yeni Router İçin Ayarlar
# =============================================================
# Bu script ile modemden PPPoE kullanıcı adı ve şifresi çıkarılır.
# Ayrıca yeni router kurulumu için gerekli olan tüm bilgiler sağlanır.
#
# GEREKLİ FİZİKSEL BAĞLANTI:
#  1. Bilgisayar ile modem arasına bir Ethernet kablosu bağlayın.
#  2. Modemin WAN portundaki internet kablosunu çıkarın.
#  3. Bilgisayar kablosunu modemin WAN portuna takın.
#
# GEREKLİ YAZILIM:
#  - Linux (tavsiye: Linux Mint 19+)
#  - pppoe paketi (apt üzerinden kuruluyor)

echo "============================================"
echo " PPPoE Şifre Çözüm Aracı"
echo "============================================"
echo ""
echo "[!] Lütfen fiziksel bağlantıları yukarıdaki şekilde yaptıysanız devam edin."
read -p "Devam etmek istiyor musunuz? [E/h]: " ans
[[ "$ans" =~ ^[Ee]$ || -z "$ans" ]] || exit 0

# Root kontrolü
if [[ $EUID -ne 0 ]]; then
    echo "[X] Bu script sudo/root ile çalıştırılmalıdır!"
    exit 1
fi

# Gerekli paketler
echo "[*] Gerekli paketler kuruluyor (pppoe)..."
apt update -y && apt install -y pppoe || { echo "[!] pppoe kurulamadı."; exit 1; }

# PPPoE yapılandırması
echo "[*] PPPoE yapılandırma dosyaları hazırlanıyor..."
mkdir -p /etc/ppp

cat <<EOF > /etc/ppp/pppoe-server-options
require-pap
login
lcp-echo-interval 10
lcp-echo-failure 2
show-password
debug
logfile /var/log/pppoe-server-log
EOF

read -p "[?] Fiber kullanıcı adınızı girin (örnek: abcdefg@fiber): " USERNAME
echo "\"$USERNAME\" * \"\"" >> /etc/ppp/pap-secrets

touch /var/log/pppoe-server-log
chmod 0774 /var/log/pppoe-server-log

# Ağ arayüzü tespiti
echo "[*] Ethernet arayüzleri tespit ediliyor..."
ip -o link show | awk -F': ' '{print " - " $2}' | grep -E 'en|eth'

read -p "[?] Yukarıdaki arayüzlerden Ethernet olanı seçin (örnek: eth0): " INTERFACE

echo "[*] PPPoE sunucusu başlatılıyor..."
pppoe-server -F -I "$INTERFACE" -O /etc/ppp/pppoe-server-options &

sleep 2

# Log izleme
echo ""
echo "============================================"
echo " Kullanıcı Adı ve Şifre Bilgisi Yakalanıyor"
echo "============================================"
echo "[i] 1-2 dakika içinde kullanıcı adı ve şifre log'a düşecektir."
echo "[i] CTRL+C ile izlemeyi durdurabilirsiniz."
tail -f /var/log/pppoe-server-log

# Kullanıcıya ek bilgi sağla
cat <<SETTINGS

==================================================
 YENİ ROUTER KURULUMU İÇİN GEREKEN AYARLAR
==================================================
Örnek bir router kurulumu için aşağıdaki bilgileri kullanabilirsiniz değerler ISS tarafından sağlanan bilgilerle değiştirilebilir:

➤ Bağlantı Türü:      PPPoE
➤ Kullanıcı Adı:      $USERNAME
➤ Şifre:              (Yukarıdaki log ekranında gözükecektir)
➤ VLAN ID:            35
➤ MTU:                1492
➤ DNS Ayarları:       Otomatik (veya alternatif DNS: 1.1.1.1 / 8.8.8.8)
➤ MAC Clone:          Gerekirse eski modemin MAC adresi kopyalanabilir

📌 Notlar:
- Eğer internet erişimi olmazsa ISS’den (örneğin Türk Telekom) gelen orijinal modemin MAC adresini klonlayarak deneyin.
- Bazı cihazlarda WAN bağlantısı için VLAN ID girişi şarttır.

SETTINGS

echo "[✔] Rehber tamamlandı. Şifrenizi log dosyasında görebilirsiniz."
