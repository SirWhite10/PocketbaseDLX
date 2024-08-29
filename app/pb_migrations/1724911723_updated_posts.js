/// <reference path="../pb_data/types.d.ts" />
migrate((db) => {
  const dao = new Dao(db)
  const collection = dao.findCollectionByNameOrId("8povz5m61s7vb4m")

  // add
  collection.schema.addField(new SchemaField({
    "system": false,
    "id": "fc9w4zki",
    "name": "sss",
    "type": "text",
    "required": false,
    "presentable": false,
    "unique": false,
    "options": {
      "min": null,
      "max": null,
      "pattern": ""
    }
  }))

  return dao.saveCollection(collection)
}, (db) => {
  const dao = new Dao(db)
  const collection = dao.findCollectionByNameOrId("8povz5m61s7vb4m")

  // remove
  collection.schema.removeField("fc9w4zki")

  return dao.saveCollection(collection)
})
