FROM alpine:3.8

# Specify URL, username and password to communicate with the remote webdav
# resource. When using _FILE, the password will be read from that file itself,
# which helps passing further passwords using Docker secrets.
ENV WEBDRIVE_URL=
ENV WEBDRIVE_USERNAME=
ENV WEBDRIVE_PASSWORD=
ENV WEBDRIVE_PASSWORD_FILE=

# share from scanner
ENV SCANNER_MOUNT=/mnt/scanner
# comma seperated list
ENV SCANNER_FOLDERS=
ENV SYNCPERIOD=30
# User ID of share owner
ENV OWNER=0

# Location of directory where to mount the drive into the container.
ENV WEBDRIVE_MOUNT=/mnt/webdrive

# In addition, all variables that start with DAVFS2_ will be converted into
# davfs2 compatible options for that share, once the leading DAVFS2_ have been
# removed and once converted to lower case. So, for example, specifying
# DAVFS2_ASK_AUTH=0 will set the davfs2 configuration option ask_auth to 0 for
# that share. See the manual for the list of available options.

RUN apk --no-cache add ca-certificates davfs2 tini

# create user for admin on Synology
RUN adduser -D -H -u 1024 -G users admin

COPY *.sh /usr/local/bin/

# Following should match the WEBDRIVE_MOUNT environment variable.
RUN mkdir -p /mnt/scanner
VOLUME [ "/mnt/webdrive", "/mnt/scanner" ]

# The default is to perform all system-level mounting as part of the entrypoint
# to then have a command that will keep listing the files under the main share.
# Listing the files will keep the share active and avoid that the remote server
# closes the connection.
ENTRYPOINT [ "tini", "-g", "--", "/usr/local/bin/docker-entrypoint.sh" ]
CMD [ "ls.sh" ]
