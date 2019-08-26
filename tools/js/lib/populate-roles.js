// TEMP:
const IIOSAccesControl =
  require('@ignitial/iio-services/lib/accesscontrol').IIOSAccesControl

const roles = require('../../data/roles')

exports.populate = async function(setOfUsers) {
  let ac = new IIOSAccesControl({
    namespace: process.env.IIOS_NAMESPACE || 'ignitialio',
    connector: {
      redis: {
        sentinels: process.env.REDIS_SENTINELS,
        master: process.env.REDIS_MASTER_NAME,
        host: process.env.REDIS_HOST || '127.0.0.1',
        port: process.env.REDIS_PORT ? parseInt(process.env.REDIS_PORT) : 6379,
        db: 1,
        ipFamily: 4
      }
    }
  })

  for (let role in roles) {
    await ac.setGrants(role, roles[role])
  }

  // update only if provided
  if (setOfUsers) {
    users = setOfUsers || users
    for (let user in users) {
      await ac.setUserRole(user, users[user])
    }
  }

  ac._connector.destroy()
  console.log('populated KV access control data')
}
