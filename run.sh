LOCAL_PUB_KEY=$HOME/.ssh/id_rsa.pub
cp $LOCAL_PUB_KEY ./keys/id.pub

docker build -f ./Dockerfile \
             -t sokolov/ws:v01 \
            --build-arg USER_HOME_PATH=/home/gsm \
            --build-arg USERNAME=gsm \
            . &&
            #--no-cache . &&

docker run --rm \
            --gpus all \
            --name sokolov_ws \
            -it \
            -p 9889:22 \
            -p 10023:10023 \
            --net sokolov_ws_net \
            --ip 172.29.0.232 \
            sokolov/ws:v01 \
            bash