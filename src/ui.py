"""
ui.py — Interface CLI estilo Claude Code (Rich + prompt-toolkit).

A camada de apresentação. run_cli(engine) recebe o motor, exibe o banner,
gerencia o loop de input e despacha cada pergunta para engine.analyze().

Comandos suportados:
  /help     — lista os comandos
  /status   — instantâneo da telemetria (sem IA)
  /cenario  — força um cenário de teste no próximo ciclo (ex.: /cenario incendio_intenso)
  /about    — sobre o projeto
  /clear    — limpa a tela
  /exit     — encerra
"""

from datetime import datetime

from rich.console import Console
from rich.panel import Panel
from rich.text import Text
from prompt_toolkit import PromptSession
from prompt_toolkit.styles import Style
import pyfiglet

from src import telemetria

console = Console()
session = PromptSession(style=Style.from_dict({"prompt": "#06B6D4 bold"}))

CENARIOS_VALIDOS = [
    "normal", "incendio_intenso", "falha_energia",
    "superaquecimento", "perda_downlink", "extremo",
]


def show_banner():
    """Exibe banner ASCII colorido no início."""
    banner = pyfiglet.figlet_format("EnviroSat", font="ansi_shadow")
    console.print(Text(banner, style="bold #22C55E"))
    console.print(Panel.fit(
        "Mission Control AI · Trilha EnviroSat (observação ambiental)\n"
        "Sistema de monitoramento e análise por IA generativa.\n"
        "Use /help para ver os comandos · /exit para sair.\n"
        "Modelo: gpt-oss:120b via Ollama Cloud",
        title="◆ MISSION CONTROL",
        subtitle="connected",
        border_style="#22C55E",
    ))


def show_response(text, titulo="◆ Mission Control", cor="#06B6D4"):
    """Renderiza resposta da IA em painel com timestamp."""
    now = datetime.now().strftime("%H:%M")
    console.print(Panel(text, title=titulo, subtitle=now, border_style=cor))


def _ajuda():
    console.print(Panel(
        "[bold]/help[/bold]     — esta ajuda\n"
        "[bold]/status[/bold]   — instantâneo da telemetria (sem IA)\n"
        "[bold]/cenario X[/bold] — força um cenário no próximo ciclo\n"
        f"             ({', '.join(CENARIOS_VALIDOS)})\n"
        "[bold]/about[/bold]    — sobre o projeto\n"
        "[bold]/clear[/bold]    — limpa a tela\n"
        "[bold]/exit[/bold]     — encerra\n\n"
        "Qualquer outra frase é enviada à IA para análise da missão.",
        title="◆ Comandos", border_style="#8484A0",
    ))


def _sobre():
    console.print(Panel(
        "Mission Control AI — Global Solution 2026.1 · FIAP\n"
        "Trilha EnviroSat: monitora a saúde de um satélite de observação\n"
        "ambiental e usa IA generativa para traduzir telemetria em decisões,\n"
        "sempre conectando o estado técnico ao impacto ambiental na Terra.",
        title="◆ Sobre", border_style="#8484A0",
    ))


def run_cli(engine):
    """Loop principal da CLI."""
    show_banner()
    if not engine.is_ready():
        console.print(" ⚠ Engine status: AGUARDANDO IMPLEMENTAÇÃO ✗\n", style="yellow")
    else:
        console.print(" ✓ Engine status: OPERACIONAL\n", style="green")

    while True:
        try:
            user_input = session.prompt("❯ ").strip()
        except (KeyboardInterrupt, EOFError):
            break

        if not user_input:
            continue

        if user_input == "/exit":
            console.print("Encerrando Mission Control. Até a próxima órbita. 🛰", style="#22C55E")
            break

        if user_input == "/help":
            _ajuda()
            continue

        if user_input == "/about":
            _sobre()
            continue

        if user_input == "/status":
            show_response(engine.status_snapshot(), titulo="◆ Telemetria", cor="#22C55E")
            continue

        if user_input == "/clear":
            console.clear()
            show_banner()
            continue

        if user_input.startswith("/cenario"):
            partes = user_input.split()
            if len(partes) == 2 and partes[1] in CENARIOS_VALIDOS:
                telemetria.forcar_cenario(partes[1])
                console.print(
                    f" → Cenário '{partes[1]}' será aplicado no próximo ciclo. "
                    f"Pergunte algo ou use /status.", style="yellow")
            else:
                console.print(
                    f" Uso: /cenario <{ '|'.join(CENARIOS_VALIDOS) }>", style="red")
            continue

        if user_input.startswith("/"):
            console.print(f" Comando desconhecido: {user_input}. Use /help.", style="red")
            continue

        # Qualquer outra entrada vai para o motor de análise.
        with console.status("[#06B6D4]Consultando a IA da missão...", spinner="dots"):
            resposta = engine.analyze(user_input)
        show_response(resposta)
