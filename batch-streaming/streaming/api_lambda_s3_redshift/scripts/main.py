import os
from flask import jsonify, make_response, Response
from datetime import datetime
from common import sns_client, carga_terranova_client
from common.ingestion_function_wrapper import ingestion_function
from flask import jsonify, make_response
from marshmallow import Schema, fields, validate, INCLUDE
import json

VALID_OPTION_PARAMETERS = (
    "goodday", "macroindicator", "gooddaytask", "indleaderroute", "liderroute",
    "indleaderroutevalue", "registrations", "checklists", "criticalities",
    "levelsubareas", "macroindicators", "macroprocesses", "operationalkpis",
    "origensinfos", "pillars", "processes", "questions", "responsibles", "routes",
    "shifts", "status", "subareas", "subroutes", "typenotes", "units", "satisfaction",
    "shiftchanges", "unconformities", "users", "tasks_un", "value", "headerapproach",
    "valueapproach", "leadershipmetas", "member", "note", "sector", "situation",
    "feature_flags", "goodday_areas", "goodday_attendance", "calendar_agr", "equipment",
    "farm", "header_agr", "note_agr", "question_agr", "tasks_agr", "unconformities_agr",
    "value_agr", "value_equipment_agr", "actionplan", "administration", "aspect"
)

class InputSchema(Schema):
    option = fields.Str(required=True, validate=validate.OneOf(VALID_OPTION_PARAMETERS))
    class Meta:
        unknown = INCLUDE

@ingestion_function(input_schema=InputSchema())
def terranova_ingestion(params: dict):
    print("Parâmetros recebidos:", params)

    if 'option' not in params:
        return response_model("error", message="Campo 'option' ausente", status_code=400)

    current_hour = datetime.now().hour
    final_params = params.copy()
    final_params['requisition_time'] = current_hour
    option = params['option']

    try:
        print("Iniciando processo com a opção:", option)
        carga_terranova_client.prep(option)
    except ValueError as e:
        print("Erro de valor:", e)
        return response_model("error", message=str(e), status_code=400)
    except Exception as e:
        print("Erro no processo:", e)
        return response_model("error", message="Erro no processo", details=str(e), status_code=500)

def response_model(status, message=None, details=None, status_code=200):
    if isinstance(message, Response):
        try:
            message = message.get_json() if message.is_json else message.get_data(as_text=True)
        except Exception:
            message = str(message)
    if not isinstance(message, (dict, str)):
        message = str(message)

    response_data = {
        "status": status,
        "message": message,
        "details": details
    }

    response_data = {k: v for k, v in response_data.items() if v is not None}
    return make_response(jsonify(response_data), status_code)
