const express=require("express")
const app= express()
const data = require('./data.json');
const {checkEmail} = require('./checkEmail')
app.use(express.json())

app.listen(4040,()=>{
    console.log("hello world")
})

app.get('/',(req, res)=>{
    res.status(200).json(data)
})

app.get('/:id',(req, res)=>{
    const id = req.params.id
    const person = data.find(item => item.id == id )
    if(person) {
        res.status(200).json(person)
    } else {
        res.status(202).json({message: 'not Found'})
    }
    
})

app.get('/search/:letter',(req, res)=>{
    const letter =req.params.letter.toLowerCase();
    const datafilter=data.filter(x=>x.nom.toLowerCase().indexOf(letter) != -1 || x.prenom.toLowerCase().indexOf(letter) != -1 );
    res.status(200).json(datafilter)
})

app.post('/', (req, res) => {
    const person = req.body
    const UserFind = data.find((item) => item.email === person.email)
    if(!UserFind) {
        data.push(person)
        res.status(200).json({message: 'ok'})
    } else {
        res.status(202).json({message: 'Non'})
    }
})

app.put('/', (req, res) => {
    const person = req.body
    const dataFindIndex = data.findIndex((item) => item.id == person.id)
    if(dataFindIndex != -1 && !checkEmail(data,person)) {
        data[dataFindIndex] = person
        res.status(200).json({message: 'ok'})
    } else {
        res.status(202).json({message: 'Non'})
    }
})

app.delete('/:id', (req, res) => {
    const id = req.params.id
    const index = data.findIndex(item => item.id == id)
    if(index != -1){
        const person = data.splice(index, 1);
        res.status(200).json({message: person[0].nom+" remove"})
    } else {
        res.status(201).json({message: "not Found"})
    }
})