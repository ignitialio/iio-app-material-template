module.exports = {
  __privileged__: {
    'auth': {
      'create:any': [ '*' ],
      'read:any': [ '*' ],
      'update:any': [ '*' ],
      'delete:any': [ '*' ]
    },
    'dlake': {
      'create:any': [ '*' ],
      'read:any': [ '*' ],
      'update:any': [ '*' ],
      'delete:any': [ '*' ]
    },
    'dlake:users': {
      'create:any': [ '*' ],
      'read:any': [ '*' ],
      'update:any': [ '*' ],
      'delete:any': [ '*' ]
    },
    'dlake:notifications': {
      'create:any': [ '*' ],
      'read:any': [ '*' ],
      'update:any': [ '*' ],
      'delete:any': [ '*' ]
    },
    'dlake:schemas': {
      'create:any': [ '*' ],
      'read:any': [ '*' ],
      'update:any': [ '*' ],
      'delete:any': [ '*' ]
    },
    'dlake:myitems': {
      'create:any': [ '*' ],
      'read:any': [ '*' ],
      'update:any': [ '*' ],
      'delete:any': [ '*' ]
    }
  },
  admin: {
    'auth': {
      'create:any': [ '*' ],
      'read:any': [ '*' ],
      'update:any': [ '*' ],
      'delete:any': [ '*' ]
    },
    'dlake': {
      'create:any': [ '*' ],
      'read:any': [ '*' ],
      'update:any': [ '*' ],
      'delete:any': [ '*' ]
    },
    'dlake:users': {
      'create:any': [ '*' ],
      'read:any': [ '*' ],
      'update:any': [ '*' ],
      'delete:any': [ '*' ]
    },
    'dlake:notifications': {
      'create:own': [ '*' ],
      'read:any': [ '*' ],
      'update:own': [ '*' ],
      'delete:own': [ '*' ]
    },
    'dlake:schemas': {
      'create:any': [ '*' ],
      'read:any': [ '*' ],
      'update:any': [ '*' ],
      'delete:any': [ '*' ]
    },
    'dlake:myitems': {
      'create:any': [ '*' ],
      'read:any': [ '*' ],
      'update:any': [ '*' ],
      'delete:any': [ '*' ]
    }
  },
  user: {
    'auth': {
      'create:own': [ '*' ],
      'read:any': [ '*' ],
      'update:any': [ '*' ],
      'delete:any': [ '*' ]
    },
    'dlake': {
      'read:any': [ '*' ]
    },
    'dlake:users': {
      'read:any': [ '*' ],
      'update:own': [ '*' ],
      'delete:own': [ '*' ]
    },
    'dlake:schemas': {
      'create:any': [ '*' ],
      'read:any': [ '*' ],
      'update:any': [ '*' ],
      'delete:any': [ '*' ]
    },
    'dlake:notifications': {
      'create:own': [ '*' ],
      'read:own': [ '*' ],
      'delete:own': [ '*' ]
    },
    'dlake:myitems': {
      'create:any': [ '*' ],
      'read:any': [ '*' ],
      'update:any': [ '*' ],
      'delete:any': [ '*' ]
    }
  },
  anonymous: {
    'auth': {
      'update:any': [ '*' ],
      'read:any': [ '*' ]
    },
    'dlake': {
      'read:any': [ '*' ]
    },
    'dlake:users': {
      'read:any': [ '_id', 'name' ]
    },
    'dlake:notifications': {
      'read:own': [ '*' ]
    },
    'dlake:schemas': {
      'read:any': [ '*' ]
    },
    'dlake:myitems': {
      'read:any': [ '*' ]
    }
  }
}
