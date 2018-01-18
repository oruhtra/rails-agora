function setUserPreference() {
  document.getElementById('user_preference_value').addEventListener('change', (e) => {
    if (document.getElementById('user_preference_value').checked) {
        document.getElementById('set_user_preference').click();
      }
  })
}

export { setUserPreference }
