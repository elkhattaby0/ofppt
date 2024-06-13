const express = require('express')
const {ObjectId} = require('mongodb')
const connection = require('./conection')
const app = express();

app.use(express.json())

app.listen(3030, ()=> {
    connection(app).then(()=> {
        console.log('start...')
    })  
})

app.get('/', async (req, res) => {
    const collection = await app.locals.db.collection('clients');
    const data = await collection.find({}).toArray();
    res.status(200).json(data);
})

app.get('/:_id', async (req, res) => {
    const _id = new ObjectId(req.params._id);
    const collection = await app.locals.db.collection('clients');
    const item = await collection.findOne({_id});
    res.status(200).json(item);
})

app.get('/search/:city', async (req, res) => {
    const city = req.params.city;
    const collection = await app.locals.db.collection('clients');
    const data = await collection.find({city}).toArray();
    res.status(200).json(data);
})

app.post('/', async (req, res) => {
    const item = req.body;
    const itemChek = await checkEmail(item.email);
    if(itemChek) {
        res.status(202).json({message: "déja exist"});
    } else {
        const collection = await app.locals.db.collection('clients');
        const newItem = collection.insertOne(item)
        res.status(200).json(newItem);
    }
})

app.put('/:_id', async (req, res) => {
    const _id = new ObjectId(req.params._id);
    const item = req.body;
    const itemChek = await checkEmail(item.email);
    if(itemChek  && itemChek._id.toString() !== _id.toString() ) {
        res.status(202).json({message: "déja exist"});
    } else {
        const collection = await app.locals.db.collection('clients');
        const newItem = collection.replaceOne({_id}, item);
        res.status(200).json(newItem);
    }
})

app.delete('/:_id', async (req, res) => {
    const _id = new ObjectId(req.params._id);
    const collection = await app.locals.db.collection('clients');
    const item = collection.deleteOne({_id});
    res.status(200).json(item);

})

const checkEmail = async (email) => {
    const collection = await app.locals.db.collection('clients');
    const item = await collection.findOne({email});
    return item
}

