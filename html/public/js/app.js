$(function () {
  $('[data-toggle="tooltip"]').tooltip()
})


function fct_keysize()
{
  var algorithm = document.getElementById('algo').value;
  if(algorithm == "ecdsa")
  {
    document.getElementById('keysize').value = 256;
  }
  else {
    document.getElementById('keysize').value = 4096;
  }
}
