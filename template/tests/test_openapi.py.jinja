from __future__ import annotations

from fastapi.testclient import TestClient

from {{ package_name }}.main import create_app


def test_openapi_contains_expected_routes() -> None:
    app = create_app()
    client = TestClient(app)

    response = client.get("/openapi.json")
    assert response.status_code == 200

    data = response.json()
    paths = data["paths"]

    assert "/health" in paths
    assert "/api/v1/ping" in paths
