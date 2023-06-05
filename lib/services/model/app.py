from flask import Flask, request, jsonify
import librosa
import numpy as np
import pandas as pd
import pickle

app = Flask(__name__)


def process_audio(audio_file_path):

    y, sr = librosa.load(audio_file_path)

    # Extract features from the song
    length = librosa.get_duration(y=y, sr=sr)
    chroma_stft = librosa.feature.chroma_stft(y=y, sr=sr)
    chroma_stft_mean = np.mean(chroma_stft)
    chroma_stft_var = np.var(chroma_stft)
    rms = librosa.feature.rms(y=y)
    rms_mean = np.mean(rms)
    rms_var = np.var(rms)
    spectral_centroid = librosa.feature.spectral_centroid(y=y, sr=sr)
    spectral_centroid_mean = np.mean(spectral_centroid)
    spectral_centroid_var = np.var(spectral_centroid)
    spectral_bandwidth = librosa.feature.spectral_bandwidth(y=y, sr=sr)
    spectral_bandwidth_mean = np.mean(spectral_bandwidth)
    spectral_bandwidth_var = np.var(spectral_bandwidth)
    rolloff = librosa.feature.spectral_rolloff(y=y, sr=sr)
    rolloff_mean = np.mean(rolloff)
    rolloff_var = np.var(rolloff)
    zero_crossing = librosa.feature.zero_crossing_rate(y=y)
    zero_crossing_rate_mean = np.mean(zero_crossing)
    zero_crossing_rate_var = np.var(zero_crossing)
    y_harm, y_perc = librosa.effects.hpss(y)
    harmony_mean = np.mean(y_harm)
    harmony_var = np.var(y_harm)
    perceptr_mean = np.mean(y_perc)
    perceptr_var = np.var(y_perc)
    tempo = librosa.beat.tempo(y=y, sr=sr)[0]
    mfccs = librosa.feature.mfcc(y=y, sr=sr)
    mfccs_mean = np.mean(mfccs, axis=1)
    mfccs_var = np.var(mfccs, axis=1)

    # Create a pandas DataFrame with the extracted features
    data = {'length': length, 'chroma_stft_mean': chroma_stft_mean, 'chroma_stft_var': chroma_stft_var,
            'rms_mean': rms_mean, 'rms_var': rms_var, 'spectral_centroid_mean': spectral_centroid_mean,
            'spectral_centroid_var': spectral_centroid_var, 'spectral_bandwidth_mean': spectral_bandwidth_mean,
            'spectral_bandwidth_var': spectral_bandwidth_var, 'rolloff_mean': rolloff_mean, 'rolloff_var': rolloff_var,
            'zero_crossing_rate_mean': zero_crossing_rate_mean, 'zero_crossing_rate_var': zero_crossing_rate_var,
            'harmony_mean': harmony_mean, 'harmony_var': harmony_var, 'perceptr_mean': perceptr_mean,
            'perceptr_var': perceptr_var, 'tempo': tempo}
    for i in range(1, 21):
        data[f'mfcc{i}_mean'] = mfccs_mean[i-1]
        data[f'mfcc{i}_var'] = mfccs_var[i-1]
    df = pd.DataFrame(data, index=["1"])
    return df


@app.route('/upload', methods=['POST'])
def upload_file():
    if 'audio' not in request.files:
        return 'No audio file found', 400

    genre = ['blues', 'classical', 'country', 'disco',
             'hiphop', 'jazz', 'metal', 'pop', 'reggae', 'rock']
    audio_file = request.files['audio']
    print(audio_file)
    df = process_audio(audio_file)
    model = pickle.load(open('lib/services/model/xgb_model.pkl', "rb"))
    prediction = model.predict(df)[0]
    return jsonify(genre[prediction])


if __name__ == '__main__':
    app.run(host='0.0.0.0')
