# Sistema de Ponto com Geolocalização e Biometria

Descrição: Um aplicativo Flutter que permite ao funcionário registrar seu ponto de trabalho quando estiver a até 100 metros do local de trabalho. A autenticação pode ser feita via NIF e senha ou utilizando reconhecimento facial via biometria.
Funcionalidades:
- Autenticação por NIF e senha ou reconhecimento facial.
- Verificação de localização usando geolocalização.
- Armazenamento do registro de ponto com data, hora e localização.
- Integração com Firebase para autenticação e armazenamento dos dados.

## Relatório de Implementação

### Descrição Técnica das Funcionalidades Implementadas

O aplicativo foi desenvolvido utilizando Flutter, um framework para desenvolvimento de aplicações móveis multiplataforma. A arquitetura segue o padrão MVC (Model-View-Controller), com separação clara entre:

- **Models**: Representam as entidades de dados (ClockRecord e Workplace).
- **Views**: Interfaces de usuário (AutenticacaoView, LoginView, RegistroView, HomeView, MapView).
- **Controllers**: Lógica de negócio e integração com serviços externos (AuthController, FirestoreController, LocationController).

#### Funcionalidades Principais:

1. **Autenticação**:
   - Login e registro utilizando NIF como identificador único (convertido para formato de email para compatibilidade com Firebase Auth).

2. **Registro de Ponto**:
   - Verificação automática de localização: o usuário só pode registrar ponto se estiver dentro de um raio de 100 metros do local de trabalho.
   - Alternância automática entre entrada e saída baseada no último registro do dia.
   - Armazenamento de registros com data, hora e coordenadas GPS.

3. **Configuração de Local de Trabalho**:
   - Interface de mapa interativo para seleção do local de trabalho.
   - Utiliza OpenStreetMap para renderização do mapa.
   - Persistência da localização no Firestore.

4. **Histórico de Pontos**:
   - Listagem em tempo real dos registros de ponto do usuário.
   - Ordenação por data e hora decrescentes.

### Decisões de Design

- **Arquitetura**: Adotada arquitetura MVC para facilitar manutenção e testabilidade.
- **Estado de Autenticação**: Utilizado StreamBuilder para reagir a mudanças no estado de autenticação do Firebase Auth.
- **Geolocalização**: Implementada verificação de proximidade usando a fórmula de Haversine (via Geolocator).
- **Armazenamento**: Firestore para dados não-relacionais, permitindo sincronização em tempo real.
- **UI/UX**: Interface Material Design, com feedback visual para ações do usuário (SnackBars, indicadores de carregamento).
- **Tratamento de Erros**: Try-catch em operações assíncronas com mensagens de erro amigáveis.

### Especificação do Uso de APIs Externas e Integração com Firebase

#### Firebase:
- **Firebase Auth**: Gerenciamento de autenticação de usuários. O NIF é tratado como email (ex: "123456@nif.com") para compatibilidade.
- **Cloud Firestore**: Armazenamento de registros de ponto e configurações de local de trabalho. Estrutura de coleções:
  - `clock_records`: Registros de entrada/saída.
  - `workplaces`: Configurações de local de trabalho por usuário.

#### APIs e Plugins Utilizados:
- **geolocator**: Para obtenção de coordenadas GPS e cálculo de distâncias.
- **flutter_map**: Para exibição interativa de mapas.
- **latlong2**: Para manipulação de coordenadas geográficas.
- **permission_handler**: Para gerenciamento de permissões (localização).
- **intl**: Para formatação de datas e horas.

### Desafios Encontrados e Como Foram Resolvidos

1. **Compatibilidade de Autenticação**:
   - **Desafio**: Firebase Auth requer formato de email, mas o sistema usa NIF numérico.
   - **Solução**: Concatenação de "@nif.com" ao NIF para criar um email válido.

2. **Verificação de Localização em Tempo Real**:
   - **Desafio**: Garantir precisão e eficiência na verificação de proximidade.
   - **Solução**: Uso de Geolocator.distanceBetween() com raio configurável (100m).

3. **Integração com Mapas**:
   - **Desafio**: Implementar seleção interativa de localização no mapa.
   - **Solução**: FlutterMap com TileLayer do OpenStreetMap e tratamento de eventos de toque.

4. **Gerenciamento de Permissões**:
   - **Desafio**: Solicitar permissões de localização e biometria de forma adequada.
   - **Solução**: Verificação e solicitação de permissões antes de operações críticas.

5. **Sincronização de Dados**:
   - **Desafio**: Garantir consistência entre dados locais e Firestore.
   - **Solução**: Uso de Streams para atualizações em tempo real e tratamento de estados offline.

## Documentação de Instalação e Uso

### Pré-requisitos

- Flutter SDK (versão 3.8.1 ou superior)
- Dart SDK (incluído no Flutter)
- Conta Google para Firebase
- Dispositivo Android/iOS com suporte a GPS e biometria (opcional)


### Uso do Aplicativo

1. **Registro/Login**:
   - Na primeira execução, registre-se com seu NIF e senha.
   - Alternativamente, use autenticação biométrica se disponível.

2. **Configuração do Local de Trabalho**:
   - Na tela inicial, clique em "Registrar Local de Trabalho".
   - No mapa, toque para selecionar a localização.
   - Clique no ícone de salvar para confirmar.

3. **Registro de Ponto**:
   - Certifique-se de estar dentro de 100m do local configurado.
   - Clique em "Bater Ponto" para registrar entrada/saída.
   - O sistema alterna automaticamente entre entrada e saída.

4. **Visualização do Histórico**:
   - Os registros aparecem automaticamente na lista inferior da tela inicial.
   - Inclui data, hora e coordenadas de cada ponto.

