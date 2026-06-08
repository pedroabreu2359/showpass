# ShowPass 🎟 — Premium Ticket App

Aplicativo Flutter de venda de ingressos para shows e eventos, desenvolvido como projeto universitário de alto nível.

## Identidade Visual

- **Cor primária:** Roxo `#9333EA`
- **Cor de destaque:** Rosa `#EC4899`
- **Dark mode premium** inspirado em Spotify, Ticketmaster e Apple

## Funcionalidades

- Splash Screen animada
- Login / Cadastro (com Google e Apple simulados)
- Seleção de gostos musicais (onboarding personalizado)
- Home com banner em destaque, seções de recomendados e categorias
- Busca com filtros por categoria, preço e localização
- Detalhes do evento com mapa, playlist Spotify e alerta de lote
- Seleção de ingressos (Pista, VIP, Camarote, Meia Entrada) com quantidade
- Pagamento simulado (Pix, Cartão, Apple Pay, Google Pay)
- Tela de compra concluída com animação
- Meus Ingressos com ingresso digital e QR Code real
- Perfil com histórico, favoritos e preferências musicais

## Catálogo de Eventos (30+)

- Shows internacionais: Coldplay, The Weeknd, Bruno Mars, Dua Lipa, Ed Sheeran, Olivia Rodrigo, Taylor Swift, Imagine Dragons
- Shows nacionais: Ivete Sangalo, Alok, Ana Castela, Jorge & Mateus, Gusttavo Lima, Luan Santana, Zé Neto & Cristiano, Matheus & Kauan
- Festivais: Lollapalooza, Rock in Rio, The Town, Tomorrowland Brasil, Ultra Music Festival
- Teatro: O Fantasma da Ópera, Wicked, Stand-up Comedy Festival
- Esportes: Final Libertadores, NBB Finals, UFC Fight Night, Superliga de Vôlei
- Funk: Baile do Anitta
- Trap: Trap Brasil Festival

## Estrutura

```
lib/
├── main.dart
├── models/
│   ├── event_model.dart
│   ├── ticket_model.dart
│   └── user_model.dart
├── screens/
│   ├── splash_screen.dart
│   ├── login_screen.dart
│   ├── signup_screen.dart
│   ├── music_taste_screen.dart
│   ├── home_screen.dart
│   ├── search_screen.dart
│   ├── event_detail_screen.dart
│   ├── ticket_select_screen.dart
│   ├── payment_screen.dart
│   ├── purchase_success_screen.dart
│   ├── my_tickets_screen.dart
│   └── profile_screen.dart
├── widgets/
│   └── shared_widgets.dart
├── services/
│   └── app_state.dart
├── routes/
│   └── app_routes.dart
├── theme/
│   └── app_theme.dart
├── data/
│   └── mock_events.dart
└── utils/
    └── app_utils.dart
```

## Como rodar

```bash
# 1. Pré-requisitos: Flutter 3+ instalado
flutter --version

# 2. Entre na pasta do projeto
cd showpass

# 3. Instale as dependências
flutter pub get

# 4. Rode o app
flutter run

# Para gerar APK:
flutter build apk --release
```

## Dependências

```yaml
google_fonts: ^6.1.0        # Tipografia Inter
shared_preferences: ^2.2.2  # Persistência local
intl: ^0.19.0               # Formatação de datas/moedas
qr_flutter: ^4.1.0          # QR Code real nos ingressos
```

## Fluxo de Navegação

```
Splash → Login → Cadastro → Gostos Musicais → Home
Home → Detalhes do Evento → Seleção de Ingressos → Pagamento → Sucesso → Meus Ingressos
Home (tab) → Buscar
Home (tab) → Meus Ingressos  
Home (tab) → Perfil
```

---

Projeto desenvolvido com Flutter 3 + Material 3 + Dark Mode Premium.
