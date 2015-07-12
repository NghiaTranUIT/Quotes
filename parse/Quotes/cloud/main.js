
// Use Parse.Cloud.define to define as many cloud functions as you want.
// For example:
Parse.Cloud.define("hello", function(request, response) {
  response.success("Hello world!");
});

Parse.Cloud.define("incrementReadCount", function(request, response) {
  var query = new Parse.Query("Quote");
  query.equalTo("objectId", request.params.objectId);
  query.find({
    success: function(results) {
      results[0].increment("readCount");
      results[0].save();
      response.success(results);
    },
    error: function() {
      response.error("cannot find that quote");
    }
  })
});
