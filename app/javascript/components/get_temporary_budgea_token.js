const serviceArray = document.querySelectorAll('.service-form')

function fetchTempToken() {

  serviceArray.forEach(service => {
    service.addEventListener('click', (event) => {
      fetch("https://agora.biapi.pro/2.0/auth/init",
      { method: "POST" })
      .then(response => response.json())
      .then((data) => {
        const authToken = data.auth_token;
        sessionStorage.AuthToken = authToken;
        submitCredentialsBudgea();
      });
    });
  });

}




function submitCredentialsBudgea() {

  const submitCredentials = document.getElementById("send-credentials");

  submitCredentials.addEventListener('click', (event) => {
    const login = document.getElementById('login').value;
    const password = document.getElementById('password').value;
    const provider_id = parseInt(document.getElementById('provider_id').value, 10);
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
      console.log(data);
    })
  });
}

fetchTempToken();
