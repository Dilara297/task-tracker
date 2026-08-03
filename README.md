# Görev Takip Sistemi

Görev Takip Sistemi, kullanıcıların günlük görevlerini kolayca oluşturup yönetebileceği Django tabanlı bir web uygulamasıdır.

## Özellikler

- Kullanıcı kayıt olma
- Kullanıcı girişi ve çıkışı
- Kullanıcıya özel görevler
- Görev ekleme
- Görev düzenleme
- Görev silme
- Tamamlanan ve tamamlanmayan görevleri görüntüleme
- Profil sayfası
- REST API altyapısı

## Kullanılan Teknolojiler

- Python
- Django
- Django REST Framework
- SQLite
- HTML
- CSS
- Bootstrap (SB Admin 2)
- Git & GitHub

## Kurulum

Projeyi klonlayın:

```bash
git clone <repo-linki>
```

Proje klasörüne girin:

```bash
cd gorev-takip
```

Sanal ortam oluşturun:

```bash
python -m venv venv
```

Sanal ortamı çalıştırın:

Windows:

```bash
venv\Scripts\activate
```

Gerekli paketleri yükleyin:

```bash
pip install -r requirements.txt
```

Migrasyonları çalıştırın:

```bash
python manage.py migrate
```

Sunucuyu başlatın:

```bash
python manage.py runserver
```

## Proje Yapısı

```
config/
tasks/
templates/
static/
manage.py
```

## Geliştirme Durumu

Web uygulamasının temel özellikleri tamamlanmıştır.

Planlanan geliştirmeler:

- Flutter mobil uygulaması
- Bildirim sistemi
- Görev kategorileri
- Son teslim tarihi
- Öncelik sistemi
- Takvim görünümü

## Geliştirici

Dilara Demirkıran
