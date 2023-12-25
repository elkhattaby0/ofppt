import { useEffect, useState } from "react"

const Modal = ({refrechData, itemUpdate}) => {
    const [item, setItem] = useState({})
    const [update, SetUpdate] = useState(false)
    useEffect(()=> {
        if(itemUpdate) {
            setItem(itemUpdate)
            if(Object.keys(itemUpdate).length !== 0) {
                SetUpdate(true)
            }
        }
    }, [itemUpdate])
    const submitHandel = (event) => {
        event.preventDefault()
        var myHeaders = new Headers();
        myHeaders.append("Content-Type", "application/json");
        var raw = JSON.stringify(item);
        var requestOptions = {
            method: 'POST',
            headers: myHeaders,
            body: raw,
            redirect: 'follow'
        };
        if(update) {
            requestOptions.method = 'PUT'
            fetch("http://127.0.0.1:4040/"+item.id, requestOptions)
            .then(response => response.json())
            .then(result => refrechData())
            .catch(error => console.log('error', error));
        } else {
            fetch("http://127.0.0.1:4040/", requestOptions)
            .then(response => response.json())
            .then(result => refrechData())
            .catch(error => console.log('error', error));
        }
    }

    return (
        <>
            <form onSubmit={submitHandel}>
                <input type="text" name="name" placeholder="Name" disabled={update} value={item.name}  onChange={(event) => setItem({...item, name: event.target.value})}/>
                <input type="text" name="city" placeholder="City" value={item.city} onChange={(event) => setItem({...item, city: event.target.value})}/>
                <input type="text" name="Country" placeholder="Country" value={item.Country} onChange={(event) => setItem({...item, Country: event.target.value})}/>
                <button type="submit">{ update? 'Update' : 'Add' }</button>
            </form>
        </>
    )
}

export default Modal