from dataclasses import dataclass
from typing import Literal, Any

from case import Case
from datetime import datetime


cases: list[Case] = [
    Case(
        name='Root',
        description='Test the connection to the backend.',
        method='GET',
        endpoint='/',
    ).expects(200, content={'message': 'Hello World!'}),
    Case(
        name='Get user data',
        description='Requests the user data of id 1',
        method='GET',
        endpoint='/user?user_id=1',
    ).expects(200, check=lambda res: None if res.get('user_name', '') == 'Hout Manut' else f'Expected to contains "Hout Manut" got {res}'),
    Case(
        name='Upload image',
        description='Simulates the user uploading an image of a burger to be scanned.',
        method='POST',
        endpoint='/log/scan',
        image_path='assets/download.jpg',
    ).expects(200, check=lambda res: None if res['foods'][0]['class_name'] == 'hamburger' else f'Expected "hamburger" got {res}'),
    Case(
        name='Save data',
        description='Saved the scanned data to the backend',
        method='POST',
        endpoint='/log/food/?user_id=1',
        body={
            'name': 'My breakfast',
            'meal_type': 'Breakfast',
            'date': datetime.now().isoformat(),
            'foods': [
                {
                    'name': 'Hamburger',
                    'serving_size': 1.0,
                    'unit': 'item',
                    'calories': 254,
                    'protein_g': 17.2,
                    'carbs_g': 0,
                    'fat_g': 20,
                }
            ],
        },
    ).expects(200),
]
