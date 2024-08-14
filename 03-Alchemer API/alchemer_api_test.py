import requests, config, os
import alchemer_client as ac
import copy

# # Make the API call

total_pages = response['total_pages']

custom_params = copy.deepcopy(config.params)

for i in range(total_pages):
    custom_params['page'] = i+1
    current_page = requests.get(config.url_with_auth,params=custom_params).json()
    for survey in current_page['data']:
        if 'test' in survey['title'].lower():
            print(survey['title'],survey['id'])

