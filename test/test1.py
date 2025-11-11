from datetime import datetime, timedelta
now = datetime.now()

dates=[]
for i in range(4):
    date = now - timedelta(days=i)
    dates.append(date.strftime('%Y-%m-%d'))
    print(date.strftime('%Y-%m-%d'))