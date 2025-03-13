import os
from dotenv import load_dotenv

from typing import Literal, cast

load_dotenv()

_edamam_api_key = os.environ.get('EDAMAM_API_KEY')
_edamam_app_id = os.environ.get('EDAMAM_APP_ID')
_port = os.environ.get('PORT')
_env_mode = os.environ.get('ENV_MODE', 'DEV')
_database_url = os.environ.get('DATABASE_URL')

if _env_mode not in ['PROD', 'DEV', 'TEST']:
    _env_mode = 'DEV'

if not all([_edamam_api_key, _edamam_api_key, _database_url]):
    raise EnvironmentError('Enviroment variables not found.')

type EnvModeT = Literal['PROD', 'DEV', 'TEST']


EDAMAM_API_KEY = cast(str, _edamam_api_key)
EDAMAM_APP_ID = cast(str, _edamam_app_id)
PORT: int = int(_port or '727')
ENV_MODE: EnvModeT = cast(EnvModeT, _env_mode)
DATABASE_URL = cast(str, _database_url)
