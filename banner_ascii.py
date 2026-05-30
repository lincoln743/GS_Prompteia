"""
banner_ascii.py — Gerador de banner ASCII art da Mission Control AI.

Script auxiliar standalone para experimentar fontes e customizar o banner.

Uso:
  python banner_ascii.py                          # banner padrão
  python banner_ascii.py --fonts                  # lista as 570+ fontes do PyFiglet
  python banner_ascii.py --font slant --text "Mission Control AI"
  python banner_ascii.py --demo                   # mostra 8 fontes lado a lado
"""

import argparse

import pyfiglet
from rich.console import Console
from rich.align import Align
from rich.text import Text

console = Console()

FONTES_DEMO = [
    "ansi_shadow", "slant", "standard", "big",
    "banner3", "doom", "isometric1", "speed",
]


def banner_padrao():
    """Banner oficial do projeto, em ciano/verde estilo Claude Code."""
    linha1 = pyfiglet.figlet_format("Global Solution", font="ansi_shadow")
    linha2 = pyfiglet.figlet_format("EnviroSat", font="ansi_shadow")
    console.print(Align.center(Text(linha1, style="bold #A855F7")))
    console.print(Align.center(Text(linha2, style="bold #22C55E")))
    console.print(Align.center(
        Text("── 2026.1 · Prompt Engineering and AI · FIAP · Mission Control AI ──",
             style="italic #8484A0")
    ))


def listar_fontes():
    fontes = pyfiglet.FigletFont.getFonts()
    console.print(f"[bold]{len(fontes)} fontes disponíveis no PyFiglet:[/bold]\n")
    console.print(", ".join(sorted(fontes)))


def testar_fonte(font, text):
    try:
        arte = pyfiglet.figlet_format(text, font=font)
    except pyfiglet.FontNotFound:
        console.print(f"[red]Fonte '{font}' não encontrada. Use --fonts para listar.[/red]")
        return
    console.print(Text(arte, style="bold #06B6D4"))


def demonstrar():
    for fonte in FONTES_DEMO:
        console.print(f"[bold #8484A0]── fonte: {fonte} ──[/bold #8484A0]")
        try:
            console.print(Text(pyfiglet.figlet_format("Mission AI", font=fonte),
                               style="bold #22C55E"))
        except pyfiglet.FontNotFound:
            console.print(f"[red](fonte {fonte} indisponível)[/red]")


def main():
    parser = argparse.ArgumentParser(description="Gerador de banner ASCII da Mission Control AI.")
    parser.add_argument("--fonts", action="store_true", help="lista todas as fontes disponíveis")
    parser.add_argument("--font", type=str, help="testa uma fonte específica")
    parser.add_argument("--text", type=str, default="Mission Control AI", help="texto a renderizar")
    parser.add_argument("--demo", action="store_true", help="demonstra 8 fontes lado a lado")
    args = parser.parse_args()

    if args.fonts:
        listar_fontes()
    elif args.demo:
        demonstrar()
    elif args.font:
        testar_fonte(args.font, args.text)
    else:
        banner_padrao()


if __name__ == "__main__":
    main()
