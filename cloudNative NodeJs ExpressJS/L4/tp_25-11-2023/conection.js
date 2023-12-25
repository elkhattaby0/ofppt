const { MongoClient } = require('mongodb')

const connection = async (app) => {
    const client = await new MongoClient("mongodb://127.0.0.1:27017")
    const db = await client.db('dd203')
    try {
        client.connect();
        app.locals.client = client
        app.locals.db = db;
        console.log('connected...')
    } catch (error) {
        console.error(error)
    }
}

module.exports = connection