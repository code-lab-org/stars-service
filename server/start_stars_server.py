#!/usr/bin/env python3

from flask import render_template
import connexion

from swagger_server import encoder

import shutil



def main():
    shutil.copy('sys/template.json', 'out/service.json')
    app = connexion.App(__name__, specification_dir='./swagger/')
    app.app.json_encoder = encoder.JSONEncoder
    app.add_api('swagger.yaml', arguments={'title': 'STARS Service'})
    
    # Create a URL route in our application for "/"
    @app.route("/")
    def home():
        return render_template("index.html")
    
    app.run(host="0.0.0.0", port=8080, debug=True)


if __name__ == '__main__':
    main()
