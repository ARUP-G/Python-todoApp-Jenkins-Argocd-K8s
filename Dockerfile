FROM python:3.9
RUN pip install django==3.2

WORKDIR /app

COPY /todo-app .

RUN python manage.py migrate

EXPOSE 8000
CMD ["python","manage.py","runserver","0.0.0.0:8000"]
