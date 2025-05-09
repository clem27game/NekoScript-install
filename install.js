
const express = require('express');
const app = express();
const fs = require('fs');
const path = require('path');

app.get('/download', (req, res) => {
  const files = {
    'neko-script.sh': fs.readFileSync('neko-script.sh'),
    'main.cpp': fs.readFileSync('main.cpp'),
    'package_manager.cpp': fs.readFileSync('package_manager.cpp')
  };
  
  res.json(files);
});

app.listen(3000, '0.0.0.0', () => {
  console.log('Serveur de distribution démarré sur le port 3000');
});
