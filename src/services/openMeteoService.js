const fetch = require('node-fetch');

// Função para chamar Open-Meteo (parâmetros básicos)
exports.getCurrentWeather = async (lat, lon) => {
  // Open-Meteo: current_weather=true fornece temperatura e vento, mas para chuva/umidade pode requerer hourly/params
  // Ex.: usamos current_weather para simplicidade e hourly para precipitação/humidity se necessário.
  const url = `https://api.open-meteo.com/v1/forecast?latitude=${lat}&longitude=${lon}&current_weather=true&hourly=relativehumidity_2m,precipitation&timezone=auto`;

  const resp = await fetch(url);
  if (!resp.ok) throw new Error('Erro ao comunicar Open-Meteo');
  const json = await resp.json();

  // current_weather contém temperatura e velocidade do vento
  const current = json.current_weather || {};
  // Tentei extrair precipitação/umidade do hourly (posição 0 = hora atual)
  const hourly = json.hourly || {};
  let rain = 0;
  let humidity = null;
  if (hourly.precipitation && hourly.precipitation.length > 0) {
    rain = hourly.precipitation[0];
  }
  if (hourly.relativehumidity_2m && hourly.relativehumidity_2m.length > 0) {
    humidity = hourly.relativehumidity_2m[0];
  }

  return {
    temperature: current.temperature,
    windspeed: current.windspeed,
    time: current.time,
    rain: rain,
    relativehumidity: humidity
  };
};