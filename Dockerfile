FROM python:3.12.7-alpine3.20

EXPOSE 5000

WORKDIR /app

COPY requirements.txt .

RUN pip install -r requirements.txt

COPY wsgi.py config.py ./
COPY application/ application/

CMD ["python", "wsgi.py"]