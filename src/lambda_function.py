import ssl
import socket
import random
import time
import hashlib
import json
import os
import boto3

# Initialize AWS clients
ssm_client = boto3.client('ssm')
secrets_manager_client = boto3.client('secretsmanager')
region = os.environ['REGION']

# Helper function to fetch configuration from SSM
def fetch_config():
    parameter_name = os.environ['SSM_PARAMETER_PATH']
    try:
        print(f"Fetching config from SSM parameter: {parameter_name}")
        response = ssm_client.get_parameter(Name=parameter_name, WithDecryption=True)
        config = json.loads(response['Parameter']['Value'])
        print("Config successfully fetched from SSM.")
        return config
    except Exception as e:
        print(f"Error fetching config from SSM: {e}")
        raise

# Helper function to fetch TLS certificate and key from Secrets Manager
def fetch_tls_cert_key():
    cert_name = os.environ['TLS_CERT_SECRET_NAME']
    key_name = os.environ['TLS_KEY_SECRET_NAME']
    try:
        print(f"Fetching TLS cert from Secrets Manager: {cert_name}")
        cert_response = secrets_manager_client.get_secret_value(SecretId=cert_name)
        print(f"Fetching TLS key from Secrets Manager: {key_name}")
        key_response = secrets_manager_client.get_secret_value(SecretId=key_name)

        cert = cert_response['SecretString']
        key = key_response['SecretString']

        # Save cert and key to /tmp for use during the session
        cert_file_path = '/tmp/tls_cert.pem'
        key_file_path = '/tmp/tls_key.pem'

        with open(cert_file_path, 'w') as cert_file:
            cert_file.write(cert)
        print("TLS cert saved to /tmp/tls_cert.pem.")

        with open(key_file_path, 'w') as key_file:
            key_file.write(key)
        print("TLS key saved to /tmp/tls_key.pem.")

        return cert_file_path, key_file_path
    except Exception as e:
        print(f"Error fetching TLS secrets from Secrets Manager: {e}")
        raise

# Helper function to establish a TLS connection
def tls_connect(host, port, cert_path, key_path):
    print(f"Establishing TLS connection to {host}:{port}")
    context = ssl.create_default_context(ssl.Purpose.CLIENT_AUTH)
    context.load_cert_chain(certfile=cert_path, keyfile=key_path)
    connection = context.wrap_socket(socket.socket(socket.AF_INET), server_hostname=host)
    connection.connect((host, port))
    print("TLS connection established successfully.")
    return connection

# Helper function to compute SHA1 hash
def SHA1(data):
    return hashlib.sha1(data.encode('utf-8')).hexdigest()

# Helper function to generate a random string
def random_string(length=8):
    chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!\"#$%&'()*+,-./:;<=>?@[\\]^_`{|}~"
    return ''.join(random.choice(chars) for _ in range(length))

# Main Lambda handler
def lambda_handler(event, context):
    print("Lambda function started.")

    # Fetch configuration and TLS cert/key from secrets
    try:
        config = fetch_config()
        cert_path, key_path = fetch_tls_cert_key()
    except Exception as e:
        print(f"Initialization error: {e}")
        return {"statusCode": 500, "body": f"Initialization error: {e}"}

    host = config['server']['host']
    port = int(config['server']['port'])
    pow_timeout = int(config['timeouts']['pow_timeout'])
    user_info = config['user_info']

    # Establish TLS connection
    try:
        conn = tls_connect(host, port, cert_path, key_path)
    except Exception as e:
        print(f"Failed to connect to the server: {e}")
        return {"statusCode": 500, "body": "Failed to connect"}

    authdata = ""

    try:
        while True:
            data = conn.recv(1024).decode('utf-8').strip()
            args = data.split(' ')

            print(f"Received command: {args[0]}")

            if args[0] == "HELO":
                print("Sending response: TOAKUEI")
                conn.sendall("TOAKUEI\n".encode('utf-8'))

            elif args[0] == "ERROR":
                print(f"Server returned ERROR: {' '.join(args[1:])}")
                break

            elif args[0] == "POW":
                authdata, difficulty = args[1], int(args[2])
                print(f"Starting POW challenge with difficulty {difficulty}")
                start_time = time.time()
                while True:
                    suffix = random_string()
                    cksum_in_hex = SHA1(authdata + suffix)
                    if cksum_in_hex.startswith("0" * difficulty):
                        print(f"POW solved with suffix: {suffix}")
                        conn.sendall((suffix + "\n").encode('utf-8'))
                        break

            elif args[0] == "END":
                print("Sending response: OK")
                conn.sendall("OK\n".encode('utf-8'))
                break

            elif args[0] in ["NAME", "MAILNUM", "MAIL1", "SKYPE", "BIRTHDATE", "COUNTRY", "ADDRNUM", "ADDRLINE1"]:
                response = SHA1(authdata + args[1]) + " " + user_info[args[0].lower()] + "\n"
                print(f"Responding to {args[0]} with: {response.strip()}")
                conn.sendall(response.encode('utf-8'))

    except Exception as e:
        print(f"Error during communication: {e}")
        return {"statusCode": 500, "body": "Internal server error"}

    finally:
        print("Closing connection.....")
        conn.close()

    print("Lambda function completed successfully.")
    return {"statusCode": 200, "body": "Connection closed successfully."}
