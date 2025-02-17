FROM ubuntu:latest

ARG  PROJECT_NAME="bezdez-bot"
ARG  PROJECT_USER="bezdez"
ARG  PROJECT_USER_SSH_PUBLIC_KEY="bez_ed25519.pub"

RUN  apt-get update && \
     apt-get install -y \
          python3 \
          python3-pip \
          python3-venv

# 
# Create the user and set a password
# 
RUN useradd -m -s /bin/bash ${PROJECT_USER} && echo ${PROJECT_USER}":vlad" | chpasswd
RUN groupadd sshusers
RUN usermod -aG sshusers ${PROJECT_USER}
RUN usermod -aG sudo     ${PROJECT_USER}

# USER ${PROJECT_USER}
ENV  HOME="/home/"${PROJECT_USER}

# 
# Configure bezdez for SHH
# 
COPY ${PROJECT_USER_SSH_PUBLIC_KEY} ${HOME}
RUN  mkdir -p ${HOME}/.ssh && \
     cat ${HOME}/bez_ed25519.pub >> ${HOME}/.ssh/authorized_keys && \
     chmod 700 ${HOME}/.ssh && \
     chmod 600 ${HOME}/.ssh/authorized_keys && \
     chown -R ${PROJECT_USER}:${PROJECT_USER} ${HOME}/.ssh && \
     rm ${HOME}/${PROJECT_USER_SSH_PUBLIC_KEY}

RUN  mkdir -p ${HOME}/${PROJECT_NAME}

COPY *.sh  ${HOME}/${PROJECT_NAME}/
COPY *.py  ${HOME}/${PROJECT_NAME}/
COPY *.db  ${HOME}/${PROJECT_NAME}/

# RUN chown -R ${PROJECT_USER}:${PROJECT_USER} ${HOME}/${PROJECT_NAME}

RUN ls -alF --color=auto --group-directories-first ${HOME}/${PROJECT_NAME}

WORKDIR ${HOME}/${PROJECT_NAME}

RUN ls -alF --color=auto --group-directories-first

RUN ./suv-venv-activate.sh
RUN ./suv-venv-install-modules.sh

EXPOSE 22/tcp

ENTRYPOINT ["./suv-bot-start.sh"]
CMD []
