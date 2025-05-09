const express = require('express');
const app = express();
const fs = require('fs');

app.get('/install.sh', (req, res) => {
  res.setHeader('Content-Type', 'text/plain');
  res.send(`#!/bin/bash
curl -s -o neko-script.sh https://localhost:5000/neko-script.sh
chmod +x neko-script.sh
./neko-script.sh télécharger`);
});

app.get('/neko-script.sh', (req, res) => {
  res.setHeader('Content-Type', 'text/plain');
  res.sendFile(__dirname + '/neko-script.sh');  // Vérifiez que le chemin est correct
});

// Route par défaut pour gérer les requêtes vers /
app.get('/', (req, res) => {
  res.send('Bienvenue sur le serveur NekoScript ! Utilisez /install.sh ou /neko-script.sh pour télécharger le script.');
});

app.listen(5000, '0.0.0.0', () => {
  console.log('Serveur de distribution démarré sur le port 5000');
});