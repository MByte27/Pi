import os
import time
import threading
from flask import Flask, render_template, jsonify
import RPi.GPIO as GPIO

# Imposta il pin GPIO per la ventola
FAN_PIN = 18
GPIO.setmode(GPIO.BCM)
GPIO.setup(FAN_PIN, GPIO.OUT)

# Modalità di funzionamento della ventola
fan_speed = 0  # 0 significa spenta, 100 significa massima velocità

# Log per temperatura e velocità
temperature_log = []
fan_speed_log = []

app = Flask(__name__)

def get_cpu_temp():
    """Ritorna la temperatura della CPU in Celsius."""
    temp = os.popen("vcgencmd measure_temp").readline()
    return float(temp.replace("temp=", "").replace("'C\n", ""))

def control_fan():
    """Controlla la ventola in base alla temperatura della CPU."""
    global fan_speed
    while True:
        temp = get_cpu_temp()
        if temp > 55:
            GPIO.output(FAN_PIN, GPIO.HIGH)
            fan_speed = 100
        elif temp <= 55:
            GPIO.output(FAN_PIN, GPIO.HIGH)
            fan_speed = 66

        # Log dei valori
        current_time = time.time()
        temperature_log.append((current_time, temp))
        fan_speed_log.append((current_time, fan_speed))

        # Mantiene il log delle ultime 24 ore
        cutoff = current_time - 86400
        temperature_log[:] = [(t, temp) for t, temp in temperature_log if t > cutoff]
        fan_speed_log[:] = [(t, speed) for t, speed in fan_speed_log if t > cutoff]

        time.sleep(5)

@app.route('/')
def index():
    """Pagina principale."""
    return render_template('index.html')

@app.route('/current_temperature')
def current_temperature():
    """Ritorna la temperatura attuale della CPU."""
    return jsonify(temperature=get_cpu_temp())

@app.route('/current_data')
def current_data():
    """Ritorna i log di temperatura e velocità della ventola."""
    return jsonify(temperature_log=temperature_log, fan_speed_log=fan_speed_log)

if __name__ == '__main__':
    # Avvia il thread per il controllo della ventola
    fan_thread = threading.Thread(target=control_fan)
    fan_thread.daemon = True
    fan_thread.start()

    # Avvia il server Flask
    app.run(host='0.0.0.0', port=8080)
  
