import os
import traceback  
import requests
from common import secret_client_aws as secret_client, firehose_client
from requests.auth import HTTPBasicAuth
import json
import unicodedata 

URL_BASE = os.environ.get("URL_BASE", "https://api.terranova.com/v1/")

OPTION_LIST = {
    "goodday": "goodday/v1/goodday/",
    "macroindicator": "goodday/v1/macroindicator/",
    "gooddaytask": "goodday/v1/task/",
    "indleaderroute": "indleaderroute/v1/header/",
    "liderroute": "indleaderroute/v1/liderroute/",
    "indleaderroutevalue": "indleaderroute/v1/value/",
    "registrations": "registrations/v1/aspects/",
    "checklists": "registrations/v1/checklists/",
    "criticalities": "registrations/v1/criticalities/",
    "levelsubareas": "registrations/v1/levelsubareas/",
    "macroindicators": "registrations/v1/macroindicators/",
    "macroprocesses": "registrations/v1/macroprocesses/",
    "operationalkpis": "registrations/v1/operationalkpis/",
    "origensinfos": "registrations/v1/origensinfos/",
    "pillars": "registrations/v1/pillars/",
    "processes": "registrations/v1/processes/",
    "questions": "registrations/v1/questions/",
    "responsibles": "registrations/v1/responsibles/",
    "routes": "registrations/v1/routes/",
    "shifts": "registrations/v1/shifts/",
    "status": "registrations/v1/status/",
    "subareas": "registrations/v1/subareas/",
    "subroutes": "registrations/v1/subroutes/",
    "typenotes": "registrations/v1/typenotes/",
    "units": "registrations/v1/units/",
    "satisfaction": "satisfaction_survey/v1/satisfaction_survey/",
    "shiftchanges": "shiftchange/v1/shiftchanges/",
    "unconformities": "unconformities/v1/unconformities/",
    "users": "users/",
    "tasks_un": "unconformities/v1/tasks/",
    "value": "indleaderroute/v1/value/",
    "headerapproach": "approach/v1/headerapproach/",
    "valueapproach": "approach/v1/valueapproach/",
    "leadershipmetas": "approach/v1/leadershipmetas/",
    "member": "approach/v1/member/",
    "note": "approach/v1/note/",
    "sector": "approach/v1/sector/",
    "situation": "approach/v1/situation/",
    "feature_flags": "feature_flags/v1/feature_flags/",
    "goodday_areas": "goodday/v1/goodday_areas/",
    "goodday_attendance": "goodday/v1/goodday_attendance/",
    "calendar_agr": "agrleader_route/v1/calendar_agr/",
    "equipment": "agrleader_route/v1/equipment/",
    "farm": "agrleader_route/v1/farm/",
    "header_agr": "agrleader_route/v1/header_agr/",
    "note_agr": "agrleader_route/v1/note_agr/",
    "question_agr": "agrleader_route/v1/question_agr/",
    "tasks_agr": "agrleader_route/v1/tasks_agr/",
    "unconformities_agr": "agrleader_route/v1/unconformities_agr/",
    "value_agr": "agrleader_route/v1/value_agr/",
    "value_equipment_agr": "agrleader_route/v1/value_equipment_agr/",
    "actionplan": "approach/v1/actionplan/",
    "administration": "approach/v1/administration/",
    "aspect": "approach/v1/aspect/"
}

def corrigir_acentos(text):
    text = unicodedata.normalize('NFD', text)
    return ''.join([char for char in text if not unicodedata.combining(char)])

def corrigir_json(json_string):
    data = json.loads(json_string)
    for key in data:
        if isinstance(data[key], str):
            data[key] = corrigir_acentos(data[key])
    return json.dumps(data)

def lambda_handler(event, context):
    option = event.get("option")
    if not option:
        return {"statusCode": 400, "body": json.dumps({"error": "Parâmetro 'option' é obrigatório"})}

    if option not in OPTION_LIST:
        return {"statusCode": 400, "body": json.dumps({"error": f"Opção inválida: {option}"})}

    api_url = f'{URL_BASE}/{OPTION_LIST[option]}'
    username = secret_client.get_credential("carga_agronex_user")
    password = secret_client.get_credential("carga_agronex_pass")
    auth = HTTPBasicAuth(username, password)

    published = 0
    while api_url:
        try:
            response = requests.get(api_url, auth=auth, timeout=90)
            response.raise_for_status()
        except Exception as e:
            return {"statusCode": 500, "body": json.dumps({"error": str(e)})}

        data = response.json()
        results = data.get("results", []) if isinstance(data, dict) else data
        if not isinstance(results, list):
            return {"statusCode": 500, "body": json.dumps({"error": "Formato de resposta inválido"})}

        for result in results:
            result_str = corrigir_json(json.dumps(result))
            message_str = f"rota/{option}: {result_str}"
            try:
                firehose_client.publish(message_str, option)
                published += 1
            except Exception:
                continue

        api_url = data.get("next") if isinstance(data, dict) else None

    return {"statusCode": 200, "body": json.dumps({"mensagens_publicadas": published})}
