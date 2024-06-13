import './App.css';
import { useEffect, useState } from 'react';
import Modal from './modal.js';

function App() {
  const [data, setData] = useState([])
  const [openModal, setOpenModal] = useState(false)
  const [itemUpdate, setItemUpdate] = useState({})
  useEffect(()=> {
    getAllData()
  }, [])
  const getAllData = () => {
    var requestOptions = {
      method: 'GET',
      redirect: 'follow'
    };
    
    fetch("http://127.0.0.1:4040", requestOptions)
      .then(response => response.json())
      .then(result => setData(result))
      .catch(error => console.log('error', error));
  }
  const deleteHandel = async (id) => {
    var requestOptions = {
      method: 'DELETE',
      redirect: 'follow'
    };
    
    fetch("http://127.0.0.1:4040/"+id, requestOptions)
      .then(response => response.json())
      .then(result => setData(result))
      .catch(error => console.log('error', error));
  }

  const updateHandel = (item) => {
    setItemUpdate(item)
    setOpenModal(true)
  }

  const refrechData = () => {
    setOpenModal(false)
    getAllData()
  }

  const searchFn = (event) => {
    if(event.target.value) {
      var requestOptions = {
        method: 'GET',
        redirect: 'follow'
      };
      
      fetch("http://127.0.0.1:4040/search/"+event.target.value, requestOptions)
        .then(response => response.json())
        .then(result => setData(result))
        .catch(error => console.log('error', error));
    } else {
      getAllData()
    }
  }
  return (
    <div style={{maxWidth: '940px', margin: 'auto'}}>
      <h1>List des Clients:</h1> < input type='search' onChange={event => searchFn(event)} />
      <table >
        <thead>
          <tr>
            <th style={{fontSize: '40px'}}>ID</th>
            <th style={{fontSize: '40px'}}>Name</th>
            <th style={{fontSize: '40px'}}>City</th>
            <th style={{fontSize: '40px'}}>Country</th>
          </tr>
        </thead>
        <tbody>
          {data.map(item => (
            <tr key={item.id}>
              <td style={{fontSize: '40px'}}>{item.id}</td>
              <td style={{fontSize: '40px'}}>{item.name}</td>
              <td style={{fontSize: '40px'}}>{item.city}</td>
              <td style={{fontSize: '40px'}}>{item.Country}</td>
              <td><button onClick={()=> deleteHandel(item.id)}>Delete</button></td>
              <td><button onClick={()=> updateHandel(item)}>Update</button></td>
            </tr>
          ))}
        </tbody>
      </table>
      <button onClick={() => setOpenModal(true)}>Add</button>
      {openModal && <Modal refrechData={refrechData} itemUpdate={itemUpdate} />}
    </div>
  );
}

export default App;
