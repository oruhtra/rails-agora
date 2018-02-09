function showActiveTab() {
  const id = document.getElementById('tab_name').innerText;
  document.getElementById(`${id}`).classList.add('active');
}

export { showActiveTab }
