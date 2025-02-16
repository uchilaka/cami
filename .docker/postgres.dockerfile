FROM postgres:15

ENV MAPPED_GROUP=root
ENV MAPPED_USER=root
ENV HOME_DIR=/var/lib/postgresql

# Run bash code to create system user from $MAPPED_GROUP if the group is not "root"
RUN set -eux; \
    if [ "$MAPPED_GROUP" != 'root' ]; then \
        addgroup --system $MAPPED_GROUP; \
    fi

# Run bash code to create system user from $MAPPED_USER if the user is not "root" \
RUN set -eux; \
    if [ "$MAPPED_USER" != 'root' ]; then \
        adduser --system $MAPPED_USER --ingroup $MAPPED_GROUP; \
    fi; \
    chown -R $MAPPED_USER:$MAPPED_GROUP $HOME_DIR/data; \
    chown -R $MAPPED_USER:$MAPPED_GROUP /usr/local/downloads; \
    chown -R $MAPPED_USER:$MAPPED_GROUP /docker-entrypoint-initdb.d

USER $MAPPED_USER

# Picking up from here: https://github.com/docker-library/postgres/blob/607fdbdadc175f112ebcf94a42272ca57e3b8ab2/15/bookworm/Dockerfile#L192
ENTRYPOINT ["docker-entrypoint.sh"]

# We set the default STOPSIGNAL to SIGINT, which corresponds to what PostgreSQL
# calls "Fast Shutdown mode" wherein new connections are disallowed and any
# in-progress transactions are aborted, allowing PostgreSQL to stop cleanly and
# flush tables to disk.
#
# See https://www.postgresql.org/docs/current/server-shutdown.html for more details
# about available PostgreSQL server shutdown signals.
#
# See also https://www.postgresql.org/docs/current/server-start.html for further
# justification of this as the default value, namely that the example (and
# shipped) systemd service files use the "Fast Shutdown mode" for service
# termination.
#
STOPSIGNAL SIGINT
#
# An additional setting that is recommended for all users regardless of this
# value is the runtime "--stop-timeout" (or your orchestrator/runtime's
# equivalent) for controlling how long to wait between sending the defined
# STOPSIGNAL and sending SIGKILL.
#
# The default in most runtimes (such as Docker) is 10 seconds, and the
# documentation at https://www.postgresql.org/docs/current/server-start.html notes
# that even 90 seconds may not be long enough in many instances.

EXPOSE 5432
CMD ["postgres"]
