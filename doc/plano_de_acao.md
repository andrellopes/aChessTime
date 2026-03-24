# Plano de Ação - aChessTime (Rumo aos 10k Downloads)

Documento vivo de mapeamento técnico para a evolução do aplicativo de Xadrez.
O trabalho está metrificado para a dupla humano/IA operar em Sprints confortáveis de 4 horas focadas.

## Sprint 1 (Próximas 4 Horas) — Estabilização "Anti-Crash"
**Foco:** Garantir que 0% dos usuários atuais sofram fechamentos inesperados na nossa versão mais recente e prever atualizações futuras do Google.
- [ ] **Limpar Gaps Assíncronos:** O maior demônio invisível do Flutter. Caçar em `settings_screen.dart`, `statistics_service.dart`, e `chess_preset_selector.dart` todas as validações `!context.mounted` antes de chamarmos navegações após comandos Firebase/Storage `await`. (Risco de fechamento na cara do usuário).
- [ ] **Erradicar o `.withOpacity`:** Fazer uma alteração raiz de 120+ alertas de depreciação visual migrando para `.withValues(alpha: x)` em todos os widgets para garantir compilação lisa no Flutter 4 futuramente.
- [ ] **Testes de Integração:** Validar o AppReviewService recém inserido rodando localmente via emulação final.

## Sprint 2 (Mais 4 Horas) — Quebra do Monolito Visual (Refatoração UI)
**Foco:** Organizar os arquivos mortais que inviabilizam upgrades de design pela dupla.
- [ ] **Desfazer o `settings_screen.dart`:** O arquivo beira 1.000 linhas. Precisamos recortá-lo em 4 ou 5 micro-widgets em arquivos limpos: Ex: `audio_settings_widget.dart`, `game_mode_settings_widget.dart`.
- [ ] **Desfazer o `center_controls.dart`:** Passou de 600 linhas. Separar botões dos menus flutuantes.
- [ ] **Clean Architecture de Componentes:** Transformar componentes visuais comuns numa pasta `design_system` fechadinha para cores/margens.

## Sprint 3 (Mais 4 Horas) — "Game Juice" (Retenção e Polimento)
**Foco:** Fazer o aplicativo não apenas rodar tecnicamente bem, mas ser **gostoso** de se apertar.
- [ ] **Micro-animações:** Uma transição sutil no cronômetro da tela cheia ou o botão pulsar levemente quando os últimos 10 segundos iniciarem, passando a sensação de urgência real.
- [ ] **Haptics Avançados:** Além do atual e excelente "vibrar", implementar ritmos de vibração imersivos para as 3 jogadas finais (coração pulsando).
- [ ] **Revisão dos Modais de Diálogo:** Uniformizar os popups de `ProUpgrade`, e padronizar o efeito vidro/esfumaçado nos diálogos para passarem o DNA Premium do app.

## Sprint 4 (Mais 4 Horas) — Monetização e Retenção Analytics
**Foco:** Converter os 1.000 usuários grátis em Receita e Escala.
- [ ] **Auditar Funil Pro:** Revisar a mensagem que convida o usuário a ser _Pro_ no `pro_upgrade_dialog.dart`, talvez adicionando comparativos Lado-a-Lado e tirando o peso de "compre!".
- [ ] **Otimização de Compartilhamento:** O CSV atual que gera de estatísticas não viraliza pelo WhatsApp. A melhoria é gerar uma imagem PNG (um _Board_ customizado) para ele mandar pro amigo "Te venci em 15 minutos".
- [ ] **Push "Silencioso":** Adicionar Notificação local offline do Device caso ele esteja a 1 semana sem treinar (ex: "Bora treinar as aberturas neste final de semana?").
