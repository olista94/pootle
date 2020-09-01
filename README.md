# Pootle container - docker-compose

## contains

    - pootle
    - redis
    - postgresql
    - serge
    - nginx (unused)

## run

 ```
 git clone https://github.com/olista94/pootle.git pootle
 cd pootle
 cp env-example .env
 $EDITOR .env # do not use ""
 docker-compose build
 docker-compose up
 ``` 
## note
    - Before doing `docker-compose build`, delete `.enviroment` file first
## use

 nginx listen `localhost:80` and pootle `localhost:8000` (same interface)
