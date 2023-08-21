FROM debian:bullseye

RUN mkdir /texlive-setup
WORKDIR /texlive-setup

RUN type -p curl >/dev/null || (apt-get update && apt-get install curl -y)
RUN curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg
RUN dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
RUN chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg
RUN echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | tee /etc/apt/sources.list.d/github-cli.list
RUN cat /etc/apt/sources.list.d/github-cli.list
RUN cat /usr/share/keyrings/githubcli-archive-keyring.gpg
RUN apt-get update && apt-get install -y make wget perl-modules ca-certificates gh git
RUN wget -q https://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz \
    && mkdir install-tl \
    && tar xzf install-tl-unx.tar.gz -C install-tl --strip-components 1

WORKDIR /texlive-setup/install-tl

COPY src/texlive.profile texlive.profile
RUN ./install-tl --profile=texlive.profile

ENV PATH="/usr/local/texlive/2023/bin/x86_64-linux:${PATH}"
RUN tlmgr install geometry fontspec parskip etoolbox tabu changepage enumitem microtype lastpage needspace

RUN mkdir /src
WORKDIR /src
