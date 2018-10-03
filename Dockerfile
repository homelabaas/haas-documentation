FROM python:3.7

# Mount your dev working folder into /app to make this work
WORKDIR /app

RUN pip install mkdocs

EXPOSE 8000
ENTRYPOINT [ "mkdocs", "serve", "--dev-addr=0.0.0.0:8000" ]