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
        endpoint='/log',
        method='GET',
        body={},
        expected_code=200,
        expected_content={'message': ''},
    ),
    Case(
        name='Log food',
        endpoint='/log/food',
        method='POST',
        body={'name': 'Banana'},
        expected_code=200,
        expected_content={'name': 'Banana'}
    ),
]
