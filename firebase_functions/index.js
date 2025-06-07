const functions = require('firebase-functions');
const use = require('@tensorflow-models/universal-sentence-encoder');
const tf = require('@tensorflow/tfjs-node');

let modelPromise = null;

exports.embedText = functions.https.onRequest(async (req, res) => {
  try {
    if (!modelPromise) modelPromise = use.load();
    const model = await modelPromise;

    let text = req.body.text;
    if (!text) {
      // Support both JSON and urlencoded
      text = req.body && req.body['text'] ? req.body['text'] : req.query.text;
    }
    if (!text) return res.status(400).json({ error: 'No text provided' });

    const embeddings = await model.embed([text]);
    const embeddingArray = embeddings.arraySync()[0];
    res.json({ embedding: embeddingArray });
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: err.toString() });
  }
}); 