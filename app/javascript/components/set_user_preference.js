function setUserPreference() {
  document.querySelectorAll('#new_user_preference').forEach(f => {
    f.querySelector('#user_preference_value').addEventListener('change', (e) => {
      if (f.querySelector('#user_preference_value').checked) {
          f.querySelector('#set_user_preference').click();
        }
    });
  });
}

export { setUserPreference }
