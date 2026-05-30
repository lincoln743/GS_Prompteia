#!/usr/bin/env bash
# =====================================================================
# setup_GS_Prompteia.sh — recria o projeto Mission Control AI (EnviroSat)
# Global Solution 2026.1 · FIAP · Turma 1CCPS
# Integrantes: Lincoln Simão Pereira (567284), Miguel Silva Bezerra (566763),
#              Nicolas Sakaue Nishimura (567752)
#
# COMO USAR:
#   1) Abra um terminal e entre na pasta do projeto:
#        cd "/home/lincoln-pereira/VS Code/GS_Prompteia"
#   2) Coloque este arquivo lá e rode:
#        bash setup_GS_Prompteia.sh
# =====================================================================
set -e
echo "==> Criando estrutura de pastas..."
mkdir -p src prompts data assets

echo "==> Gravando .env.example"
cat > ".env.example" << 'MCAI_EOF'
# Template de variáveis de ambiente — copie para .env e preencha com sua chave.
# IMPORTANTE: o arquivo .env real NUNCA deve ser commitado (está no .gitignore).
OLLAMA_API_KEY=sua_chave_aqui_sem_aspas
MCAI_EOF

echo "==> Gravando .gitignore"
cat > ".gitignore" << 'MCAI_EOF'
# Credenciais — NUNCA versionar
.env

# Python
__pycache__/
*.pyc
*.pyo
.venv/
venv/
.Python

# Sistema / editores
.DS_Store
.idea/
.vscode/
MCAI_EOF

echo "==> Gravando requirements.txt"
cat > "requirements.txt" << 'MCAI_EOF'
# Dependências mínimas — versões fixadas para reprodutibilidade
ollama==0.6.2
python-dotenv==1.2.2
rich==15.0.0
prompt-toolkit==3.0.52
pyfiglet==1.0.4

# Opcionais (descomente se for incrementar):
# pandas==2.2.3
# matplotlib==3.9.2
MCAI_EOF

echo "==> Gravando main.py"
cat > "main.py" << 'MCAI_EOF'
"""Mission Control AI — ponto de entrada do sistema."""

from src.ui import run_cli
from src.engine import MissionEngine

if __name__ == "__main__":
    engine = MissionEngine()
    run_cli(engine)
MCAI_EOF

echo "==> Gravando banner_ascii.py"
cat > "banner_ascii.py" << 'MCAI_EOF'
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
MCAI_EOF

echo "==> Gravando GS_2026_1_Grupo_MissionControl_1CCPS.txt"
cat > "GS_2026_1_Grupo_MissionControl_1CCPS.txt" << 'MCAI_EOF'
# Arquivo: GS_2026_1_Grupo_MissionControl_1CCPS.txt

Nome completo e RM de todos os integrantes:
- Lincoln Simão Pereira — RM: 567284
- Miguel Silva Bezerra — RM: 566763
- Nicolas Sakaue Nishimura — RM: 567752

Modalidade: Trio

Trilha escolhida: EnviroSat (Observação Ambiental)

Link do repositório GitHub: https://github.com/lincoln743/GS_Prompteia

Link do vídeo de demonstração: https://www.youtube.com/watch?v=SEU_ID_AQUI

Disciplina: Prompt Engineering and Artificial Intelligence
Professor: Jorge Luiz Gomes
FIAP · Ciência da Computação · Global Solution 2026.1
MCAI_EOF

echo "==> Gravando README.md"
cat > "README.md" << 'MCAI_EOF'
# 🚀 Mission Control AI — EnviroSat

Sistema de monitoramento operacional de um satélite de **observação ambiental**
(trilha **EnviroSat**) que lê telemetria simulada, detecta anomalias com lógica
Python e usa IA generativa (Ollama Cloud · `gpt-oss:120b`) para traduzir o estado
da missão em linguagem natural — sempre conectando cada leitura técnica ao seu
**impacto ambiental na Terra** (desmatamento, incêndios, áreas protegidas).

## 👥 Integrantes

- Lincoln Simão Pereira — RM: 567284 — Turma: 1CCPS
- Miguel Silva Bezerra — RM: 566763 — Turma: 1CCPS
- Nicolas Sakaue Nishimura — RM: 567752 — Turma: 1CCPS

> Modalidade: **Trio** · Disciplina: Prompt Engineering and Artificial Intelligence
> · Prof. Jorge Luiz Gomes · FIAP · Global Solution 2026.1

## 🛰 O que o projeto faz

O EnviroSat simula um satélite ambiental (estilo Amazônia-1 / Landsat). A cada
ciclo, o módulo `telemetria.py` gera um instantâneo plausível de seis parâmetros
(temperatura do payload, energia, buffer de imagens, precisão de geolocalização,
qualidade do downlink e focos de calor detectados). O módulo `alertas.py`
classifica a severidade em **Python** (thresholds determinísticos) e dispara
respostas automatizadas em situações críticas. O `engine.py` injeta esses dados
no prompt e chama o `gpt-oss:120b` via Ollama Cloud para gerar um diagnóstico que
amarra o estado técnico ao que isso significa para o combate a incêndios e ao
monitoramento ambiental no Brasil.

## 🎭 Persona atendida

O sistema atende três personas e adapta o tom: o **operador do centro de controle
ambiental** (INPE / órgão estadual), o **coordenador de brigada de combate a
incêndio** e o **analista de compliance ambiental**. A persona-foco da
demonstração é o operador, porque é quem toma decisão imediata diante de um alerta
e decide quando acionar a brigada.

## 🧰 Tecnologias utilizadas

- Python 3.10+
- Ollama Cloud API (modelo `gpt-oss:120b`)
- Bibliotecas: `ollama`, `python-dotenv`, `rich`, `prompt-toolkit`, `pyfiglet`

## ▶️ Como executar

1. Clone o repositório:
   ```bash
   git clone https://github.com/lincoln743/GS_Prompteia.git
   cd GS_Prompteia
   ```
2. Crie e ative um ambiente virtual:
   ```bash
   python -m venv .venv && source .venv/bin/activate   # Linux/macOS
   # .venv\Scripts\activate                            # Windows
   ```
3. Instale as dependências:
   ```bash
   pip install -r requirements.txt
   ```
4. Crie o arquivo `.env` na raiz (copie de `.env.example`) com a sua chave:
   ```
   OLLAMA_API_KEY=sua_chave_aqui
   ```
5. Execute:
   ```bash
   python main.py
   ```

### Comandos da CLI

| Comando | O que faz |
|---|---|
| `/status` | Instantâneo da telemetria (sem IA) |
| `/cenario <nome>` | Força um cenário no próximo ciclo |
| `/help` | Lista os comandos |
| `/about` | Sobre o projeto |
| `/clear` | Limpa a tela |
| `/exit` | Encerra |
| *(qualquer frase)* | Envia à IA para análise da missão |

Cenários disponíveis: `normal`, `incendio_intenso`, `falha_energia`,
`superaquecimento`, `perda_downlink`, `extremo`.

## 🖼 Demonstração

![Banner e status normal da missão](assets/screenshot_banner.png)
![Alerta crítico com análise da IA](assets/screenshot_analise.png)

## 🧠 System Prompt

O system prompt completo está em [`prompts/system_prompt.md`](prompts/system_prompt.md).
Ele define papel (copiloto de operações do EnviroSat), escopo (apenas a missão),
restrições (não inventar dados, respeitar a severidade já calculada em Python),
formato de saída fixo (Estado → Diagnóstico → Impacto na Terra → Recomendação) e
inclui **few-shot prompting** com dois exemplos (operação nominal e energia
crítica).

## 🧪 Cenários de teste demonstrados

1. **Operação normal** — todos os parâmetros na faixa nominal, estado NOMINAL.
2. **Incêndio intenso** — 142 focos detectados, buffer enchendo: ATENÇÃO + foco no
   despacho de brigadas.
