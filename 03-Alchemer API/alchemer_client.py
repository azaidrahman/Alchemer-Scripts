import requests

class AlchemerClient:
    def __init__(self, api_token, api_token_secret, base_url="https://api.alchemer.com/v5"):
        self.api_token = api_token
        self.api_token_secret = api_token_secret
        self.base_url = base_url

    def initialize_sub_objects(self):
        self.survey = Survey(self)
        self.survey_page = SurveyPage(self)
        self.survey_question = SurveyQuestion(self)
        self.quotas = Quotas(self)

    def _make_request(self, endpoint, params=None, method='GET'):
        full_url = f"{self.base_url}/{endpoint}"
        params = params or {}
        params['api_token'] = self.api_token
        params['api_token_secret'] = self.api_token_secret
        response = requests.request(method, full_url, params=params)
        return response.json()

class Survey:
    def __init__(self, client):
        self.client = client

    def get(self, survey_id, page=None, resultsperpage=None, filters=None):
        params = {}
        if page is not None:
            params['page'] = page
        if resultsperpage is not None:
            params['resultsperpage'] = resultsperpage
        if filters is not None:
            for i, (field, operator, value) in enumerate(filters):
                params[f'filter[field][{i}]'] = field
                params[f'filter[operator][{i}]'] = operator
                params[f'filter[value][{i}]'] = value
        return self.client._make_request(f"survey/{survey_id}", params)

    def create(self, title, survey_type="survey"):
        params = {'title': title, 'type': survey_type}
        return self.client._make_request("survey", params, method='PUT')

    def update(self, survey_id, update_fields):
        return self.client._make_request(f"survey/{survey_id}", update_fields, method='POST')


class SurveyPage:
    def __init__(self, client):
        self.client = client

    def list(self, survey_id):
        return self.client._make_request(f"survey/{survey_id}/surveypage")

class SurveyQuestion:
    def __init__(self, client):
        self.client = client

    def list(self, survey_id):
        return self.client._make_request(f"survey/{survey_id}/surveyquestion")

    def create(self, survey_id, question_data):
        params = {'_method': 'PUT'}
        params.update(question_data)
        return self.client._make_request(f"survey/{survey_id}/surveyquestion", params)

class Quotas:
    def __init__(self, client):
        self.client = client

    def list(self, survey_id):
        return self.client._make_request(f"survey/{survey_id}/quota")

# Usage:
client = AlchemerClient(api_token="your_token", api_token_secret="your_token_secret")
