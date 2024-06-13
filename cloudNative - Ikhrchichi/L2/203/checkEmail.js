const checkEmail = (data, person) => {
    const result = data.find(item => item.email == person.email && item.id != person.id  )

    return result ? true : false
}

module.exports = {checkEmail}