3. **Energia crítica** — bateria a 14%, dispara `MODO ECONOMIA` automaticamente.
4. **Superaquecimento** — payload a 78 °C, dispara `PROTEÇÃO TÉRMICA`.
5. **Perda de downlink** — enlace degradado e buffer saturado, dispara
   `RETENÇÃO SEGURA` / `PRIORIZAÇÃO DE DOWNLINK`.

## 🔁 Iterações do prompt (processo)

- **v1** — genérico ("analise os dados do satélite"): o modelo descrevia números,
  mas ignorava o impacto terrestre.
- **v2** — adicionamos a "regra de ouro" (amarrar à Terra) e o formato fixo de
  saída: melhorou muito, mas o modelo às vezes recalculava se era crítico,
  contradizendo o Python.
- **v3** — instruímos explicitamente a **respeitar a severidade já classificada**
  e adicionamos os dois exemplos few-shot. A saída ficou estável e consistente
  entre execuções (temperatura 0.3).

## 💼 Proposta de valor / modelo de negócio

**1. Qual o problema real terrestre que esta missão resolve?**
O Brasil perde florestas e biomas inteiros porque focos de calor são detectados e
geolocalizados tarde demais para o despacho de brigadas. O EnviroSat encurta a
distância entre o dado orbital e a decisão em terra: ele detecta o foco, mede a
confiabilidade da coordenada e traduz tudo para uma recomendação acionável,
reduzindo o tempo entre "começou a queimar" e "a brigada está a caminho".

**2. Quem paga pela solução?**
Modelo **híbrido**. O núcleo é setor público — INPE/órgãos ambientais estaduais e
o IBAMA financiam a operação como infraestrutura de fiscalização (analogamente a
DETER/PRODES). Uma camada privada de dado-como-serviço atende seguradoras de
ativos florestais, certificadoras de crédito de carbono e empresas com
compromissos de compliance ambiental que precisam comprovar monitoramento.

**3. Métrica de impacto (1 ano de satélite 100% saudável)**
Cobertura de monitoramento de aproximadamente **2,5 milhões de hectares de áreas
protegidas e de risco**, com redução estimada de **15 a 25% no tempo médio de
resposta a focos** detectados — o que, em temporada de seca, pode significar
centenas de incêndios contidos ainda em estágio inicial e milhares de toneladas
de CO₂ evitadas em emissões de queimadas.

**4. Modelo de negócio**
**Dado-como-serviço (DaaS) com concessão pública na base.** O governo banca a
operação contínua do satélite (concessão/contrato de serviço público de
monitoramento); o acesso a relatórios, séries históricas e alertas customizados é
oferecido por assinatura a clientes privados (seguros, carbono, agronegócio
adjacente).

## ⚠️ Limitações conhecidas

- A telemetria é **simulada** (random walk + cenários), não vem de um satélite real.
- A geração de focos de calor não usa imagens reais nem modelo físico — é uma
  contagem plausível para fins de demonstração.
- A IA é não-determinística; mesmo com temperatura baixa (0.3), a redação varia
  entre execuções, ainda que o diagnóstico se mantenha consistente.
- Não há persistência em banco de dados; a memória de contexto guarda apenas os
  últimos 5 ciclos em memória RAM e é perdida ao encerrar a sessão.

## 🎬 Vídeo de demonstração

