import os
from dotenv import load_dotenv

from typing import Literal, cast

load_dotenv()

_edamam_api_key = os.environ.get('EDAMAM_API_KEY')
_edamam_app_id = os.environ.get('EDAMAM_APP_ID')
_port = os.environ.get('PORT')
_env_mode = os.environ.get('ENV_MODE', 'DEV')

_db_name = os.environ.get('DB_NAME', 'COUNT')
_db_user = os.environ.get('DB_USER')
_db_pass = os.environ.get('DB_PASS', '')
_db_host = os.environ.get('DB_HOST', 'localhost')
_db_port = os.environ.get('DB_PORT', '5432')

if _env_mode not in ['PROD', 'DEV', 'TEST']:
    _env_mode = 'DEV'

if not all([
    _edamam_api_key,
    _edamam_api_key,
    _db_user,
]):
    raise EnvironmentError('Environment variables not found.')

type EnvModeT = Literal['PROD', 'DEV', 'TEST']


EDAMAM_API_KEY = cast(str, _edamam_api_key)
EDAMAM_APP_ID = cast(str, _edamam_app_id)
PORT: int = int(_port or '727')
ENV_MODE: EnvModeT = cast(EnvModeT, _env_mode)
DB_NAME = _db_name
DB_URL = f'postgresql://{cast(str, _db_user)}:{_db_pass}@{_db_host}:{_db_port}/{_db_name}'
