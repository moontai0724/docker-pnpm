ARG BASE_IMAGE=node:slim
ARG PNPM_VERSION

FROM ${BASE_IMAGE}

ENV PNPM_VERSION=$PNPM_VERSION

# Install packages that will use in the installation script
COPY files/install_requirement.sh /run/install_requirement.sh
RUN chmod +x /run/install_requirement.sh
RUN sh /run/install_requirement.sh
RUN rm /run/install_requirement.sh

COPY files/install_pnpm.sh /run/install_pnpm.sh
RUN chmod +x /run/install_pnpm.sh
RUN sh /run/install_pnpm.sh

# Run the installation script
ENTRYPOINT ["/run/install_pnpm.sh"]
