# Pootle-Serge.io container - docker-compose
# alpine:3.11

## contains

    - pootle
    - redis
    - postgresql
    - nginx (unused)
    - serge

## run

 ```
 git clone https://github.com/olista94/pootle.git pootle
 cd pootle
 cp env-example .env
 $EDITOR .env # do not use ""
 docker-compose build
 docker-compose up
 docker exec -it pootle_pootle_1 bash (to open bash in container)
 
 ```
## note
    - Before doing `docker-compose build`, delete `.enviroment` file first
## use

 nginx listen `localhost:80` and pootle `localhost:8000` (same interface)
