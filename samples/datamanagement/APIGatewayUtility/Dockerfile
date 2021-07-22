FROM iregistry.eur.ad.sag/api-management/apigateway-dev:nativecontainer
COPY --chown=755:755 util-docker.sh /util-docker.sh
COPY --chown=755:755 infinite.sh /infinite.sh
ENTRYPOINT ["./util-docker.sh"]