from flask import Flask, request, jsonify
import sys
import io

app = Flask(__name__)

@app.route('/execute', methods=['POST'])
def execute():
    code = request.json.get('code')  # Extract code from the request body
    old_stdout = sys.stdout
    redirected_output = sys.stdout = io.StringIO() 
    try:
        exec(code)  # Execute the Python code sent from the client side 
        output = redirected_output.getvalue()  # Capture the output
    except Exception as e:
        output = str(e)  # In case of an error, return the exception message..
    finally:
        sys.stdout = old_stdout 
    return jsonify({'output': output}) 

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)  # Listen on all available IPs and port 5000
