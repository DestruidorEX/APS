const openMeteoService = require('../services/openMeteoService');

const cidades = {
  "sao-paulo": { lat: -23.55052, lon: -46.633308 },
  "rio-de-janeiro": { lat: -22.906847, lon: -43.172897 },
  "campinas": { lat: -22.90556, lon: -47.06083 }
};

function gerarAlertas(dados) {
  const alertas = [];
  const temp = dados.temperature;
  const vento = dados.windspeed;
  const chuva = dados.rain ?? 0; // pode ser undefined dependendo do retorno

  if (temp !== undefined && temp > 32) alertas.push("Calor extremo — risco de insolação");
  if (vento !== undefined && vento > 40) alertas.push("Vento muito forte — risco de quedas de galhos");
  if (chuva > 10) alertas.push("Chuva forte — risco de alagamento");
  else if (chuva > 2) alertas.push("Chuva moderada");
  if (alertas.length === 0) alertas.push("Sem alertas no momento");

  return alertas;
}

exports.obterClima = async (req, res) => {
  try {
    const cidadeQuery = (req.query.cidade || '').toLowerCase();
    if (!cidadeQuery || !cidades[cidadeQuery]) {
      return res.status(400).json({ error: 'cidade inválida. Use: sao-paulo, rio-de-janeiro or campinas' });
    }

    const { lat, lon } = cidades[cidadeQuery];

    const dados = await openMeteoService.getCurrentWeather(lat, lon);

    // Dados processados que o mobile vai usar
    const resposta = {
      cidade: cidadeQuery,
      temperatura: dados.temperature,
      vento: dados.windspeed,
      umidade: dados.relativehumidity ?? null,
      hora_atualizacao: dados.time,
      alertas: gerarAlertas(dados)
    };

    res.json(resposta);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Erro ao obter dados climáticos' });
  }
};
