#!/usr/bin/env sh

if [ ! -f "/etc/ssh/ssh_host_rsa_key" ]; then
	# generate fresh rsa key
	ssh-keygen -f /etc/ssh/ssh_host_rsa_key -N '' -t rsa
fi
if [ ! -f "/etc/ssh/ssh_host_dsa_key" ]; then
	# generate fresh dsa key
	ssh-keygen -f /etc/ssh/ssh_host_dsa_key -N '' -t dsa
fi

#prepare run dir
if [ ! -d "/var/run/sshd" ]; then
  mkdir -p /var/run/sshd
fi

echo "Protocol 2" > /etc/ssh/sshd_config
echo "Subsystem       sftp    /usr/lib/openssh/sftp-server" >> /etc/ssh/sshd_config

if [ ! -z "$SSH_PORT" ]; then
  echo "Port $SSH_PORT" >> /etc/ssh/sshd_config
fi

if [ ! -z "$SSH_LISTEN_ADDRESST" ]; then
  echo "ListenAddress $SSH_LISTEN_ADDRESS" >> /etc/ssh/sshd_config
fi

if [ ! -z "$SSH_LISTEN_ADDRESST" ]; then
  echo "ListenAddress $SSH_LISTEN_ADDRESS" >> /etc/ssh/sshd_config
fi

if [ ! -z "$SSH_MAX_AUTH_TRIES" ]; then
  echo "MaxAuthTries $SSH_MAX_AUTH_TRIES" >> /etc/ssh/sshd_config
fi

if [ ! -z "$SSH_MAX_SESSIONS" ]; then
  echo "MaxSessions $SSH_MAX_SESSIONS" >> /etc/ssh/sshd_config
fi

if [ ! -z "$SSH_X11_FORWARDING" ]; then
  echo "X11Forwarding $SSH_X11_FORWARDING" >> /etc/ssh/sshd_config
fi

if [ ! -z "$SSH_GATEWAY_PORTS" ]; then
  echo "GatewayPorts $SSH_GATEWAY_PORTS" >> /etc/ssh/sshd_config
fi

if [ ! -z "$SSH_PUBKEY_AUTHENTICATION" ]; then
  echo "PubkeyAuthentication $SSH_PUBKEY_AUTHENTICATION" >> /etc/ssh/sshd_config
fi

if [ ! -z "$SSH_PASSWORD_AUTHENTICATION" ]; then
  echo "PasswordAuthentication $SSH_PASSWORD_AUTHENTICATION" >> /etc/ssh/sshd_config
fi

if [ ! -z "$SSH_PERMIT_EMPTY_PASSWORDS" ]; then
  echo "PermitEmptyPasswords $SSH_PERMIT_EMPTY_PASSWORDS" >> /etc/ssh/sshd_config
fi

if [ ! -z "$SSH_PERMIT_ROOT_LOGIN" ]; then
  echo "PermitRootLogin $SSH_PERMIT_ROOT_LOGIN" >> /etc/ssh/sshd_config
fi

if [ ! -z "$SSH_PERMIT_OPEN" ]; then
  echo "PermitOpen $SSH_PERMIT_OPEN" >> /etc/ssh/sshd_config
fi

if [ ! -z "$SSH_USER" ]; then
  adduser --disabled-password --gecos "" "$SSH_USER"
#  sh -c 'echo "$SSH_USER:<encoded_passwd>"' | chpasswd -e > /dev/null 2>&1
  if [ ! -z "$SSH_ALLOW_FROM_IP" ]; then
    ALLOW_USERS=
    #IFS=' ' read -r -a LIST_IP <<< $SSH_ALLOW_FROM_IP
    #LIST_IP=($SSH_ALLOW_FROM_IP)
    echo "$SSH_ALLOW_FROM_IP" | read -r -a LIST_IP
    for IP in "${LIST_IP[@]}"
    do
        ALLOW_USERS="$ALLOW_USERS$SSH_USER@$IP "
    done
    echo "AllowUsers $ALLOW_USERS" >> /etc/ssh/sshd_config
  else
    echo "AllowUsers $SSH_USER" >> /etc/ssh/sshd_config
  fi
fi

echo "Include /etc/ssh/sshd_config.d/*.conf" >> /etc/ssh/sshd_config

exec "$@"
