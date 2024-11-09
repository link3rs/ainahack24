import requests
from playsound import playsound

API_URL = "https://p1b28cv1e843tih1.eu-west-1.aws.endpoints.huggingface.cloud/api/tts"
headers = {
   "Authorization": "Bearer HF",
}

def query(text):
   data = {"text": text, "voice": "quim", "accent": "balear"}
   return requests.post(API_URL, headers=headers, json=data)


inquiry = "the text"
# Send request and save audio
response = query(inquiry)
output_path = "output.wav"
with open(output_path, "wb") as f:
   f.write(response.content)
print(f"Audio saved to {output_path}")

# Play the saved audio file
playsound(output_path)
print("Playing audio...")