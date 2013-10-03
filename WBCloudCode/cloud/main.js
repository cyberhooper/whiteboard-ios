/* 
    Get the number of photos a user has and store it directly in the user table.
    This saves the clients an extra request for counting the photos.
 
    The afterSave method is triggered automatically every time a photo is
    uploaded so that it is always synced.
*/
Parse.Cloud.afterSave("Photo", function(request) {
  var user = userFromRequest(request);
  updateNumberOfPhotosForUser(user);
});
 
Parse.Cloud.beforeDelete("Photo", function(request, response) {
  var author = userFromRequest(request);
  var requester = request.user;
  if (author.id != requester.id) {
    response.error("You do not have permission to delete this photo.");
  } else {
    response.success();
  }
});
 
Parse.Cloud.afterDelete("Photo", function(request) {
  var user = userFromRequest(request);
  updateNumberOfPhotosForUser(user);
});
 
function userFromRequest(request) {
  return request.object.get("user");
}
 
function updateNumberOfPhotosForUser(user) {
  var query = new Parse.Query("Photo");
  query.equalTo("user", user);
  query.count({
    success: function(number) {
      setNumberOfPhotosForUser(number, user);
    }
  });
}
 
function setNumberOfPhotosForUser(numberOfPhotos, user) {
  user.set("numberOfPhotos", numberOfPhotos);
  user.save();
 }
  
 /*
 Add a comment to a photo
 */
Parse.Cloud.define("addCommentToPhoto", function(request, response) {
  Parse.Cloud.useMasterKey();

  var comment = new Parse.Object('Comment');
  comment.set('text', request.params.comment);
  comment.set('user', Parse.User.current());
  comment.save().then(function() {
    var photoQuery = new Parse.Query("Photo");
    return photoQuery.get(request.params.photoId);
  }).then(function(photo) {
    photo.addUnique("comments", comment);
    return photo.save();
  }).then(function() {
    response.success(photo);
  }),
  function(error) {
    response.error("An error occured : " + error.code + ", " + error.message);
  })
});

