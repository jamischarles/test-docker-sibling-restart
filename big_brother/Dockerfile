FROM alpine
RUN apk add --update curl
ADD . /code
WORKDIR /code

# wait 5 seconds (so little brother is running)
CMD sleep 5 && ./code/restartSibling.sh
