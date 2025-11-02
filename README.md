
# 🎵 MP3 Player – Aplicativo Flutter de Reprodução e Download de Músicas

## 📱 Sobre o Projeto

Este projeto foi desenvolvido como parte da atividade proposta pelo professor **Rafael Amorim** na disciplina de **Mobile II** do Curso de Tecnico em Analise e Desenvolvimento de Sistemas.  

O aplicativo tem como objetivo **baixar e reproduzir uma playlist de músicas MP3** a partir de um **arquivo JSON hospedado em um servidor remoto**.

Durante o desenvolvimento, foram aplicados conceitos de:
- Programação em **Flutter** para Android;
- **Execução de tarefas em segundo plano** (background work);
- **Serviço ativo** durante a reprodução (notificações com controles de mídia);
- **Streaming progressivo** — a música começa a tocar antes do download completo.

---

## 🧩 Consigna do Trabalho

> **Desenvolva um aplicativo Flutter para Android que baixe e reproduza uma playlist de músicas MP3.**  
> Os arquivos de áudio serão obtidos a partir de um JSON hospedado em um servidor remoto.  
>  
> **Objetivos:**
> - Desenvolvimento do trabalho em grupo;  
> - Execução de tarefas em segundo plano;  
> - Manutenção de um serviço ativo durante a reprodução (notificação persistente com controles de mídia);  
> - Implementação de streaming progressivo (iniciar a reprodução antes do download completo).

**Link do JSON:**  
https://www.rafaelamorim.com.br/mobile2/musicas/list.json

### 🗂️ Exemplo de Conteúdo do JSON

```json
[
  {
    "titulo": "Nome da Música",
    "autor": "Artista",
    "url": "https://www.rafaelamorim.com.br/mobile2/musicas/faixa1.mp3"
  }
]
```

---

## 🎧 Funcionalidades do Aplicativo

- Exibe uma **lista de músicas** obtidas via JSON remoto.  
- Permite **baixar e reproduzir** as músicas em **background**.  
- **Streaming progressivo:** inicia a reprodução assim que o buffer inicial é carregado.  
- **Serviço em segundo plano** com **notificação persistente**:
  - Mostra título e autor da música em execução;
  - Controles de **Play / Pause / Stop**;
  - Continua ativo mesmo com o app fechado.
- **Interface intuitiva** mostrando:
  - Estado do download: *baixando, aguardando buffer, reproduzindo, pausado, erro*;
  - **Barra de progresso** do download e buffer;
  - Mensagens de erro em caso de falhas de rede.
- **Modos adicionais:**
  - Reprodução **aleatória** (shuffle);
  - **Repetição** de uma música ou de toda a playlist;
  - **Recuperação de downloads interrompidos**;
  - **Economia de bateria** e liberação de recursos ao término da reprodução.

---

## 🗺️ Easter Egg 🎶

Se o usuário estiver **num raio de 50 metros do Campus Livramento**, uma faixa extra é adicionada automaticamente à playlist:

- **Artista:** Os Bilias  
- **Duração:** 3:14  
- **URL:**  
  `https://www.rafaelamorim.com.br/mobile2/musicas/osbilias-nome-da-faixa-faixa-5 .mp3`  
  *(atenção ao espaço antes do `.mp3`)*

---

## 👥 Equipe de Desenvolvimento

## Integrantes 
- Santiago Escobar
- Juan Martin Mosegui 
- Verónica Ferreira 


---

## 🛠️ Tecnologias Utilizadas

- **Flutter **
- **Dart**
- **Packages:**
  - `just_audio`
  - `audio_service`
  - `flutter_background_service`
  - `workmanager`
  - `http`
  - `provider`
  - `intl`

---

## 🚀 Como Executar o Projeto

1. **Clonar o repositório:**
   ```bash
   git clone https://github.com/usuario/mp3_player.git
   ```
2. **Acessar a pasta do projeto:**
   ```bash
   cd mp3_player
   ```
3. **Instalar as dependências:**
   ```bash
   flutter pub get
   ```
4. **Executar o app em modo debug:**
   ```bash
   flutter run
   ```
5. **Permitir execução em segundo plano** nas configurações do dispositivo Android.

---

## 🧠 Como Contribuir

Este projeto faz parte de uma proposta acadêmica supervisionada por **Prof. Rafael Amorim**, mas contribuições e melhorias são bem-vindas!

1. Faça um **fork** do projeto.  
2. Crie uma **branch** para sua feature:
   ```bash
   git checkout -b minha-feature
   ```
3. Faça as alterações e **commits**:
   ```bash
   git commit -m "Adiciona nova funcionalidade"
   ```
4. Envie para seu fork:
   ```bash
   git push origin minha-feature
   ```
5. Abra um **Pull Request** descrevendo suas mudanças.



## 🧾 Licença

Este projeto está licenciado sob os termos da [MIT License](LICENSE.md).



## 📸 Captura de Tela




![enter image description here](https://raw.githubusercontent.com/santiz-es/mp3_player/refs/heads/main/assets/screen1.jpg)

> **Projeto acadêmico – Instituto Federal Sul-rio-grandense (IFSul) – Campus Santana do Livramento**  
> Professor responsável: **Rafael Amorim**  
> © 2025 – Todos os direitos reservados aos autores do projeto.

