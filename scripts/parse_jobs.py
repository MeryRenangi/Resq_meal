import json, re

path = r'C:\Users\meryr\.gemini\antigravity-ide\brain\5bb1fb21-4333-465a-8aec-51d22e5a22bd\.system_generated\steps\89\content.md'
with open(path, encoding='utf-8') as f:
    content = f.read()

# Remove control characters
content_clean = re.sub(r'[\x00-\x08\x0b\x0c\x0e-\x1f]', '', content)
start = content_clean.find('{')
data = json.loads(content_clean[start:])

print('=== E2E-TESTING.YML JOBS ===')
for job in data['jobs']:
    status = job['conclusion']
    print(f'  Job: {job["name"]} -> {status}')
    for step in job['steps']:
        if step['conclusion'] in ('failure', 'skipped'):
            print(f'    [{step["conclusion"].upper()}] Step: {step["name"]}')
