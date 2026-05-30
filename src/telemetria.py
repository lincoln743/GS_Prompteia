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
