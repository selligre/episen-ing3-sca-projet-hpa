from flask import Flask
import time

app = Flask(__name__)

@app.route('/load')
def cpu_load():
    end_time = time.time() + 30  # Opération pendant 30 secondes
    while time.time() < end_time:
        _ = [x**2 for x in range(1000)]
    return "Charge CPU terminée sur ce pod !\n"

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)