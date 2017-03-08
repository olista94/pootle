
# Pootle container - docker-compose

## contains

    - pootle
    - redis
    - postgresql
    - nginx
    
## run

 ```
 git clone https://framagit.org/amj/docker-pootle-alone.git pootle
 cd pootle
 cp env-example .env
 $EDITOR .env # do not use ""
 docker-compose build
 docker-compose up
 ```
 ## use
 
 nginx listen `localhost:80` and pootle `localhost:8000` (same interface)