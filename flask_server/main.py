from flask import Flask, request, jsonify
import subprocess

app = Flask(__name__)

@app.route('/execute', methods=['POST'])
def execute_code():
    try:
        data = request.json
        code = data['code']

        # You can save the code to a file and then execute it
        with open('temp_code.py', 'w') as f:
            f.write(code)

        # Run the python code
        result = subprocess.run(['python', 'temp_code.py'], capture_output=True, text=True)
        
        return jsonify({'output': result.stdout})
    except Exception as e:
        return jsonify({'error': str(e)})

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5000)
