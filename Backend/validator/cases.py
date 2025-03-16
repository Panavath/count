from dataclasses import dataclass
from typing import Literal, Any

__all__ = [
    'URL',
    'Case',
    'cases',
]

URL = 'http://127.0.0.1:727'


@dataclass
class Case:
    name: str
    endpoint: str
    method: Literal['GET', 'POST', 'PUT', 'DELETE', 'OPTION', 'PATCH']
    body: dict[str, Any]
    expected_code: int
    expected_content: dict[str, Any]
    image_path: str | None = None
    image_type: Literal['image/jpeg', 'image/png'] | None = None


cases: list[Case] = [
    Case(
        name='Root',
        endpoint='/',
        method='GET',
        body={},
        expected_code=200,
        expected_content={'message': 'Hello World!'},
    ),
    Case(
        name='Log',
        endpoint='/log/',
        method='GET',
        body={},
        expected_code=200,
        expected_content={'message': ''},
    ),
    Case(
        name='Upload image',
        endpoint='/log/food?user_id=1',
        method='POST',
        body={'name': 'food', 'meal_type': 'Breakfast', 'time': '2025-03-15T14:30:00Z', 'foods': []},
        expected_code=200,
        expected_content={},
        # image_path='assets/alot.jpg',
        # image_type='image/jpeg',
    ),
]
