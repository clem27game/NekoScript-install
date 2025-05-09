
const express = require('express');
const app = express();
const fs = require('fs');

app.get('/install.sh', (req, res) => {
  res.setHeader('Content-Type', 'text/plain');
  res.send(`#!/bin/bash
curl -s -o neko-script.sh https://nekoscript.replit.app/neko-script.sh
chmod +x neko-script.sh
./neko-script.sh télécharger`);
});

app.get('/neko-script.sh', (req, res) => {
  res.setHeader('Content-Type', 'text/plain');
  res.sendFile(__dirname + '/neko-script.sh');
});

app.listen(5000, '0.0.0.0', () => {
  console.log('Serveur de distribution démarré sur le port 5000');
});
