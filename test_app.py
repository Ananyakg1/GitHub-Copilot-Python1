import pytest
import json
from app import app, change


@pytest.fixture
def client():
    """Create a test client for the Flask application."""
    app.config['TESTING'] = True
    with app.test_client() as client:
        yield client


def test_change_function():
    """Test the change calculation function."""
    assert [{5: 'quarters'}, {1: 'nickels'}, {4: 'pennies'}] == change(1.34)
    assert [{1: 'quarters'}] == change(0.25)
    assert [{4: 'pennies'}] == change(0.04)


def test_health_endpoint(client):
    """Test the health check endpoint."""
    response = client.get('/health')
    assert response.status_code == 200
    data = json.loads(response.data)
    assert data['status'] == 'healthy'
    assert 'timestamp' in data


def test_hello_endpoint(client):
    """Test the hello endpoint."""
    response = client.get('/')
    assert response.status_code == 200
    data = json.loads(response.data)
    assert data['status'] == 'healthy'
    assert 'message' in data
    assert 'timestamp' in data


def test_change_endpoint(client):
    """Test the change calculation endpoint."""
    response = client.get('/change/1/34')
    assert response.status_code == 200
    data = json.loads(response.data)
    assert data['input'] == '$1.34'
    assert 'change' in data
    assert 'timestamp' in data
    assert data['change'] == [{'5': 'quarters'}, {'1': 'nickels'}, {'4': 'pennies'}]


def test_change_endpoint_invalid_input(client):
    """Test the change endpoint with invalid input."""
    response = client.get('/change/invalid/input')
    assert response.status_code == 400
    data = json.loads(response.data)
    assert 'error' in data
    assert 'timestamp' in data


def test_change_endpoint_edge_cases(client):
    """Test edge cases for the change endpoint."""
    # Test with zero
    response = client.get('/change/0/00')
    assert response.status_code == 200
    data = json.loads(response.data)
    assert data['change'] == []  # No change needed for $0.00
    
    # Test with quarters only
    response = client.get('/change/0/25')
    assert response.status_code == 200
    data = json.loads(response.data)
    assert data['change'] == [{'1': 'quarters'}]