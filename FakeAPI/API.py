from flask import Flask, jsonify
from flask_cors import CORS


app = Flask(__name__)
CORS(app)
# Lista de usuarios fake
usuarios = [
    {"nombre": "Juan Pérez", "edad": 25, "correo": "juan.perez@example.com"},
    {"nombre": "María López", "edad": 30, "correo": "maria.lopez@example.com"},
    {"nombre": "Carlos Gómez", "edad": 22, "correo": "carlos.gomez@example.com"},
    {"nombre": "Ana Martínez", "edad": 28, "correo": "ana.martinez@example.com"},
    {"nombre": "Luis Torres", "edad": 35, "correo": "luis.torres@example.com"},
    {"nombre": "Sofía Hernández", "edad": 29, "correo": "sofia.hernandez@example.com"},
    {"nombre": "Diego Castillo", "edad": 24, "correo": "diego.castillo@example.com"},
    {"nombre": "Gabriela Rivera", "edad": 31, "correo": "gabriela.rivera@example.com"},
    {"nombre": "Javier Chávez", "edad": 26, "correo": "javier.chavez@example.com"},
    {"nombre": "Camila Ortiz", "edad": 27, "correo": "camila.ortiz@example.com"}
]

@app.route('/api/usuarios', methods=['GET'])
def obtener_usuarios():
    return jsonify(usuarios)

if __name__ == '__main__':
    app.run(debug=True)

"""
from flask import Flask, jsonify
from flask_cors import CORS

app = Flask(__name__)
CORS(app)  # Habilita CORS en toda la app

@app.route('/api/usuarios', methods=['GET'])
def obtener_usuarios():
    usuarios = [
        {"nombre": "Juan", "edad": 25, "correo": "juan@example.com"},
        {"nombre": "María", "edad": 30, "correo": "maria@example.com"},
        {"nombre": "Luis", "edad": 22, "correo": "luis@example.com"},
        {"nombre": "Ana", "edad": 28, "correo": "ana@example.com"},
        {"nombre": "Carlos", "edad": 35, "correo": "carlos@example.com"},
        {"nombre": "Lucía", "edad": 27, "correo": "lucia@example.com"},
        {"nombre": "Pedro", "edad": 29, "correo": "pedro@example.com"},
        {"nombre": "Elena", "edad": 32, "correo": "elena@example.com"},
        {"nombre": "José", "edad": 31, "correo": "jose@example.com"},
        {"nombre": "Paula", "edad": 26, "correo": "paula@example.com"}
    ]
    return jsonify(usuarios)
"""
