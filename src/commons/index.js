import * as d3 from 'd3'

export function loadSchema(vueObjRef, collection) {
  return new Promise((resolve, reject) => {
    vueObjRef.$utils.waitForProperty(vueObjRef, '$db').then(db => {
      db.collection('schemas').then(async schemas => {
        let schema = await schemas.dGet({ name: collection })

        if (schema) {
          // manage naming restrictions for Mongo
          schema.schema.$schema = schema.schema._schema
          delete schema.schema._schema
          resolve(schema.schema)
        } else {
          console.log(window.location.origin + '/data/schemas/' + collection + '.schema.json')
          d3.json(window.location.origin + '/data/schemas/' + collection + '.schema.json')
            .then(data => {
              console.log(data)
              resolve(data)
            }).catch(() => reject(new Error('no schema for collection [' + collection + ']')))
        }
      }).catch(err => reject(err))
    }).catch(err => reject(err))
  })
}
