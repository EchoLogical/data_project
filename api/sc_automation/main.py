"""
Flask Hello World app for sc_automation.

Usage:
- Import the app factory: from api.sc_automation import create_app
- Run directly: python -m api.sc_automation
"""
from __future__ import annotations

import os
from flask import Flask
from api.sc_automation.config import init_postgres


def create_app() -> Flask:
    """Application factory for the sc_automation Flask app.

    Returns:
        A configured Flask application with a Hello World route.
    """
    app = Flask(__name__)

    # Initialize optional PostgreSQL configuration/connection helpers
    init_postgres(app)

    @app.get("/")
    def hello_world() -> str:
        return "Hello, World!"

    # Optional simple health endpoint commonly used in automations/CI
    @app.get("/health")
    def health() -> str:
        return "OK"

    return app


def main() -> None:
    """Entrypoint for `python -m api.sc_automation`."""
    app = create_app()
    host = os.environ.get("FLASK_HOST", "0.0.0.0")
    try:
        port = int(os.environ.get("FLASK_PORT", "5000"))
    except ValueError:
        port = 5000
    debug = os.environ.get("FLASK_DEBUG", "false").lower() in {"1", "true", "yes", "on"}
    app.run(host=host, port=port, debug=debug)


if __name__ == "__main__":
    main()
