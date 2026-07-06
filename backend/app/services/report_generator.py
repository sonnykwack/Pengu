import json
import os

from anthropic import Anthropic

SYSTEM_PROMPT = (
    "당신은 요양보호 앱의 보고서 작성 보조원입니다. 환자가 말한 증상을 보고, "
    "보호자가 빠르게 상황을 파악할 수 있는 한국어 리포트를 작성하세요. "
    "다른 말 없이 반드시 아래 JSON 형식으로만 답하세요:\n"
    '{"summary": "한두 문장 요약", "severity": "경증|중등도|응급", '
    '"recommended_action": "보호자가 지금 해야 할 행동"}'
)


def get_client() -> Anthropic:
    return Anthropic(api_key=os.environ["ANTHROPIC_API_KEY"])


def generate_report(symptom_text: str, client: Anthropic) -> dict:
    message = client.messages.create(
        model="claude-sonnet-5",
        max_tokens=300,
        system=SYSTEM_PROMPT,
        messages=[{"role": "user", "content": symptom_text}],
    )
    return json.loads(message.content[0].text)
