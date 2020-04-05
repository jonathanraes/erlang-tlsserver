FROM debian:stretch

ENV OTP_VERSION="18.3.4.6"

# We'll install the build dependencies, and purge them on the last step to make
# sure our final image contains only what we've just built:
RUN set -xe \
	&& OTP_DOWNLOAD_URL="https://github.com/erlang/otp/archive/OTP-${OTP_VERSION}.tar.gz" \
	&& OTP_DOWNLOAD_SHA256="94f84e8ca0db0dcadd3411fa7a05dd937142b6ae830255dc341c30b45261b01a" \
	&& fetchDeps=' \
		curl \
		ca-certificates' \
	&& apt-get update \
	&& apt-get install -y --no-install-recommends $fetchDeps \
	# && curl -fSL -o otp-src.tar.gz "$OTP_DOWNLOAD_URL" \
#	&& echo "$OTP_DOWNLOAD_SHA256  otp-src.tar.gz" | sha256sum -c - \
	&& runtimeDeps=' \
		libodbc1 \
		libssl1.0.2 \
		libsctp1 \
	' \
	&& buildDeps=' \
		autoconf \
		dpkg-dev \
		gcc \
		g++ \
		make \
		libncurses-dev \
		unixodbc-dev \
		libssl1.0-dev \
		libsctp-dev \
	' \
	&& apt-get install -y --no-install-recommends $runtimeDeps \
	&& apt-get install -y --no-install-recommends $buildDeps \
	&& export ERL_TOP="/usr/src/otp_src_${OTP_VERSION%%@*}" \
	&& mkdir -vp $ERL_TOP 

RUN mkdir certs server otp

COPY otp-OTP-18.3.4.6-modified.tar.gz otp

RUN cd otp \
		&& tar -xzf otp-OTP-18.3.4.6-modified.tar.gz
RUN (cd otp/otp-OTP-18.3.4.6 \
	  && ./otp_build autoconf \
	  && gnuArch="$(dpkg-architecture --query DEB_HOST_GNU_TYPE)" \
	  && ./configure --build="$gnuArch" --enable-sctp \
	  && make -j$(nproc) \
	  && make install) \
	&& find /usr/local -name examples | xargs rm -rf \
	&& apt-get purge -y --auto-remove $buildDeps $fetchDeps \
	&& rm -rf $ERL_TOP /var/lib/apt/lists/*

COPY erlang_server server
COPY ca_certificate.pem certs
COPY server_certificate.pem certs
COPY server_key.pem certs
WORKDIR server

CMD ["./erlang_server"]
