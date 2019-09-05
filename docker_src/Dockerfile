FROM python:2-slim

USER root

WORKDIR /home/hep

RUN apt-get -y update ; apt-get -y install \
	git \
	wget \
	ca-certificates \
	gfortran \
	gcc \
	build-essential \
	ghostscript \
	libginac6 \
	emacs \
	vim \
	less \
	dvipng ;\
apt-get autoremove ; apt-get clean

RUN pip install numpy ; pip install bidict vegas mpmath pyjet matplotlib

RUN git clone -b master https://github.com/madnklo/madnklo.git code_origin

WORKDIR /home/hep/code_origin/vendor/CutTools
RUN make
WORKDIR /home/hep/code_origin/vendor/IREGI/src
RUN make

WORKDIR /home/hep/code_origin
RUN echo "install ninja" | bin/mg5_aMC
RUN echo "install collier" | bin/mg5_aMC
RUN echo "install ginac_mg5_interface" | bin/mg5_aMC

RUN mkdir -p /root/.config/matplotlib ; echo "backend: agg" >>  ~/.config/matplotlib/matplotlibrc

COPY texlive.profile /var/tmp/texlive.profile
COPY install_texlive.sh /var/tmp/install_texlive.sh
WORKDIR /var/tmp
RUN bash /var/tmp/install_texlive.sh
ENV PATH="/usr/local/texlive/2019/bin/x86_64-linux/:${PATH}"

WORKDIR /home/hep
COPY install_lhapdf_6.2.3.sh /home/hep/install_lhapdf.sh
RUN /home/hep/install_lhapdf.sh
ENV PATH="/home/hep/lhapdf/bin:${PATH}"
ENV LD_LIBRARY_PATH="/home/hep/lhapdf/lib:${LD_LIBRARY_PATH}"
ENV PYTHONPATH="/home/hep/lhapdf/lib/python2.7/site-packages/:${PYTHONPATH}"
RUN lhapdf install PDF4LHC15_nlo_30

WORKDIR /home/hep
COPY cleanup.sh .
RUN ./cleanup.sh ; rm ./cleanup.sh

COPY initialize.sh /home/hep/initialize.sh

WORKDIR /var/madnklo_persistent
ENTRYPOINT ["/home/hep/madnklo/bin/mg5_aMC"]
CMD []
