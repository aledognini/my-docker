FROM stereolabs/zed:4.2-tools-devel-jetson-jp5.1.2

ENV DEBIAN_FRONTEND=noninteractive

# Crea utente zeduser
RUN useradd -m -s /bin/bash zeduser && \
    mkdir -p /home/zeduser/data /home/zeduser/ROS2_ws && \
    chown -R zeduser:zeduser /home/zeduser

#USER zeduser

WORKDIR /home/zeduser

# Default: entra con shell root, puoi cambiare utente dopo con `su - zeduser`
CMD [ "bash" ]


