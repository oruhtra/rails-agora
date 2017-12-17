function budgeaHandshake() {
  const serviceArray = document.querySelectorAll('.service-form')
  serviceArray.forEach(service => {
    service.addEventListener('click', (event) => {
      if (document.getElementById('budgea_token')) {
        sessionStorage.AuthToken = document.getElementById('budgea_token').innerText;
        setTimeout(submitCredentialsBudgea, 2000);
      } else {
        fetchTempToken();
        setTimeout(submitCredentialsBudgea, 2000);
      }
    });
  });
}

function fetchTempToken() {
  fetch("https://agora.biapi.pro/2.0/auth/init",
  { method: "POST" })
  .then(response => response.json())
  .then((data) => {
    const authToken = data.auth_token;
    sessionStorage.AuthToken = authToken;
  })
}

function submitCredentialsBudgea() {
  const submitCredentials = document.getElementById("send-credentials");

  submitCredentials.addEventListener('click', (event) => {
    const login = document.getElementById('login').value;
    const password = document.getElementById('password').value;
    const provider_id = parseInt(document.getElementById('provider_id').value, 10);
    const service_id = parseInt(document.getElementById('service_id').value, 10);
    const auth_token = sessionStorage.getItem("AuthToken");

    fetch("https://agora.biapi.pro/2.0/users/me/connections", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "Authorization": `Bearer ${auth_token}`
      },
      body: JSON.stringify({"id_provider": provider_id, "login": login, "password": password})
    })
    .then(response => response.json())
    .then((data) => {
        sendCredentialsToServer(data, service_id);
    })
  });
}

function sendCredentialsToServer(data, service_id) {
  const form = document.querySelector('form')
  console.log(data);
   if (data.code){
    document.querySelector('#error_message').value = data.code;
   } else {
    document.querySelector('#id_user').value = data.id_user;
    document.querySelector('#id_connection').value = data.id;
    document.querySelector('#service_id').value = service_id;
    document.querySelector('#access_token').value = sessionStorage.getItem("AuthToken");
   };

   form.submit();
}

export { budgeaHandshake };
