
import sounddevice as sd
from scipy.io.wavfile import write
import requests

# Constants
SAMPLE_RATE = 44100  # Sample rate for recording
DURATION = 7       # Duration of recording in seconds
OUTPUT_FILENAME = "sample1.wav"

# Function to record audio
def record_audio(filename, duration, sample_rate):
    print("Recording...")
    audio = sd.rec(int(duration * sample_rate), samplerate=sample_rate, channels=1, dtype='int16')
    sd.wait()  # Wait until recording is finished
    write(filename, sample_rate, audio)  # Save as WAV file
    print("Recording complete.")

# Send audio file with your API
API_URL = "https://l9w4uzm374uyn9xk.us-east-1.aws.endpoints.huggingface.cloud"
headers = {
    "Accept": "application/json",
    "Authorization": "Bearer HF",
    "Content-Type": "audio/wav",
}

def send_audio(filename):
    with open(filename, "rb") as f:
        data = f.read()
    response = requests.post(API_URL, headers=headers, data=data)
    return response.json()

# Run recording and send it
record_audio(OUTPUT_FILENAME, DURATION, SAMPLE_RATE)
output = send_audio(OUTPUT_FILENAME)
print("Response:", output)
