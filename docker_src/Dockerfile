FROM python:2-slim as builder 

USER root

WORKDIR /home/hep
COPY requirements_apt_build.sh /home/hep/requirements_apt_build.sh
RUN apt-get -y update

RUN apt-get -y install $(cat /home/hep/requirements_apt_build.sh)

COPY requirements_pip.sh /home/hep/requirements_pip.sh
RUN /bin/bash /home/hep/requirements_pip.sh

RUN git clone -b master https://github.com/madnklo/madnklo.git code_origin

WORKDIR /home/hep/code_origin/vendor/CutTools
RUN make
WORKDIR /home/hep/code_origin/vendor/IREGI/src
RUN make

WORKDIR /home/hep/code_origin
RUN echo "install ninja" | bin/mg5_aMC

WORKDIR /home/hep
COPY install_lhapdf_6.2.3.sh /home/hep/install_lhapdf.sh
RUN /home/hep/install_lhapdf.sh

##################################################################

FROM python:2-slim as runner

COPY *.sh /home/hep/

RUN apt-get -y update ; apt-get -y install $(cat /home/hep/requirements_apt_run.sh) ; apt-get autoremove ; apt-get clean
RUN /bin/bash /home/hep/requirements_pip.sh

RUN mkdir -p /root/.config/matplotlib ; echo "backend: agg" >>  ~/.config/matplotlib/matplotlibrc

ENV PATH="/home/hep/lhapdf/bin:${PATH}"
ENV LD_LIBRARY_PATH="/home/hep/lhapdf/lib:${LD_LIBRARY_PATH}"
ENV PYTHONPATH="/home/hep/lhapdf/lib/python2.7/site-packages/:${PYTHONPATH}"

COPY --from=builder /home/hep/ /home/hep/

RUN lhapdf install PDF4LHC15_nlo_30

COPY texlive.profile /var/tmp/texlive.profile
COPY install_texlive.sh /var/tmp/install_texlive.sh
WORKDIR /var/tmp
RUN bash /var/tmp/install_texlive.sh
ENV PATH="/usr/local/texlive/2019/bin/x86_64-linux/:${PATH}"

COPY cleanup.sh .
RUN ./cleanup.sh ; rm ./cleanup.sh

WORKDIR /var/madnklo_persistent
ENTRYPOINT ["/home/hep/madnklo/bin/mg5_aMC"]
CMD []
