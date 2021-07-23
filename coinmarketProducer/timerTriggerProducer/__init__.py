import datetime
import logging
import json
import azure.functions as func


def main(mytimer: func.TimerRequest) -> str:
    utc_timestamp = datetime.datetime.utcnow().replace(
        tzinfo=datetime.timezone.utc).isoformat()

    if mytimer.past_due:
        logging.info('The timer is past due!')

    logging.info('Python timer trigger function ran at %s', utc_timestamp)

    body = "This is test message"
    timestamp = datetime.datetime.utcnow()

    eventContent = {
        "body": body,
        "processedAt": f'{timestamp}'
        }

    return json.dumps(eventContent)