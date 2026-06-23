import json, glob, os
from collections import Counter

files = [f for f in glob.glob(os.path.expanduser('~/Library/Application Support/Claude/local-agent-mode-sessions/*/*/local_*.json')) if not os.path.isdir(f)]
titles, models, tools, folders = [], Counter(), Counter(), set()
dates = []
for f in files:
    try:
        with open(f) as fh:
            d = json.load(fh)
        titles.append(d.get('title','')[:80])
        m = d.get('model','')
        if m: models[m] += 1
        for t in d.get('enabledMcpTools',{}):
            tools[t.split('__')[-1] if '__' in t else t] += 1
        for s in d.get('remoteMcpServersConfig',[]):
            n = s.get('name','')
            if n: tools[n] += 1
        for fo in d.get('userSelectedFolders',[]):
            folders.add(fo)
        c = d.get('createdAt')
        if c: dates.append(c)
    except: continue

dates.sort()
print(f'SESSIONS: {len(files)}')
print(f'DATE_RANGE: {dates[0][:10] if dates else "?"} to {dates[-1][:10] if dates else "?"}')
print(f'MODELS: {dict(models.most_common(3))}')
print(f'TOP_TOOLS: {[t for t,_ in tools.most_common(20)]}')
print(f'FOLDERS: {list(folders)[:5]}')
print(f'TITLES: {titles[:15]}')