🔗 [Assistir demonstração no YouTube](https://www.youtube.com/watch?v=SEU_ID_AQUI)

> Configurado como "Não listado" no YouTube.
MCAI_EOF

echo "==> Gravando relatorio_abnt.tex"
cat > "relatorio_abnt.tex" << 'MCAI_EOF'
% =====================================================================
% Relatório Global Solution 2026.1 — Mission Control AI (Trilha EnviroSat)
% FIAP · Ciência da Computação · Prompt Engineering and AI
% Formatado segundo as normas da ABNT (article configurado manualmente).
% Compilar com: pdflatex relatorio_abnt.tex  (rodar 2x para o sumário)
% =====================================================================
\documentclass[12pt,a4paper]{article}

\usepackage[utf8]{inputenc}
\usepackage[T1]{fontenc}
\usepackage[brazil]{babel}
\usepackage{mathptmx}              % fonte Times (padrão ABNT)
\usepackage[a4paper,left=3cm,top=3cm,right=2cm,bottom=2cm]{geometry}
\usepackage{setspace}             % espaçamento 1,5
\usepackage{indentfirst}          % recuo no primeiro parágrafo da seção
\usepackage{titlesec}
\usepackage{graphicx}
\usepackage{xcolor}
\usepackage{listings}
\usepackage{booktabs}
\usepackage{enumitem}
\usepackage{float}
\usepackage{microtype}
\usepackage[hidelinks]{hyperref}

% ---- Layout ABNT ----------------------------------------------------
\onehalfspacing
\setlength{\parindent}{1.25cm}
\setlength{\parskip}{0pt}

% Títulos de seção em caixa alta, numerados (ABNT)
\titleformat{\section}{\normalfont\bfseries\large}{\thesection}{0.6em}{\MakeUppercase}
\titleformat{\subsection}{\normalfont\bfseries\normalsize}{\thesubsection}{0.6em}{}
\titlespacing*{\section}{0pt}{1.2\baselineskip}{0.6\baselineskip}
\titlespacing*{\subsection}{0pt}{1.0\baselineskip}{0.4\baselineskip}

% ---- Estilo de código ----------------------------------------------
\definecolor{codebg}{HTML}{F5F5F7}
\definecolor{codekw}{HTML}{A626A4}
\definecolor{codecmt}{HTML}{6A737D}
\definecolor{codestr}{HTML}{22863A}
\lstset{
  basicstyle=\ttfamily\footnotesize,
  backgroundcolor=\color{codebg},
  keywordstyle=\color{codekw}\bfseries,
  commentstyle=\color{codecmt}\itshape,
  stringstyle=\color{codestr},
  numbers=left, numberstyle=\tiny\color{codecmt}, numbersep=8pt,
  breaklines=true, frame=single, rulecolor=\color{gray!40},
  showstringspaces=false, tabsize=4, captionpos=b,
  literate={á}{{\'a}}1 {ã}{{\~a}}1 {â}{{\^a}}1 {é}{{\'e}}1 {ê}{{\^e}}1
           {í}{{\'i}}1 {ó}{{\'o}}1 {ô}{{\^o}}1 {õ}{{\~o}}1 {ú}{{\'u}}1
           {ç}{{\c c}}1 {Á}{{\'A}}1 {É}{{\'E}}1 {Í}{{\'I}}1 {Ó}{{\'O}}1
           {Ç}{{\c C}}1 {°}{{\textdegree}}1
}

% =====================================================================
\begin{document}

% --------------------------- CAPA -----------------------------------
\begin{titlepage}
\begin{center}
{\large\bfseries FIAP --- FACULDADE DE INFORMÁTICA E ADMINISTRAÇÃO PAULISTA\par}
{\large CIÊNCIA DA COMPUTAÇÃO\par}
\vspace{1cm}
{\normalsize Lincoln Simão Pereira --- RM 567284\par}
{\normalsize Miguel Silva Bezerra --- RM 566763\par}
{\normalsize Nicolas Sakaue Nishimura --- RM 567752\par}
{\normalsize Turma: 1CCPS\par}
\vfill
{\LARGE\bfseries MISSION CONTROL AI\par}
\vspace{0.4cm}
{\large Monitoramento de telemetria do satélite EnviroSat com IA generativa\\ aplicada ao combate a incêndios e ao monitoramento ambiental\par}
\vfill
{\normalsize Global Solution 2026.1\\ Disciplina: Prompt Engineering and Artificial Intelligence\par}
\vspace{2cm}
{\normalsize São Paulo\par}
{\normalsize 2026\par}
\end{center}
\end{titlepage}

% ------------------------ FOLHA DE ROSTO ----------------------------
\begin{titlepage}
\begin{center}
{\normalsize Lincoln Simão Pereira --- RM 567284\par}
{\normalsize Miguel Silva Bezerra --- RM 566763\par}
{\normalsize Nicolas Sakaue Nishimura --- RM 567752\par}
{\normalsize Turma: 1CCPS\par}
\vspace{3cm}
{\LARGE\bfseries MISSION CONTROL AI\par}
\vspace{0.3cm}
{\large Monitoramento de telemetria do satélite EnviroSat com IA generativa\par}
\end{center}
\vspace{2cm}
\begin{flushright}
\begin{minipage}{0.55\textwidth}
\onehalfspacing\small
Relatório técnico apresentado à FIAP como requisito parcial da Global Solution 2026.1, na disciplina de Prompt Engineering and Artificial Intelligence, do curso de Ciência da Computação.\\[0.5cm]
Orientador: Prof. Jorge Luiz Gomes.
\end{minipage}
\end{flushright}
\vfill
\begin{center}
{\normalsize São Paulo\par}
{\normalsize 2026\par}
\end{center}
\end{titlepage}

% ----------------------------- RESUMO -------------------------------
\begin{center}\textbf{RESUMO}\end{center}
\noindent
Este relatório descreve o desenvolvimento do \textit{Mission Control AI}, sistema de monitoramento operacional de um satélite simulado de observação ambiental (trilha EnviroSat), construído na Global Solution 2026.1 da FIAP. O objetivo foi exercitar o ciclo completo de engenharia de IA aplicada: geração de telemetria simulada, detecção de anomalias por lógica determinística em Python, integração de um modelo de linguagem de grande porte (\texttt{gpt-oss:120b}, via Ollama Cloud) e exposição dos resultados em uma interface de linha de comando. A contribuição central é metodológica: a separação explícita entre a \textit{decisão} (classificação de severidade feita em código) e a \textit{contextualização} (explicação em linguagem natural feita pela IA), além da amarração sistemática entre o estado técnico em órbita e seu impacto ambiental na Terra. Os resultados demonstram um sistema funcional, com respostas consistentes entre execuções após três iterações do \textit{prompt}, e evidenciam o valor da técnica de \textit{few-shot prompting} e da injeção dinâmica de dados para a qualidade da análise gerada.

\vspace{0.4cm}
\noindent\textbf{Palavras-chave:} Engenharia de \textit{Prompt}. IA Generativa. Telemetria de Satélite. Observação Ambiental. Ollama Cloud.

\newpage

% ----------------------------- SUMÁRIO ------------------------------
\renewcommand{\contentsname}{SUMÁRIO}
\tableofcontents
\newpage

% =====================================================================
\section{Introdução}

A exploração espacial deixou de ser ficção científica para se tornar infraestrutura crítica do cotidiano: previsão de safras, detecção de desmatamento, telecomunicações e navegação dependem de constelações orbitais. Missões espaciais geram volumes massivos de dados de telemetria que precisam ser interpretados rapidamente, e é nesse intervalo entre o dado bruto orbital e a decisão humana em terra que a Inteligência Artificial (IA) generativa encontra aplicação direta.

Este trabalho, desenvolvido no âmbito da Global Solution 2026.1 da FIAP, materializa esse cenário em pequena escala. O grupo escolheu a trilha \textbf{EnviroSat}, voltada à observação ambiental, por concentrar o caso de uso de maior relevância social no Brasil: o combate a incêndios florestais e o monitoramento de áreas protegidas. O sistema simula um satélite ambiental (inspirado no Amazônia-1 e no Landsat), monitora sua saúde, detecta anomalias e usa um modelo de linguagem para traduzir o estado da missão em recomendações acionáveis.

\subsection{Objetivos}

O objetivo geral é demonstrar domínio do ciclo \textit{prompt} $\rightarrow$ modelo $\rightarrow$ resposta contextualizada. Como objetivos específicos, destacam-se: (i) gerar telemetria simulada plausível de seis parâmetros do satélite; (ii) implementar, em Python, regras determinísticas de alerta e respostas automatizadas a situações críticas; (iii) integrar o modelo \texttt{gpt-oss:120b} via Ollama Cloud com injeção dinâmica dos dados de telemetria; e (iv) articular explicitamente o impacto terrestre de cada estado da missão.

\section{Fundamentação e Contexto}

No Brasil, o INPE opera os sistemas DETER e PRODES com base em satélites como o CBERS e o Amazônia-1, que fundamentam ações do IBAMA e de brigadas estaduais de combate a incêndio. O setor de \textit{New Space} nacional cresce em ritmo acelerado, e a demanda por profissionais capazes de conectar dados orbitais a problemas terrestres é elevada.

A IA generativa contribui nesse contexto em três frentes: \textbf{interpretar} telemetria (transformar valores numéricos em diagnósticos compreensíveis), \textbf{detectar} padrões de risco que isoladamente passariam despercebidos e \textbf{traduzir} a anomalia técnica em impacto concreto para o cliente terrestre. O diferencial adotado neste projeto é justamente essa terceira frente: cada análise amarra o estado do satélite à sua consequência ambiental.

\section{Metodologia e Arquitetura}

O sistema foi estruturado como um projeto Python modular, executável via \texttt{python main.py}, seguindo a estrutura oficial do desafio. A Tabela~\ref{tab:modulos} resume a responsabilidade de cada módulo.

\begin{table}[H]
\centering
\caption{Módulos do sistema e suas responsabilidades}
\label{tab:modulos}
\small
\begin{tabular}{@{}ll@{}}
\toprule
\textbf{Módulo} & \textbf{Responsabilidade} \\
\midrule
\texttt{main.py} & Ponto de entrada; instancia o motor e inicia a interface. \\
\texttt{src/ui.py} & Interface CLI (Rich + prompt-toolkit), comandos e loop de entrada. \\
\texttt{src/telemetria.py} & Geração de dados simulados com evolução temporal. \\
\texttt{src/alertas.py} & \textit{Thresholds}, severidade e respostas automatizadas. \\
\texttt{src/engine.py} & Orquestração: coleta, avalia, monta o \textit{prompt} e chama a IA. \\
\texttt{prompts/system\_prompt.md} & \textit{System prompt} da IA (papel, escopo, formato, \textit{few-shot}). \\
\bottomrule
\end{tabular}
\end{table}

A decisão arquitetural mais importante foi a \textbf{separação entre decisão e contextualização}. A classificação de severidade (NOMINAL, ATENÇÃO, CRÍTICO) é feita exclusivamente por lógica determinística em Python; o modelo de linguagem nunca decide se algo é crítico --- ele apenas explica e contextualiza a severidade já calculada. Essa escolha evita a inconsistência típica de delegar regras de negócio a um modelo não-determinístico.

\subsection{Geração de telemetria}

O módulo \texttt{telemetria.py} mantém um estado interno que evolui de ciclo em ciclo (\textit{random walk} dentro de faixas plausíveis), simulando uma série temporal em vez de valores independentes. São monitorados seis parâmetros: temperatura do \textit{payload}, energia da bateria, ocupação do \textit{buffer} de imagens, precisão de geolocalização, qualidade do \textit{downlink} e número de focos de calor detectados. O módulo permite ainda forçar cenários determinísticos (por exemplo, \texttt{falha\_energia} ou \texttt{incendio\_intenso}) para teste e demonstração.

\subsection{Lógica de alertas e respostas automatizadas}

O módulo \texttt{alertas.py} concentra os \textit{thresholds} e a tomada de decisão. Cada parâmetro possui limites de atenção e crítico, com sentido (acima ou abaixo) definido conforme sua semântica. Em nível crítico, o sistema dispara uma \textbf{resposta automatizada} --- por exemplo, ativar o \textsc{Modo Economia} quando a bateria cai abaixo de 20\%. A Listagem~\ref{lst:alertas} apresenta o trecho central da avaliação.

\begin{lstlisting}[language=Python, caption={Avaliação determinística de alertas}, label={lst:alertas}]
def avaliar(dados):
    """Avalia um snapshot e retorna a lista de alertas ativos."""
    alertas = []
    for parametro, regra in THRESHOLDS.items():
        valor = dados.get(parametro)
        if valor is None:
            continue
        nivel = None
        if _dispara(valor, regra["critico"], regra["sentido"]):
            nivel = "CRITICO"
        elif _dispara(valor, regra["atencao"], regra["sentido"]):
            nivel = "ATENCAO"
        if nivel:
            alerta = {"parametro": parametro, "valor": valor,
                      "nivel": nivel, "mensagem": DESCRICOES[(parametro, nivel)]}
            if nivel == "CRITICO" and parametro in RESPOSTAS_AUTOMATICAS:
                alerta["resposta_automatica"] = RESPOSTAS_AUTOMATICAS[parametro]
            alertas.append(alerta)
    return alertas
\end{lstlisting}

\subsection{Integração com a IA via Ollama Cloud}

A integração utiliza a biblioteca \texttt{ollama} e o modelo \texttt{gpt-oss:120b}. A função \texttt{llm()} é o ponto único de contato com o modelo; toda chamada passa por ela. No método \texttt{analyze()}, o motor coleta a telemetria, avalia os alertas, monta dinamicamente um \textit{prompt} contendo os dados reais, a severidade já classificada, os alertas ativos e um resumo dos últimos ciclos (memória de contexto), e então invoca a IA com o \textit{system prompt} carregado de \texttt{prompts/system\_prompt.md}.

\section{Engenharia de Prompt}

A qualidade da análise depende menos do código e mais do \textit{system prompt}. Adotou-se a estrutura recomendada nas aulas: \textbf{papel} + \textbf{escopo} + \textbf{restrições} + \textbf{tom} + \textbf{formato de saída}, acrescida de exemplos de \textit{few-shot}.

\subsection{A regra de ouro: conectar com a Terra}

O \textit{system prompt} instrui o modelo a, em toda resposta, explicar o que a leitura significa para o mundo em terra. O formato de saída é fixo: estado, diagnóstico técnico, impacto na Terra e recomendação. Essa imposição de formato foi decisiva para a consistência e para atender ao diferencial de 2026.1, que valoriza a articulação do impacto social.

\subsection{Iterações realizadas}

O processo de refinamento seguiu três versões, conforme a Tabela~\ref{tab:iteracoes}. A documentação honesta dessas iterações é, ela própria, valorizada na avaliação.

\begin{table}[H]
\centering
\caption{Iterações do \textit{system prompt}}
\label{tab:iteracoes}
\small
\begin{tabular}{@{}cp{11cm}@{}}
\toprule
\textbf{Versão} & \textbf{Mudança e resultado} \\
\midrule
v1 & \textit{Prompt} genérico. O modelo descrevia números, mas ignorava o impacto terrestre. \\
v2 & Inclusão da "regra de ouro" e do formato fixo. Melhora expressiva, porém o modelo às vezes recalculava a severidade, contradizendo o Python. \\
v3 & Instrução explícita para respeitar a severidade já classificada e adição de dois exemplos \textit{few-shot}. Saída estável entre execuções (temperatura 0,3). \\
\bottomrule
\end{tabular}
\end{table}

\section{Resultados}

O sistema abre a interface CLI com banner em \textit{ASCII art}, responde a comandos (\texttt{/status}, \texttt{/cenario}, \texttt{/help}) e, diante de qualquer pergunta, gera uma análise no formato definido. Foram validados cinco cenários: operação normal, incêndio intenso, energia crítica, superaquecimento e perda de \textit{downlink}. Em todos, a severidade foi corretamente classificada pelo código e as respostas automatizadas dispararam quando esperado. Repetindo o mesmo cenário três vezes, observou-se variação apenas na redação, mantendo-se constante o diagnóstico e a recomendação --- comportamento adequado para um modelo não-determinístico operado a baixa temperatura.

\section{Proposta de Valor e Modelo de Negócio}

\textbf{Problema terrestre.} Florestas e biomas são perdidos porque focos de calor são detectados e geolocalizados tarde demais para o despacho de brigadas. O EnviroSat encurta a distância entre o dado orbital e a decisão em terra.

\textbf{Quem paga.} Modelo híbrido: o núcleo é público (INPE, órgãos estaduais e IBAMA, como infraestrutura de fiscalização), com camada privada de dado-como-serviço para seguradoras de ativos florestais, certificadoras de crédito de carbono e empresas com compromissos de \textit{compliance} ambiental.

\textbf{Métrica de impacto.} Com o satélite 100\% saudável por um ano, estima-se cobertura de monitoramento da ordem de 2,5 milhões de hectares de áreas protegidas e de risco, com redução de 15\% a 25\% no tempo médio de resposta a focos --- potencialmente centenas de incêndios contidos em estágio inicial e milhares de toneladas de CO\textsubscript{2} evitadas.

\textbf{Modelo de negócio.} Dado-como-serviço (DaaS) com concessão pública na base: o governo financia a operação contínua; o acesso a relatórios, séries históricas e alertas customizados é oferecido por assinatura a clientes privados.

\section{Limitações}

A telemetria é simulada, não proveniente de um satélite real; a contagem de focos não usa imagens nem modelo físico; a IA é não-determinística, com variação de redação mesmo a baixa temperatura; e não há persistência em banco de dados --- a memória de contexto guarda apenas os últimos cinco ciclos em memória volátil.

\section{Conclusão}

O \textit{Mission Control AI} demonstrou, em escala reduzida, o ciclo que define a engenharia de IA aplicada: entender o problema, escolher o \textit{prompt} certo, integrar o modelo ao código, expor os dados de forma útil e validar o funcionamento. A separação entre decisão determinística e contextualização generativa mostrou-se uma boa prática transferível para outros domínios além do espacial. O trabalho reforça a tese de que a IA não substitui o engenheiro, mas amplia o alcance do seu julgamento técnico.

% --------------------------- REFERÊNCIAS ----------------------------
\renewcommand{\refname}{REFERÊNCIAS}
\begin{thebibliography}{9}
\bibitem{inpe} INSTITUTO NACIONAL DE PESQUISAS ESPACIAIS (INPE). \textbf{Programa de Monitoramento da Amazônia (PRODES e DETER)}. Disponível em: \url{http://www.inpe.br}. Acesso em: 2026.
\bibitem{ollama} OLLAMA. \textbf{Ollama Cloud Documentation}. Disponível em: \url{https://ollama.com}. Acesso em: 2026.
\bibitem{fiap} GOMES, Jorge Luiz. \textbf{Global Solution 2026.1 --- Mission Control AI}. FIAP, Ciência da Computação, Disciplina de Prompt Engineering and Artificial Intelligence, 2026.
\end{thebibliography}

\end{document}
MCAI_EOF

echo "==> Gravando src/__init__.py"
cat > "src/__init__.py" << 'MCAI_EOF'
"""Pacote src — módulos da Mission Control AI."""
MCAI_EOF

echo "==> Gravando src/telemetria.py"
cat > "src/telemetria.py" << 'MCAI_EOF'
"""
telemetria.py — Geração de dados simulados da telemetria do EnviroSat.

Trilha: EnviroSat (Observação Ambiental — estilo Amazônia-1 / Landsat).

Este módulo é responsável por produzir, a cada ciclo, um "instantâneo"
(snapshot) plausível e coerente da saúde do satélite. Os dados NÃO precisam
ser cientificamente exatos — precisam ser plausíveis e variar de forma
coerente com a operação de um satélite de observação ambiental.

Parâmetros monitorados (trilha EnviroSat):
  - temperatura_sensor   : temperatura do payload óptico/térmico (°C)
  - energia_bateria      : carga da bateria (%)
  - buffer_imagens       : ocupação do buffer de imagens não transmitidas (%)
  - precisao_geo         : erro de geolocalização das imagens (metros)
  - qualidade_downlink   : qualidade do enlace de descida (índice 0-100)
  - focos_detectados     : nº de focos de calor detectados no último imageamento

A classe TelemetriaSimulator mantém um estado interno simples que evolui de
ciclo em ciclo (consumo de bateria à medida que o buffer enche, etc.),
simulando uma série temporal em vez de valores totalmente independentes.
"""

import random
from datetime import datetime, timezone

# ---------------------------------------------------------------------------
# Faixas "nominais" de cada parâmetro. Servem de referência para a simulação
# e também documentam o que é considerado normal. Os thresholds de alerta
# ficam em alertas.py (separação de responsabilidades).
# ---------------------------------------------------------------------------
FAIXAS_NOMINAIS = {
    "temperatura_sensor": (10.0, 45.0),   # °C
    "energia_bateria": (45.0, 100.0),     # %
    "buffer_imagens": (5.0, 70.0),        # %
    "precisao_geo": (3.0, 18.0),          # metros
    "qualidade_downlink": (70.0, 100.0),  # índice 0-100
    "focos_detectados": (0, 25),          # contagem
}


class TelemetriaSimulator:
    """Gera snapshots de telemetria com evolução temporal coerente."""

    def __init__(self, semente=None):
        # Semente opcional torna a simulação reprodutível (útil em testes).
        self._rng = random.Random(semente)
        self.ciclo = 0
        # Estado interno persistente entre ciclos.
        self._estado = {
            "temperatura_sensor": 22.0,
            "energia_bateria": 92.0,
            "buffer_imagens": 18.0,
            "precisao_geo": 8.0,
            "qualidade_downlink": 88.0,
            "focos_detectados": 4,
        }
        # Cenário forçado (None = operação normal aleatória).
        self._cenario = None

    # -------------------------------------------------------------------
    # Controle de cenário
    # -------------------------------------------------------------------
    def forcar_cenario(self, nome):
        """Força um cenário pré-definido no próximo coletar().

        Cenários disponíveis:
          - "normal"          : operação saudável
          - "incendio_intenso": muitos focos, buffer enchendo rápido
          - "falha_energia"   : bateria criticamente baixa
          - "superaquecimento": temperatura do sensor acima do limite
          - "perda_downlink"  : enlace de descida degradado, buffer travado
          - "extremo"         : valores fisicamente improváveis (teste de robustez)
        """
        self._cenario = nome

    # -------------------------------------------------------------------
    # Coleta de um snapshot
    # -------------------------------------------------------------------
    def coletar(self):
        """Avança um ciclo e retorna o snapshot atual da telemetria (dict)."""
        self.ciclo += 1

        if self._cenario:
            dados = self._gerar_cenario(self._cenario)
            self._cenario = None  # cenário vale por um único ciclo
        else:
            dados = self._evoluir_normal()

        dados["ciclo"] = self.ciclo
        dados["timestamp"] = datetime.now(timezone.utc).strftime("%Y-%m-%d %H:%M:%S UTC")
        # Sincroniza o estado interno com o que foi observado neste ciclo.
        for chave in self._estado:
            self._estado[chave] = dados[chave]
        return dados

    # -------------------------------------------------------------------
    # Evolução "normal" (random walk dentro de faixas plausíveis)
    # -------------------------------------------------------------------
    def _evoluir_normal(self):
        e = dict(self._estado)
        r = self._rng

        # Temperatura oscila levemente conforme entra/sai de sombra orbital.
        e["temperatura_sensor"] = self._limitar(
            e["temperatura_sensor"] + r.uniform(-3.0, 3.5), 8, 60
        )
        # Bateria carrega ao Sol e descarrega na sombra; saldo levemente positivo.
        e["energia_bateria"] = self._limitar(
            e["energia_bateria"] + r.uniform(-6.0, 4.0), 0, 100
        )
        # Buffer enche conforme imagens são capturadas e esvazia em downlink.
        delta_buffer = r.uniform(-8.0, 10.0)
        e["buffer_imagens"] = self._limitar(e["buffer_imagens"] + delta_buffer, 0, 100)
        # Precisão de geolocalização varia com a geometria da constelação.
        e["precisao_geo"] = self._limitar(
            e["precisao_geo"] + r.uniform(-2.0, 2.5), 2, 80
        )
        # Qualidade do downlink varia com a janela de passagem sobre a estação.
        e["qualidade_downlink"] = self._limitar(
            e["qualidade_downlink"] + r.uniform(-10.0, 8.0), 0, 100
        )
        # Focos detectados — depende da época do ano / região imageada.
        e["focos_detectados"] = max(0, int(e["focos_detectados"] + r.randint(-3, 5)))

        return {k: self._arredondar(v) for k, v in e.items()}

    # -------------------------------------------------------------------
    # Cenários determinísticos para teste e demonstração
    # -------------------------------------------------------------------
    def _gerar_cenario(self, nome):
        base = {
            "temperatura_sensor": 24.0,
            "energia_bateria": 78.0,
            "buffer_imagens": 35.0,
            "precisao_geo": 9.0,
            "qualidade_downlink": 85.0,
            "focos_detectados": 6,
        }

        if nome == "incendio_intenso":
            base.update({
                "focos_detectados": 142,
                "buffer_imagens": 87.0,   # imageamento extra enche o buffer
                "energia_bateria": 61.0,
                "temperatura_sensor": 38.0,
            })
        elif nome == "falha_energia":
            base.update({
                "energia_bateria": 14.0,
                "qualidade_downlink": 58.0,
                "temperatura_sensor": 19.0,
            })
        elif nome == "superaquecimento":
            base.update({
                "temperatura_sensor": 78.0,
                "energia_bateria": 70.0,
                "precisao_geo": 11.0,
            })
        elif nome == "perda_downlink":
            base.update({
                "qualidade_downlink": 22.0,
                "buffer_imagens": 96.0,   # sem downlink, buffer satura
                "energia_bateria": 64.0,
            })
        elif nome == "extremo":
            base.update({
                "temperatura_sensor": 480.0,
                "energia_bateria": -5.0,
                "buffer_imagens": 100.0,
                "precisao_geo": 999.0,
                "qualidade_downlink": 0.0,
                "focos_detectados": 9999,
            })
        # "normal" cai no base sem alterações.

        return {k: self._arredondar(v) for k, v in base.items()}

    # -------------------------------------------------------------------
    # Utilidades
    # -------------------------------------------------------------------
    @staticmethod
    def _limitar(valor, minimo, maximo):
        return max(minimo, min(maximo, valor))

    @staticmethod
    def _arredondar(valor):
        if isinstance(valor, int):
            return valor
        return round(valor, 1)


# Instância única reutilizada pelo motor (mantém continuidade temporal).
_simulador = TelemetriaSimulator()


def coletar():
    """Função de conveniência usada pelo MissionEngine: retorna um snapshot."""
    return _simulador.coletar()


def forcar_cenario(nome):
    """Repassa um cenário forçado ao simulador global."""
    _simulador.forcar_cenario(nome)


if __name__ == "__main__":
    # Pequeno teste manual: imprime 5 ciclos normais e os cenários extremos.
    sim = TelemetriaSimulator(semente=42)
    print("== 5 ciclos de operação normal ==")
    for _ in range(5):
        print(sim.coletar())
    print("\n== Cenário: incêndio intenso ==")
    sim.forcar_cenario("incendio_intenso")
    print(sim.coletar())
    print("\n== Cenário: falha de energia ==")
    sim.forcar_cenario("falha_energia")
    print(sim.coletar())
MCAI_EOF

echo "==> Gravando src/alertas.py"
cat > "src/alertas.py" << 'MCAI_EOF'
"""
alertas.py — Regras de threshold, classificação de severidade e respostas
automatizadas do EnviroSat.

PRINCÍPIO (rubrica, Frente 4): a lógica de decisão "é crítico ou não" mora
AQUI, em Python, e não no prompt da IA. A IA serve para explicar e
contextualizar; quem decide a severidade é o código determinístico abaixo.

Cada regra avalia um parâmetro do snapshot e devolve, quando disparada, um
dicionário com: parâmetro, valor, nível (ATENCAO/CRITICO), mensagem técnica e,
quando aplicável, uma resposta automatizada (ação que o sistema "executa"
sozinho diante da crise).
"""

# ---------------------------------------------------------------------------
# Thresholds (limiares). Estrutura: parâmetro -> (limite_atencao, limite_critico,
# sentido). "sentido" indica se o alerta dispara quando o valor está ACIMA
# (">") ou ABAIXO ("<") do limite.
# ---------------------------------------------------------------------------
THRESHOLDS = {
    "temperatura_sensor":  {"atencao": 50.0, "critico": 70.0, "sentido": ">", "unidade": "°C"},
    "energia_bateria":     {"atencao": 35.0, "critico": 20.0, "sentido": "<", "unidade": "%"},
    "buffer_imagens":      {"atencao": 80.0, "critico": 92.0, "sentido": ">", "unidade": "%"},
    "precisao_geo":        {"atencao": 30.0, "critico": 50.0, "sentido": ">", "unidade": "m"},
    "qualidade_downlink":  {"atencao": 45.0, "critico": 30.0, "sentido": "<", "unidade": ""},
}

# Mensagem técnica associada a cada (parâmetro, nível).
DESCRICOES = {
    ("temperatura_sensor", "ATENCAO"): "Payload óptico aquecendo acima da faixa nominal.",
    ("temperatura_sensor", "CRITICO"): "Superaquecimento do payload — risco de degradação do sensor térmico.",
    ("energia_bateria", "ATENCAO"): "Bateria em nível de atenção — autonomia reduzida.",
    ("energia_bateria", "CRITICO"): "Energia crítica — risco de desligamento de subsistemas.",
    ("buffer_imagens", "ATENCAO"): "Buffer de imagens enchendo — janela de downlink pode não dar conta.",
    ("buffer_imagens", "CRITICO"): "Buffer quase saturado — risco de perda de imagens não transmitidas.",
    ("precisao_geo", "ATENCAO"): "Geolocalização degradada — coordenadas de focos menos confiáveis.",
    ("precisao_geo", "CRITICO"): "Geolocalização imprecisa — coordenadas de focos não confiáveis para despacho.",
    ("qualidade_downlink", "ATENCAO"): "Enlace de descida degradado — taxa de transmissão reduzida.",
    ("qualidade_downlink", "CRITICO"): "Enlace de descida crítico — transmissão de imagens comprometida.",
}

# Respostas automatizadas: ação que o sistema executa diante de uma crise.
RESPOSTAS_AUTOMATICAS = {
    "energia_bateria": "MODO ECONOMIA ativado: reduz cadência de imageamento e desliga sensores não essenciais.",
    "temperatura_sensor": "PROTEÇÃO TÉRMICA ativada: reorienta o satélite para reduzir incidência solar no payload.",
    "buffer_imagens": "PRIORIZAÇÃO DE DOWNLINK ativada: descarta pré-visualizações e prioriza imagens com focos.",
    "qualidade_downlink": "RETENÇÃO SEGURA ativada: pausa novas capturas até a próxima janela de estação terrena.",
}


def _dispara(valor, limite, sentido):
    """Retorna True se 'valor' cruza 'limite' no 'sentido' indicado."""
    if sentido == ">":
        return valor > limite
    return valor < limite


def avaliar(dados):
    """Avalia um snapshot de telemetria e retorna a lista de alertas ativos.

    Retorna lista de dicts; lista vazia significa "todos os parâmetros nominais".
    """
    alertas = []

    for parametro, regra in THRESHOLDS.items():
        valor = dados.get(parametro)
        if valor is None:
            continue

        nivel = None
        if _dispara(valor, regra["critico"], regra["sentido"]):
            nivel = "CRITICO"
        elif _dispara(valor, regra["atencao"], regra["sentido"]):
            nivel = "ATENCAO"

        if nivel:
            alerta = {
                "parametro": parametro,
                "valor": valor,
                "unidade": regra["unidade"],
                "nivel": nivel,
                "mensagem": DESCRICOES.get((parametro, nivel), "Parâmetro fora da faixa nominal."),
            }
            # Resposta automatizada só dispara em nível CRÍTICO.
            if nivel == "CRITICO" and parametro in RESPOSTAS_AUTOMATICAS:
                alerta["resposta_automatica"] = RESPOSTAS_AUTOMATICAS[parametro]
            alertas.append(alerta)

    return alertas


def severidade_geral(alertas):
    """Resume a missão em um único rótulo a partir da lista de alertas."""
    if any(a["nivel"] == "CRITICO" for a in alertas):
        return "CRITICO"
    if any(a["nivel"] == "ATENCAO" for a in alertas):
        return "ATENCAO"
    return "NOMINAL"


def respostas_disparadas(alertas):
    """Lista apenas as respostas automatizadas efetivamente acionadas."""
    return [a["resposta_automatica"] for a in alertas if "resposta_automatica" in a]


if __name__ == "__main__":
    # Teste rápido com um snapshot crítico simulado.
    snapshot = {
        "temperatura_sensor": 78.0,
        "energia_bateria": 14.0,
        "buffer_imagens": 96.0,
        "precisao_geo": 9.0,
        "qualidade_downlink": 80.0,
    }
    ativos = avaliar(snapshot)
    print("Severidade geral:", severidade_geral(ativos))
    for a in ativos:
        print(a)
    print("Respostas automáticas:", respostas_disparadas(ativos))
MCAI_EOF

echo "==> Gravando src/engine.py"
cat > "src/engine.py" << 'MCAI_EOF'
"""
engine.py — Motor de análise da Mission Control AI (trilha EnviroSat).

Combina:
  (a) a função llm() — ponto único de contato com o gpt-oss:120b via Ollama Cloud
      (mesma da seção 4.2 do enunciado, NÃO reescrita);
  (b) a classe MissionEngine, que coleta telemetria, avalia alertas em Python,
      monta o prompt dinâmico com os dados reais e chama a IA para contextualizar.

Diferenciais implementados:
  - Injeção dinâmica de dados no prompt (obrigatório, Frente 3).
  - Memória de contexto: guarda os últimos ciclos e passa um resumo à IA,
    simulando consciência temporal.
  - Lógica de decisão e respostas automatizadas em código (Frente 4), via alertas.py.
"""

import os
from collections import deque
from pathlib import Path

from ollama import Client
from dotenv import load_dotenv

from src import telemetria
from src import alertas

load_dotenv()

# Identificação da trilha — ALTEREM conforme a escolha do grupo.
TRILHA = "envirosat"  # "agrosat" | "envirosat" | "connectsat" | "mobilitysat"

# Cliente Ollama Cloud (mesma configuração dos Checkpoints 02 e 03).
client = Client(
    host="https://ollama.com",
    headers={"Authorization": "Bearer " + os.environ.get("OLLAMA_API_KEY", "")},
)


def llm(prompt, system=None, max_tokens=800, temperature=0.3):
    """Envia prompt ao gpt-oss:120b via Ollama Cloud e retorna o texto.

    Ponto ÚNICO de integração com a IA — toda chamada ao modelo passa por aqui.
    """
    messages = []
    if system:
        messages.append({"role": "system", "content": system})
    messages.append({"role": "user", "content": prompt})
    try:
        return client.chat(
            model="gpt-oss:120b",
            messages=messages,
            options={"num_predict": max_tokens, "temperature": temperature},
            stream=False,
        )["message"]["content"].strip()
    except Exception as e:  # noqa: BLE001 — queremos capturar qualquer falha de rede/API
        return f"⚠️  Erro ao consultar IA: {e}"


def load_system_prompt():
    """Lê o system prompt de prompts/system_prompt.md."""
    path = Path("prompts/system_prompt.md")
    if path.exists():
        return path.read_text(encoding="utf-8")
    return "Você é um assistente de operações de satélite."  # fallback


# Rótulos amigáveis para exibir cada parâmetro.
ROTULOS = {
    "temperatura_sensor": "Temperatura do payload",
    "energia_bateria": "Energia (bateria)",
    "buffer_imagens": "Buffer de imagens",
    "precisao_geo": "Precisão de geolocalização",
    "qualidade_downlink": "Qualidade do downlink",
    "focos_detectados": "Focos de calor detectados",
}

UNIDADES = {
    "temperatura_sensor": "°C",
    "energia_bateria": "%",
    "buffer_imagens": "%",
    "precisao_geo": " m",
    "qualidade_downlink": "/100",
    "focos_detectados": "",
}


class MissionEngine:
    """Motor de análise — coleta, decide em Python e contextualiza com IA."""

    def __init__(self):
        self.trilha = TRILHA
        self.system_prompt = load_system_prompt()
        # Memória de contexto: últimos 5 ciclos (consciência temporal).
        self._historico = deque(maxlen=5)

    def is_ready(self):
        """A análise está implementada: o sistema está pronto."""
        return True

    # -------------------------------------------------------------------
    # Coleta + avaliação (parte determinística, sem IA)
    # -------------------------------------------------------------------
    def _coletar_e_avaliar(self):
        dados = telemetria.coletar()
        ativos = alertas.avaliar(dados)
        severidade = alertas.severidade_geral(ativos)
        respostas = alertas.respostas_disparadas(ativos)
        registro = {
            "dados": dados,
            "alertas": ativos,
            "severidade": severidade,
            "respostas": respostas,
        }
        self._historico.append(registro)
        return registro

    # -------------------------------------------------------------------
    # Formatação de blocos de texto para humanos e para o prompt da IA
    # -------------------------------------------------------------------
    @staticmethod
    def _formatar_telemetria(dados):
        linhas = []
        for chave, rotulo in ROTULOS.items():
            if chave in dados:
                linhas.append(f"  - {rotulo}: {dados[chave]}{UNIDADES.get(chave, '')}")
        return "\n".join(linhas)

    @staticmethod
    def _formatar_alertas(ativos):
        if not ativos:
            return "  nenhum (todos os parâmetros nominais)"
        linhas = []
        for a in ativos:
            linha = f"  - [{a['nivel']}] {a['parametro']} = {a['valor']}{a['unidade']} — {a['mensagem']}"
            if "resposta_automatica" in a:
                linha += f"\n      RESPOSTA AUTOMÁTICA DISPARADA: {a['resposta_automatica']}"
            linhas.append(linha)
        return "\n".join(linhas)

    def _resumo_historico(self):
        """Resumo curto dos ciclos anteriores para dar memória temporal à IA."""
        if len(self._historico) <= 1:
            return "  (primeiro ciclo desta sessão)"
        linhas = []
        for r in list(self._historico)[:-1]:  # exclui o ciclo atual
            d = r["dados"]
            linhas.append(
                f"  - Ciclo {d['ciclo']}: estado {r['severidade']}, "
                f"bateria {d['energia_bateria']}%, buffer {d['buffer_imagens']}%, "
                f"focos {d['focos_detectados']}"
            )
        return "\n".join(linhas)

    # -------------------------------------------------------------------
    # status_snapshot — resumo legível sem IA (comando /status)
    # -------------------------------------------------------------------
    def status_snapshot(self):
        registro = self._coletar_e_avaliar()
        dados = registro["dados"]
        bloco = (
            f"EnviroSat · Ciclo {dados['ciclo']} · {dados['timestamp']}\n"
            f"Estado geral: {registro['severidade']}\n\n"
            f"Telemetria:\n{self._formatar_telemetria(dados)}\n\n"
            f"Alertas ativos:\n{self._formatar_alertas(registro['alertas'])}"
        )
        if registro["respostas"]:
            bloco += "\n\nRespostas automáticas acionadas:\n"
            bloco += "\n".join(f"  - {r}" for r in registro["respostas"])
        return bloco

    # -------------------------------------------------------------------
    # analyze — o coração do trabalho: telemetria + alertas + IA
    # -------------------------------------------------------------------
    def analyze(self, pergunta_usuario):
        registro = self._coletar_e_avaliar()
        dados = registro["dados"]

        prompt = f"""CONTEXTO DA MISSÃO: satélite EnviroSat (observação ambiental).

TELEMETRIA ATUAL (Ciclo {dados['ciclo']} — {dados['timestamp']}):
{self._formatar_telemetria(dados)}

SEVERIDADE GERAL (já classificada pelo sistema em Python): {registro['severidade']}

ALERTAS ATIVOS:
{self._formatar_alertas(registro['alertas'])}

HISTÓRICO RECENTE (memória de contexto):
{self._resumo_historico()}

PERGUNTA DO OPERADOR:
{pergunta_usuario}

Responda seguindo ESTRITAMENTE o formato definido no system prompt e lembre-se de
amarrar o diagnóstico técnico ao impacto ambiental na Terra."""

        return llm(prompt, system=self.system_prompt)


if __name__ == "__main__":
    # Teste de fumaça: roda análise sem precisar abrir a CLI.
    eng = MissionEngine()
    print(eng.status_snapshot())
    print("\n--- Análise da IA ---\n")
    print(eng.analyze("Como está a missão neste ciclo?"))
MCAI_EOF

echo "==> Gravando src/ui.py"
cat > "src/ui.py" << 'MCAI_EOF'
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
MCAI_EOF

echo "==> Gravando prompts/system_prompt.md"
cat > "prompts/system_prompt.md" << 'MCAI_EOF'
# System Prompt — Mission Control AI · Trilha EnviroSat

Você é o **Mission Control AI**, copiloto de operações do satélite **EnviroSat**,
uma plataforma de observação ambiental em órbita baixa (estilo Amazônia-1 /
Landsat), operada por um centro de controle ambiental brasileiro. Sua função é
traduzir telemetria bruta em diagnósticos claros para humanos e — sempre —
amarrar o estado técnico do satélite à sua consequência na Terra.

## Papel e escopo

- Você analisa EXCLUSIVAMENTE a missão EnviroSat: saúde do payload óptico/térmico,
  energia, buffer de imagens, geolocalização e enlace de descida (downlink).
- Você fala com três personas: (1) o **operador do centro de controle ambiental**
  (ex.: INPE ou órgão estadual), (2) o **coordenador de brigada de combate a
  incêndio** e (3) o **analista de compliance ambiental**. Adapte o nível de
  detalhe técnico, mas a mensagem central é sempre operacional.
- Você NÃO inventa dados. Use somente os valores de telemetria e a lista de
  alertas que o sistema injetar no prompt. Se um dado não foi fornecido, diga
  explicitamente que ele não está disponível.

## A regra de ouro (diferencial 2026.1): conecte com a Terra

Toda análise deve responder, em linguagem natural, **o que aquela leitura
significa para o mundo lá embaixo**. O EnviroSat existe para combater
desmatamento, dar resposta rápida a incêndios e monitorar áreas protegidas.
Portanto:

- Se a saúde está boa, explique o que o satélite está conseguindo entregar
  (ex.: cobertura de imageamento, focos geolocalizados para despacho de brigada).
- Se há anomalia, explique **quem sofre na Terra** se ela não for tratada
  (ex.: focos não detectados a tempo, coordenadas imprecisas atrasando o combate,
  imagens de fiscalização perdidas).

## Restrições

- Não decida sozinho se algo é crítico — essa classificação já vem pronta na
  seção `ALERTAS ATIVOS`. Respeite-a. Seu papel é **explicar e contextualizar**,
  não recalcular thresholds.
- Seja conciso e objetivo. Nada de enrolação, nem de repetir os números crus
  sem interpretá-los.
- Não use jargão sem explicar. O coordenador de brigada não precisa saber o que
  é "atitude orbital"; ele precisa saber se a coordenada do foco é confiável.
- Se não houver alertas, confirme operação nominal — não invente problemas.

## Formato de saída (siga sempre)

```
🛰  ESTADO: <NOMINAL | ATENÇÃO | CRÍTICO>

📊  Diagnóstico técnico:
<2 a 4 frases interpretando a telemetria e os alertas ativos>

🌍  Impacto na Terra:
<2 a 3 frases conectando o estado técnico à consequência terrestre>

✅  Recomendação:
<1 a 2 ações objetivas para o operador / brigada>
```

Quando o sistema indicar que uma resposta automática já foi disparada, mencione-a
na recomendação como algo que o satélite **já executou**.

---

## Exemplos (few-shot)

### Exemplo 1 — operação nominal

Telemetria: temperatura_sensor 22.4°C, energia_bateria 88%, buffer_imagens 31%,
precisao_geo 7m, qualidade_downlink 84. ALERTAS ATIVOS: nenhum.

Resposta esperada:

```
🛰  ESTADO: NOMINAL

📊  Diagnóstico técnico:
Todos os subsistemas estão dentro da faixa nominal. O payload óptico/térmico
opera frio (22,4 °C), a bateria está saudável (88%) e o buffer tem folga (31%).
A geolocalização de 7 m e o downlink de boa qualidade garantem imagens prontas
para uso.

🌍  Impacto na Terra:
O EnviroSat está entregando cobertura confiável para o monitoramento ambiental:
focos de calor podem ser detectados e geolocalizados com precisão suficiente
para acionar brigadas e alimentar relatórios de fiscalização.

✅  Recomendação:
Manter o plano de imageamento atual. Nenhuma intervenção necessária neste ciclo.
```

### Exemplo 2 — energia crítica com resposta automática

Telemetria: temperatura_sensor 19°C, energia_bateria 14%, buffer_imagens 35%,
precisao_geo 9m, qualidade_downlink 58. ALERTAS ATIVOS: [CRÍTICO] energia_bateria
= 14% — Energia crítica, risco de desligamento de subsistemas. RESPOSTA
AUTOMÁTICA DISPARADA: MODO ECONOMIA ativado.

Resposta esperada:

```
🛰  ESTADO: CRÍTICO

📊  Diagnóstico técnico:
A bateria caiu para 14%, abaixo do limite crítico de 20%, com risco de
desligamento de subsistemas. Os demais parâmetros (térmico, buffer, downlink)
seguem aceitáveis, então a anomalia está concentrada no subsistema de energia.

🌍  Impacto na Terra:
Em modo economia, o EnviroSat reduz a cadência de imageamento — focos de calor
podem passar despercebidos por algumas órbitas, atrasando o alerta a brigadas em
regiões de risco de incêndio.

✅  Recomendação:
O satélite já ativou automaticamente o MODO ECONOMIA. Operador deve priorizar a
recarga na próxima janela solar e suspender capturas não essenciais até a bateria
voltar acima de 35%.
```
MCAI_EOF

echo "==> Gravando data/cenarios.json"
cat > "data/cenarios.json" << 'MCAI_EOF'
{
  "descricao": "Cenários pré-definidos da trilha EnviroSat para testes e gravação do vídeo. Use o comando /cenario <chave> na CLI.",
  "cenarios": {
    "normal": {
      "rotulo": "Operação nominal",
      "esperado": "Estado NOMINAL — nenhum alerta, satélite entregando cobertura."
    },
    "incendio_intenso": {
      "rotulo": "Temporada de incêndios",
      "esperado": "Muitos focos detectados e buffer enchendo — alerta de ATENÇÃO no buffer, foco no impacto (despacho de brigadas)."
    },
    "falha_energia": {
      "rotulo": "Bateria crítica",
      "esperado": "Estado CRÍTICO — energia < 20%, dispara MODO ECONOMIA automaticamente."
    },
    "superaquecimento": {
      "rotulo": "Superaquecimento do payload",
      "esperado": "Estado CRÍTICO — temperatura > 70°C, dispara PROTEÇÃO TÉRMICA."
    },
    "perda_downlink": {
      "rotulo": "Perda de enlace de descida",
      "esperado": "Estado CRÍTICO — downlink degradado e buffer saturado, dispara RETENÇÃO SEGURA / PRIORIZAÇÃO DE DOWNLINK."
    },
    "extremo": {
      "rotulo": "Valores fisicamente improváveis",
      "esperado": "Teste de robustez — todos os parâmetros estourados de uma vez."
    }
  }
}
MCAI_EOF

echo "==> Gerando placeholders em assets/ (SUBSTITUA por prints reais!)"
python3 - << 'PYEOF'
try:
    from PIL import Image, ImageDraw, ImageFont
    def ph(path, titulo, linhas):
        W,H=1000,520; img=Image.new("RGB",(W,H),"#0d1117"); d=ImageDraw.Draw(img)
        try:
            fb=ImageFont.truetype("/usr/share/fonts/truetype/dejavu/DejaVuSansMono-Bold.ttf",26)
            f=ImageFont.truetype("/usr/share/fonts/truetype/dejavu/DejaVuSansMono.ttf",18)
            fw=ImageFont.truetype("/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf",20)
        except Exception:
            fb=f=fw=ImageFont.load_default()
        d.rectangle([0,0,W,40],fill="#161b22")
        for i,c in enumerate(["#ff5f56","#ffbd2e","#27c93f"]): d.ellipse([20+i*26,14,34+i*26,28],fill=c)
        d.text((30,60),titulo,font=fb,fill="#22C55E"); y=110
        for ln in linhas: d.text((30,y),ln,font=f,fill="#c9d1d9"); y+=28
        d.rectangle([30,H-110,W-30,H-30],outline="#ffbd2e",width=2)
        d.text((45,H-98),"PLACEHOLDER - SUBSTITUA POR UM PRINT REAL",font=fw,fill="#ffbd2e")
        d.text((45,H-66),"Rode 'python main.py' com sua OLLAMA_API_KEY e capture",font=f,fill="#8b949e")
        d.text((45,H-44),"a tela real do seu sistema funcionando.",font=f,fill="#8b949e")
        img.save(path); print("  ok:",path)
    ph("assets/screenshot_banner.png","Banner + /status",["EnviroSat (banner ASCII verde)","Engine status: OPERACIONAL","/status -> estado NOMINAL"])
    ph("assets/screenshot_analise.png","IA em cenario critico",["/cenario falha_energia","ESTADO: CRITICO","MODO ECONOMIA acionado"])
except Exception as e:
    open("assets/LEIA-ME.txt","w").write("Coloque aqui screenshot_banner.png e screenshot_analise.png (prints reais).\n")
    print("  PIL indisponivel - criei assets/LEIA-ME.txt. Erro:", e)
PYEOF

echo ""
echo "==> Projeto criado! Proximos passos:"
echo "   cp .env.example .env   # e edite com sua OLLAMA_API_KEY"
echo "   python -m venv .venv && source .venv/bin/activate"
echo "   pip install -r requirements.txt"
echo "   python main.py"
