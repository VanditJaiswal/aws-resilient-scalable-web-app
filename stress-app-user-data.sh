#!/bin/bash

# Update YUM packages
sudo yum update -y

# Install Python3 and pip
sudo yum install -y python3 python3-pip

# Install Flask, psutil, and Flask-CORS
sudo pip3 install flask psutil Flask-Cors

# Install stress tool via EPEL repository
sudo yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
sudo yum install -y stress

# Create Flask application
cat << 'EOF' > /home/ec2-user/app.py
from flask import Flask, render_template_string, jsonify
from flask_cors import CORS
import psutil
import subprocess

app = Flask(__name__)
CORS(app)

stress_process = None

@app.route('/')
def index():
    hostname = subprocess.check_output(['hostname']).decode('utf-8').strip()

    return render_template_string("""
<!DOCTYPE html>
<html>
<head>

<title>Vandit's Auto Scaling Demo</title>

<style>

body{
    font-family:Arial,Helvetica,sans-serif;
    text-align:center;
    background:linear-gradient(135deg,#0f172a,#2563eb);
    color:white;
    padding-top:40px;
}

.branding{
    color:#38bdf8;
    font-weight:bold;
    font-size:28px;
    margin-top:20px;
}

.meter{
    height:20px;
    position:relative;
    background:#ddd;
    border-radius:25px;
    padding:10px;
    width:70%;
    margin:0 auto;
    box-shadow:inset 0 -1px 1px rgba(255,255,255,.3);
}

.meter > span{
    display:block;
    height:100%;
    border-radius:20px;
    background:linear-gradient(90deg,#22c55e,#16a34a);
    position:relative;
    overflow:hidden;
}

button{
    margin:10px;
    padding:12px 25px;
    border:none;
    border-radius:8px;
    cursor:pointer;
    font-size:16px;
}

button:hover{
    opacity:.9;
}

</style>

</head>

<body onload="updateCpuUsage()">

<h2 class="branding">Vandit Jaiswal</h2>

<h3>
AWS Auto Scaling & Load Testing Demo
</h3>

<p><strong>Hostname:</strong> {{ hostname }}</p>

<p>
This EC2 instance is part of an
<strong>Auto Scaling Group</strong>.
</p>

<p>
Use the buttons below to simulate CPU load and observe scaling events.
</p>

<div class="meter">
    <span id="cpu-percentage-meter" style="width:0%;"></span>
</div>

<p id="cpu-text" style="margin-top:20px;">
CPU Usage: 0%
</p>

<button onclick="increaseLoad()">
Increase CPU Load
</button>

<button onclick="cancelLoad()">
Cancel Load
</button>

<p style="margin-top:20px;">
Built by
<span class="branding">Vandit Jaiswal</span>
</p>

<p style="color:#d1d5db;">
AWS • EC2 • Auto Scaling Group • CloudWatch • Flask • Stress
</p>

<script>

function updateCpuUsage(){

    fetch('/cpu_percentage')
    .then(response => response.json())
    .then(data => {

        const percentage = data.cpu;

        document.getElementById('cpu-percentage-meter').style.width =
            percentage + '%';

        document.getElementById('cpu-text').innerText =
            'CPU Usage: ' + percentage + '%';

    });

}

function increaseLoad(){
    fetch('/increase_load');
}

function cancelLoad(){
    fetch('/cancel_load');
}

setInterval(updateCpuUsage,2000);

</script>

</body>
</html>

""", hostname=hostname)


@app.route('/cpu_percentage')
def cpu_percentage():
    return jsonify(cpu=psutil.cpu_percent(interval=1))


@app.route('/increase_load')
def increase_load():
    global stress_process

    if not stress_process:
        stress_process = subprocess.Popen(['stress', '--cpu', '1'])

    return jsonify(status='Load Increased')


@app.route('/cancel_load')
def cancel_load():
    global stress_process

    if stress_process:
        subprocess.run(['pkill', 'stress'])
        stress_process = None

    return jsonify(status='Load Cancelled')


if __name__ == "__main__":
    app.run(host='0.0.0.0', port=8080)

EOF

# Set the correct permissions
sudo chown ec2-user:ec2-user /home/ec2-user/app.py

# Start the Flask app
sudo -u ec2-user nohup python3 /home/ec2-user/app.py &