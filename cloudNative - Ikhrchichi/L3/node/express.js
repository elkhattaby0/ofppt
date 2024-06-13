const express = require("express")
const data = require('./data.json');

const app= express()
app.use(express.json())

app.listen(4040,()=>{ 
    console.log("hello")
})

app.get('/',(req,res)=>{
    res.status(200).json(data)
})

app.get('/:id', () => {
    const id = req.params.id 
    const item = data.find(item=>item.id==id)
    res.status(200).json(item)
})
app.get('/search/',(req,res)=>{
    res.status(200).json(data)
})
app.get('/search/:search',(req,res)=>{
    const search = req.params.search
    const dataFilter = data.filter(item=>item.Country.indexOf(search) != -1 || item.name.indexOf(search) != -1 || item.city.indexOf(search) != -1)
    res.status(200).json(dataFilter)
})

app.post('/',(req,res)=>{
    const item = req.body
    item.id = data[data.length - 1].id + 1
    data.push(item)
    res.status(200).json({message: 'ok'})
})

app.put('/:id', (req, res)=> {
    const id = req.params.id;
    const item = req.body
    const index = data.findIndex(row=> row.id == id)
    if(index != -1) {
        data[index] = item;
        res.status(200).json(data)
    }
})

app.delete('/:id', (req, res) => {
    const id = req.params.id
    const index = data.findIndex(item => item.id == id)
    if(index != -1)
        data.splice(index, 1);
    res.status(200).json(data)
})

