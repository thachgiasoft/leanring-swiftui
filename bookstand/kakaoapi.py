import requests
import pprint
import json

"""
GET /v3/search/book HTTP/1.1
Host: dapi.kakao.com
Authorization: KakaoAK {app_key}


curl -v -X GET "https://dapi.kakao.com/v3/search/book?target=title" \
--data-urlencode "query=이기적 유전자" \
-H "Authorization: KakaoAK 57ee879cb839006ba4c51db31d1b7d99" | python -mjson.tool

"""

key = '57ee879cb839006ba4c51db31d1b7d99'
url = 'https://dapi.kakao.com/v3/search/book?target=author'
headers = {'Authorization' : 'KakaoAK 57ee879cb839006ba4c51db31d1b7d99'}

result = requests.get(url = url, params={'query' : '칼 세이건'}, headers=headers)


pprint.pprint(result.json()['documents'][0])
