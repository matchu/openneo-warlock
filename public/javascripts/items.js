var itemNameEl = $('#item-name');
$('#item-form').submit(function (e) {
  e.preventDefault();
  var itemName = itemNameEl.val();
  var words = itemName.split(' ');
  for(var i in words) {
    words[i] = words[i].substr(0, 1).toUpperCase() + words[i].substr(1).toLowerCase();
  }
  itemName = words.join(' ');
  window.location = '/items/' + encodeURIComponent(itemName).replace(/%20/g, '+');
});

