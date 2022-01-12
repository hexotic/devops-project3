# From https://docs.docker.com/samples/django/
FROM python:3
WORKDIR /code
COPY requirements.txt /code/
RUN pip install -r requirements.txt
COPY . /code/
EXPOSE 8000
RUN chmod +x entry_point.sh
CMD [ "./entry_point.sh" ]
