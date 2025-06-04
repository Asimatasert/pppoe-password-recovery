# PPPoE Şifre Kurtarma Aracı

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

## Genel Bakış
Bu araç, PPPoE sunucusu oluşturarak modeminden kimlik doğrulama girişimlerini yakalayarak PPPoE kimlik bilgilerini kurtarmanıza olanak tanır. Özellikle yeni bir router kurulumu yaparken ve ISS tarafından sağlanan, eski modeminizde saklanan kimlik bilgilerine ihtiyacınız olduğunda kullanışlıdır.

## Özellikler
- PPPoE kullanıcı adı ve şifresini otomatik olarak çıkarır
- Yeni router kurulumu için önerilen yapılandırma değerlerini sağlar
- Teknik olmayan kullanıcılar için basit adım adım arayüz sunar

## Gereksinimler
- Linux işletim sistemi (önerilen: Linux Mint 19+)
- Root/sudo yetkileri
- Modem ile ethernet bağlantısı
- Modemden internet geçici olarak kesilmiş olmalı

## Kurulum

1. Bu depoyu klonlayın veya betiği indirin:
   ```bash
   git clone https://github.com/kullaniciadi/pppoe-password-recovery.git
   cd pppoe-password-recovery
   ```

2. Betiği çalıştırılabilir yapın:
   ```bash
   chmod +x pppoe-recovery.sh
   ```

## Fiziksel Kurulum
1. Bilgisayarınızı modeme bir ethernet kablosu ile bağlayın
2. WAN/internet kablosunu modemden çıkarın
3. Bilgisayarınızın ethernet kablosunu modemin WAN portuna bağlayın

## Kullanım
Betiği root olarak veya sudo yetkileriyle çalıştırın:

```bash
sudo ./pppoe-recovery.sh
```

Ekrandaki yönergeleri izleyin:
1. Doğru fiziksel bağlantıları yaptığınızı onaylayın
2. İstendiğinde fiber kullanıcı adınızı girin
3. Uygun Ethernet arayüzünü seçin
4. Betik giriş bilgilerini yakalayacak şekilde 1-2 dakika bekleyin
5. Günlükte şifreyi gördüğünüzde Ctrl+C tuşlarına basın

## Router Yapılandırması
Kimlik bilgilerini aldıktan sonra, yeni router'ınızı şu şekilde yapılandırın:

- Bağlantı Türü: PPPoE
- Kullanıcı Adı: (araçtan yakalanan)
- Şifre: (araçtan yakalanan)
- VLAN ID: 35
- MTU: 1492
- DNS Ayarları: Otomatik (veya alternatif DNS: 1.1.1.1 / 8.8.8.8)
- MAC Klonlama: Gerekirse, orijinal modemin MAC adresini klonlayın

## Sorun Giderme
- Günlüklerde kimlik doğrulama girişimleri görünmüyorsa, modemi yeniden başlatmayı deneyin
- Yeni router bağlantı kuramıyorsa, orijinal modemin MAC adresini klonlamayı deneyin
- Bazı ISS'ler belirli VLAN ID'leri gerektirebilir; 35 yaygındır ancak evrensel değildir

## Yasal Uyarı
Bu araç yalnızca meşru kullanım içindir - kişisel ağ kurulumu için kendi PPPoE kimlik bilgilerinizi kurtarmak için. Bu aracı, erişim yetkisine sahip olmadığınız kimlik bilgilerini kurtarmaya çalışmak için kullanmak, ISS'nizle hizmet şartlarını ve potansiyel olarak yerel yasaları ihlal edebilir.

## Lisans
Bu proje MIT Lisansı altında lisanslanmıştır - ayrıntılar için LICENSE dosyasına bakın.
