FROM jupyter/ubuntu_14_04_locale_fix

MAINTAINER Project peopleAnalytics <dana.klassen@shopify.com>

# Not essential, but wise to set the lang
# Note: Users with other languages should set this in their derivative image
ENV LANGUAGE en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8
ENV PYTHONIOENCODING UTF-8

# Remove preinstalled copy of python that blocks our ability to install development python.
RUN DEBIAN_FRONTEND=noninteractive apt-get remove -yq \
        python3-minimal \
        python3.4 \
        python3.4-minimal \
        libpython3-stdlib \
        libpython3.4-stdlib \
        libpython3.4-minimal

# Python binary and source dependencies
RUN apt-get update -qq && \
    DEBIAN_FRONTEND=noninteractive apt-get install -yq --no-install-recommends \
        build-essential \
        ca-certificates \
        curl \
        git \
        libfreetype6-dev \
        language-pack-en \
        libcurl4-openssl-dev \
        libffi-dev \
        libncurses5-dev \
        libpng-dev \
        libsqlite3-dev \
        libzmq3-dev \
        pandoc \
        python \
        python3 \
        python-dev \
        python3-dev \
        sqlite3 \
        texlive-fonts-recommended \
        texlive-latex-base \
        texlive-latex-extra \
        zlib1g-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install Tini - for process management inside the container
RUN curl -L https://github.com/krallin/tini/releases/download/v0.6.0/tini > tini && \
    echo "d5ed732199c36a1189320e6c4859f0169e950692f451c03e7854243b95f4234b *tini" | sha256sum -c - && \
    mv tini /usr/local/bin/tini && \
    chmod +x /usr/local/bin/tini

# Install the recent pip release
RUN curl -O https://bootstrap.pypa.io/get-pip.py && \
    python3 get-pip.py && \
    rm get-pip.py && \
    pip3 --no-cache-dir install requests[security] && \
    rm -rf /root/.cache

# Install some dependencies.
RUN pip3 --no-cache-dir install ipykernel && \
    python3 -m ipykernel.kernelspec && \
    rm -rf /root/.cache

ADD requirements.txt .
RUN pip3 install wheel
RUN pip3 wheel --wheel-dir=/local/wheels -r requirements.txt
RUN pip3 install --no-index --find-links=/local/wheels -r requirements.txt

# Add a notebook profile.
RUN mkdir -p -m 700 /root/.jupyter/
ADD config/jupyter_notebook_config.py /root/.jupyter/jupyter_notebook_config.py
ADD config/custom.css /root/.jupyter/custom/custom.css

VOLUME /notebooks
WORKDIR /notebooks

EXPOSE 8888

ENTRYPOINT ["tini", "--"]
CMD ["jupyter", "notebook", "--no-browser"]
