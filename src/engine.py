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
