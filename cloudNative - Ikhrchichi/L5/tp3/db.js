const {MongoClient} = require("mongodb")

const connection = async (app) => {
    const client = new MongoClient('mongodb://127.0.0.1:27017')
    const db = client.db('dd203')
    try {
        await client.connect()
        app.locals.client = client
        app.locals.db = db
        console.log("connected ....")
    } catch (error) {
        console.log(error)
    }
}

module.exports = connection