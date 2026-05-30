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
