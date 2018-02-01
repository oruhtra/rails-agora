function budgeaHandshake() {
  const serviceArray = document.querySelectorAll('.service-form')
  serviceArray.forEach(service => {
    service.addEventListener('click', (event) => {
      if (document.getElementById('budgea_token')) {
        sessionStorage.AuthToken = document.getElementById('budgea_token').innerText;
        setTimeout(buildServiceCredentialsForm, 1000);
        setTimeout(submitCredentialsBudgea, 1000);
      } else {
        fetchTempToken();
        setTimeout(buildServiceCredentialsForm, 1000);
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

function buildServiceCredentialsForm() {
  const provider_id = parseInt(document.getElementById('provider_id').value, 10);
  const submitCredentials = document.getElementById("send-credentials");

  fetch('https://agora.biapi.pro/2.0/connectors?expand=fields',
  { method: "GET" })
  .then(response => response.json())
  .then((data) => {
    for (var i = 0; i < data.connectors.length; i++){
      // look for the entry with a matching `code` value
      if (data.connectors[i].id == provider_id){
        const credentialsForm = document.getElementById('credentials-form');
        data.connectors[i].fields.reverse().forEach(field => {
          if (field.type == 'list') {
            let html = `<div class="input"><p>${field.label}</p><select id="${field.name}", type="${field.type}", class="credential-input-field">`
            field.values.forEach(li => {
              html += `<option value="${li.value}">${li.label}</option>`
            })
            html += '</select></div>'
            credentialsForm.insertAdjacentHTML("afterbegin", html);
          } else {
            const html = `<div class="input"><p>${field.label}</p><input type="${field.type}", id="${field.name}", class="credential-input-field"></div>`
            credentialsForm.insertAdjacentHTML("afterbegin", html);
          }
         });
      }
    }
    // HIDE ANIMATION
    document.querySelector('.loader-container').classList.add('hidden');
    // UNHIDE BUTTON
    submitCredentials.classList.remove("hidden");
  });
}

function submitCredentialsBudgea() {
  const submitCredentials = document.getElementById("send-credentials");
  const provider_id = parseInt(document.getElementById('provider_id').value, 10);
  const service_id = parseInt(document.getElementById('service_id').value, 10);
  const auth_token = sessionStorage.getItem("AuthToken");

  submitCredentials.addEventListener('click', (event) => {
    const inputs = document.querySelectorAll(".credential-input-field");
    const body = {"id_provider": provider_id};

    inputs.forEach(field => {
      if (field.type == 'list') {
        body[field.id] = field.options[field.selectedIndex].value;
      } else {
        body[field.id] = field.value;
      }
    })

    fetch("https://agora.biapi.pro/2.0/users/me/connections", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "Authorization": `Bearer ${auth_token}`
      },
      body: JSON.stringify(body)
    })
    .then(response => response.json())
    .then((data) => {
        sendCredentialsToServer(data, service_id);
    })
  });
}

function sendCredentialsToServer(data, service_id) {
  const form = document.querySelector('form')
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
