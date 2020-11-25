for filename in $HOME/.ssh/*.pub; do
    cp "$filename" $PWD/resources/keys
done

USERNAME="gsm"
RESOURCES_PATH="/resources"
WORKSPACE_HOME="/home/$USERNAME"

docker build -f ./Dockerfile \
             -t sokolov/ws:v01 \
            --build-arg USERNAME=$USERNAME \
            --build-arg RESOURCES_PATH=$RESOURCES_PATH \
            . &&
            #--no-cache . &&

docker run --rm \
            --gpus all \
            --name sokolov_ws \
            -it \
            -p 9022:22 \
            -p 10023:10023 \
            -v $PWD/workspace/$USERNAME:$WORKSPACE_HOME \
            -v $PWD/resources:$RESOURCES_PATH \
            --net sokolov_ws_net \
            --ip 172.29.0.232 \
            sokolov/ws:v01 