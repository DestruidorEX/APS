const express = require('express');
const cors = require('cors');
const climaRoutes = require('./routes/climaRoutes');

const app = express();
app.use(cors());
app.use(express.json());

app.use('/clima', climaRoutes);

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`API intermediária rodando em http://localhost:${PORT}`);
});
