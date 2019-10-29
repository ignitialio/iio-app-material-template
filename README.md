> WARNING!
> WIP: will be available very soon for production

# IgnitialIO app

## What is this ?

IgnitialIO (or ignitial.io, or IIOS) web application template allows you to use
IgnitialIO toolbox for deploying micro-services based web apps.  

It provides the capability to build all your app features as a service, which we
can summarize as below:  

>
> Evertyhing is service
>

More information on IIOS can be found on in the
[IIOS Github repository](https://github.com/ignitialio/iio-services).  

Current template is a bootstrap for accessing IIOS thourgh a web app based
on [VueJS](https://vuejs.org/) front-end side.

Backend uses [connect](https://www.npmjs.com/package/connect) and
[connect-rest](https://www.npmjs.com/package/connect-rest), as well as
[socket.io](https://www.npmjs.com/package/socket.io) for serving static files,
communicate with the front-end and provide additional REST APIs.

Two services must be provided in any case:
- data service allowing database access. Here we use IIOS base _dlake_ service
configured to use MongoDB
- authentication service that controls access to IIO services based on roles. This
is used even if no authentication is required (= anonymous users only). Current
template uses _auth_ base service which implements JSONWebToken based authentication.  

## Creation

An web app based on IIOS can be created as below:

```bash
# installs IIO CLI tool
npm install -g @ignitial/iio-cli

# create an app with name myapp (creates folder as well)
iio create app myapp
```

> WARNING: Take care to always have the latest iio-cli version

This bootstraps a folder with a ready to run app that you can modify or incrementally
complete with your own features.

You can implement any feature through IIOS services that allow you to inject new
UI components.

## Use in development

### Install dependencies

```bash
npm i
```

### Populate database for development

Database and authentication service need a minimum set of info (eg. roles) in
order to run web app. Then, you need to populate database before starting your
app:

```bash
npm run dev:config:populate
```

Here we use mongodb as primary database (user info is a MongoDB collection), then
we populate a MongoDB whose name is the one defined in the configuration.  

Configuration uses environment variables to overwrite default values. For the db,
you need to update __IIOS_DBNAME__ env variable. We do this in the script that
executes populate, __scripts/populate_db-mongo.sh__ in our case, since Mongo is
concerned:

```bash
export IIOS_DBNAME=ignitialio
```

RBAC information is populated as well in Redis. Then, we need to define IIOS
namespace in order to let script know which one to use in Redis database:

```bash
export IIOS_NAMESPACE=ignitialio
```

### Auto-populate

Starting with _dlake:3.2.0_ an automated populate is done by the _dlake_ service.
It creates the minimal roles and access rights as per the template needs, as well
as an _admin_ user (password: _toto13!_).

### Run for development


#### Start app and associated services

```bash
npm run dev:start
```

#### Stop and clean up

```bash
npm run dev:stop
```

### Run with minikube

> __Note__
>  
> You need minikube installed and configured.

First, you need to create app and dlake images and publish them to minikube docker
environment:

```bash
npm run docker:publish:minikube
```

> __Note__
>   
> This uses _ignitial/dlake_ and _ignitial/auth_ images published on Docker Hub.

```bash
iio deploy
```

#### Clean up

```bash
iio remove
```

> _WARNING_: this will erase Redis persistent volume and then you will lose current
> roles and users. On production deploy, you need to separate PV management from
> deployment itself.

> __Note__
>   
> This will not stop minikube cluster.
