function getRandom() {
  let randomStr = Math.random().toString(32).substring(2, 5) +
    Math.random().toString(32).substring(2, 5);

  return randomStr;
}

function getURL() {
  const expression = /https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)/
  const regex = new RegExp(expression);

  const url = document.getElementById("url").value;

  if (url.match(regex)) {
    alert("Valid URL");
  } else {
    alert ("Invalid URL");
  }

}

function shortURL() {
  let url = getURL();
}
