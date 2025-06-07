from fastapi import FastAPI, UploadFile, File
from pydantic import BaseModel
from PIL import Image
import torch
import clip
import io

app = FastAPI()
device = "cuda" if torch.cuda.is_available() else "cpu"
model, preprocess = clip.load("ViT-B/32", device=device)

class TextIn(BaseModel):
    text: str

@app.post('/embed_text')
def embed_text(data: TextIn):
    with torch.no_grad():
        text_tokens = clip.tokenize([data.text]).to(device)
        text_features = model.encode_text(text_tokens)
        return {'embedding': text_features[0].cpu().tolist()}

@app.post('/embed_image')
async def embed_image(file: UploadFile = File(...)):
    image = Image.open(io.BytesIO(await file.read())).convert("RGB")
    image_input = preprocess(image).unsqueeze(0).to(device)
    with torch.no_grad():
        image_features = model.encode_image(image_input)
        return {'embedding': image_features[0].cpu().tolist()} 