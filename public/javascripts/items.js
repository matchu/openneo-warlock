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

var shareYourStory = $('#share-your-story');
var commentsEl = $('#comments');

shareYourStory.attr('href', '#').click(function (e) {
  e.preventDefault();
  var nowVisible = commentsEl.is(':hidden');
  commentsEl.slideToggle(500);
  window.localStorage.setItem('comments_visible', nowVisible);
});

if(window.localStorage.getItem('comments_visible') == 'true') {
  commentsEl.show();
}

