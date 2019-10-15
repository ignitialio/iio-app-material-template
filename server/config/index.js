var IIOS_SERVER_PORT = process.env.NODE_ENV === 'production' ? 8080 : 4093

if (process.env.IIOS_SERVER_PORT) {
  IIOS_SERVER_PORT = process.env.IIOS_SERVER_PORT
}

module.exports = {
  server: {
    port: IIO_SERVER_PORT,
    path: process.env.IIOS_SERVER_PATH || './dist',
    filesDropPath: process.env.IIOS_DROP_FILES_PATH || './dropped',
    corsEnabled: false
  },
  rest: {
    logLevel: process.env.IIOS_REST_LOGLEVEL || 'error'
  },
  logout: {
    timeout: 15, /* minutes */
    _unified: true
  },
  store: require('./store'),
  modules: require('./modules'),
  /* data service information */
  data: {
    /* name of the main service that provides data access */
    service: 'dlake',
    /* additional collections */
    collections: [{
      name: 'schemas',
      options: {
        indexes: [
          {
            key: 'name',
            type: -1,
            options: {
              name: 'name_desc',
              unique: true
            }
          }
        ]
      }
    }, {
      name: 'notifications'
    }, {
      name: 'connections'
    }, {
      /* example */
      name: 'myitems'
    }],
    _unified: true
  },
  /* auth service information */
  auth: {
    /* name of the main service that provides authentication control */
    service: 'auth',
    _unified: true
  },
  i18n: require('./i18n'),
  unified: require('./unified')
}
