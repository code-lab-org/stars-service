#!/usr/bin/env python3

import connexion

from swagger_server import encoder

import shutil

def main():
    shutil.copy('sys/template.json', 'out/service.json')
    app = connexion.App(__name__, specification_dir='./swagger/')
    app.app.json_encoder = encoder.JSONEncoder
    app.add_api('swagger.yaml', arguments={'title': 'STARS Service'})
    app.run(port=8080)


if __name__ == '__main__':
    main()
