FROM ndeutschmann/madnklo

COPY initialize.sh /home/hep/initialize.sh
RUN chmod +x  /home/hep/initialize.sh
RUN cp -r /home/hep/madnklo /home/hep/code_origin 


WORKDIR /home/hep/madnklo
ENTRYPOINT ["/home/hep/madnklo/bin/mg5_aMC"]
CMD []
