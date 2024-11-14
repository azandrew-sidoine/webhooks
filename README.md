# Webhooks

This repository contains automation files for performing installation and configuration of [https://github.com/adnanh/webhook.git] webhook application on a Unix operating system or run it in a docker container.

## Install & Configuring webhook server

The repository comes with a bash script for install/deploying the webhook server using supervisor process manager.

> ./install_webhooks -p <PORT_NUMBER> -u <RUN_AS>

To use a predefine configuration:

> ./install_webhooks -c <PATH_TO_CONFIG>.yml -p <PORT_NUMBER>

**Note**
    Supported options are:

* -p : Port on which the service must run (Required)
* -c : Path to the configuration file. Supported format must be find on [https://github.com/adnanh/webhook.git] repository (Optional)
* -u : System user used by the supervisor client to run the webservice (Optional). If not provided, the current running user is used as webservice user.
* -t : When running on a system with HestiaCP, the automation tool comes with a proxy template genetor. This option allow to
        name the template provided to hestion Control Panel (Optional)

## Docker

The repository also comes with a `Dockerfile` that can be use to create a docker image for deploying the the webhook server.

## Miscelanous

The rrepository contains an utility for creating hestiaCP proxy host template:

> ./hestia-nginx --directory <PATH_TO_TEMPLATES_DIRECTORY> --template <TEMPLATE_NAME> --port <PROXY_SERVER_PORT>
