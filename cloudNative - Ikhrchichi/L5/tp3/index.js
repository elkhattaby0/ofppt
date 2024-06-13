const express = require('express')
const jwt = require('jsonwebtoken')
const app = express();
const connection = require('./db')
app.use(express.json())
app.listen(3030, ()=> {
    connection(app).then(()=> {
        console.log('start...')
    })
})


app.get('/', async (req,res)=> {
    try {
        const token = req.header('token');
        const email = req.header('email');
        try {
            const verify = jwt.verify(token, "TOKEN_ADMIN");
            if(verify) {
                const collection = await app.locals.db.collection('clients')
                let limit = 0;
                let skip = 0;
                if(email == "admin@gmail.com") {
                    limit = 4;
                } else {
                    limit = 100;
                    skip = 4
                }
                const data = await collection.find().skip(skip).limit(limit).toArray()
                res.status(200).json(data)
            }
        } catch (error) {
            res.status(500).json({err: "Token invalid !"})  
        }
        
        
    } catch (error) {
        res.status(500).json({err: "server failed to load"})  
    } 
})

app.post('/login', async (req, res)=> {
    try {
        const admin = req.body
        const collection = await app.locals.db.collection('admins')
        const data = await collection.findOne({email: admin.email, password: admin.password})
        if(data){
            const token = jwt.sign(data, "TOKEN_ADMIN", {
                expiresIn: 300
            })
            res.status(200).json({data:data, token: token})
        } else {
            res.status(201).json({err: "Not found !"})  
        }
    } catch (error) {
        res.status(500).json({err: "server failed to load"})  
    } 
})
