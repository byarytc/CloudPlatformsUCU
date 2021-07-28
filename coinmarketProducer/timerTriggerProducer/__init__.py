import datetime
import logging
import json
import azure.functions as func
from requests import Request, Session
from requests.exceptions import ConnectionError, Timeout, TooManyRedirects


def main(mytimer: func.TimerRequest) -> str:
    utc_timestamp = datetime.datetime.utcnow().replace(
        tzinfo=datetime.timezone.utc).isoformat()

    if mytimer.past_due:
        logging.info('The timer is past due!')

    logging.info('Python timer trigger function ran at %s', utc_timestamp)

    url = 'https://pro-api.coinmarketcap.com/v1/cryptocurrency/quotes/latest'
    parameters = {
    'convert':'USD',
    'symbol':'BTC,ETH,XRP,ADA,DOT'
    }
    headers = {
    'Accepts': 'application/json',
    'X-CMC_PRO_API_KEY': '716dc50a-7e77-40e2-8da1-1fd37a023741',
    }

    session = Session()
    session.headers.update(headers)

    try:
        response = session.get(url, params=parameters)
        data = json.loads(response.text)
        timestamp = datetime.datetime.utcnow()

        eventContent = {
        "body": data,
        "processedAt": f'{timestamp}'
        }

    except (ConnectionError, Timeout, TooManyRedirects) as e:
        print(e)

    return json.dumps(eventContent)