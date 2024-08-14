import json
from dotenv import load_dotenv
import os

# Get the directory of the current script
script_dir = os.path.dirname(os.path.abspath(__file__))

# Create the path to the .env file
env_path = os.path.join(script_dir, '.env')

# Load the .env file
load_dotenv(env_path)



api_token = os.getenv("ALCHEMER_API_TOKEN")
api_token_secret = os.getenv("ALCHEMER_API_TOKEN_SECRET")
base_url = 'https://api.alchemer.com/v5'
survey_level = '/survey'

params = {
    'api_token': api_token,
    'api_token_secret': api_token_secret
}

url_with_auth = f"{base_url}{survey_level}"