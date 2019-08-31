FROM python:2 as builder 

USER root

WORKDIR /home/hep
ADD requirements_apt_build.sh /home/hep/requirements_apt_build.sh
RUN apt-get -y update

RUN apt-get -y install $(cat /home/hep/requirements_apt_build.sh)

ADD requirements_pip.sh /home/hep/requirements_pip.sh
RUN /bin/bash /home/hep/requirements_pip.sh

RUN git clone -b master https://github.com/madnklo/madnklo.git

WORKDIR /home/hep/madnklo/vendor/CutTools
RUN make
WORKDIR /home/hep/madnklo/vendor/IREGI/src
RUN make

WORKDIR /home/hep/madnklo
RUN echo "install ninja" | bin/mg5_aMC

WORKDIR /home/hep
ADD install_lhapdf_6.2.3.sh /home/hep/install_lhapdf.sh
RUN /home/hep/install_lhapdf.sh

##################################################################

FROM python:2 as runner

WORKDIR /home/hep

ADD requirements_apt_run.sh /home/hep/requirements_apt_run.sh
RUN apt-get -y update
RUN apt-get -y install $(cat /home/hep/requirements_apt_run.sh)

ADD requirements_pip.sh /home/hep/requirements_pip.sh
RUN /bin/bash /home/hep/requirements_pip.sh

RUN mkdir -p /root/.config/matplotlib
RUN echo "backend: agg" >>  ~/.config/matplotlib/matplotlibrc

ENV PATH="/home/hep/lhapdf/bin:${PATH}"
ENV LD_LIBRARY_PATH="/home/hep/lhapdf/lib:${LD_LIBRARY_PATH}"
ENV PYTHONPATH="/home/hep/lhapdf/lib/python2.7/site-packages/:${PYTHONPATH}"

COPY --from=builder /home/hep/ /home/hep/

RUN lhapdf install PDF4LHC15_nlo_30

WORKDIR /var/tmp
ADD texlive.profile /var/tmp/texlive.profile
ADD install_texlive.sh /var/tmp/install_texlive.sh
RUN bash install_texlive.sh
ENV PATH="/usr/local/texlive/2019/bin/x86_64-linux/:${PATH}"

COPY initialize.sh /home/hep/initialize.sh
RUN cp -r /home/hep/madnklo /home/hep/code_origin

COPY cleanup.sh .
RUN ./cleanup.sh
RUN  rm ./cleanup.sh

WORKDIR /var/madnklo_persistent
ENTRYPOINT ["/home/hep/madnklo/bin/mg5_aMC"]
CMD []
