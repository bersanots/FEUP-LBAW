function votePost(post_id, value) {
  var xmlhttp = new XMLHttpRequest();
  xmlhttp.onreadystatechange = function() {
    if (this.readyState == 4 && this.status == 200) {
      var myobj = JSON.parse(this.responseText);
      document.getElementById("question-score").innerHTML = myobj[0];
      if (myobj[1] == 1) {
        //is upvoted
        document.getElementById("question-upvote").className =
          "question-upvoted";
        document.getElementById("question-downvote").className =
          "question-downvote";
      } else if (myobj[1] == -1) {
        //is downvoted
        document.getElementById("question-upvote").className =
          "question-upvote";
        document.getElementById("question-downvote").className =
          "question-downvoted";
      } else {
        //is not upvoted
        document.getElementById("question-upvote").className =
          "question-upvote";
        document.getElementById("question-downvote").className =
          "question-downvote";
      }
    }
  };
  //TODO create php upvote
  xmlhttp.open("GET", "../", true);
  xmlhttp.send();
}

function checkIfVoted() {
  var xmlhttp = new XMLHttpRequest();
  let question_id = document.getElementById("question-id-score").innerHTML;
  xmlhttp.onreadystatechange = function() {
    if (this.readyState == 4 && this.status == 200) {
      let vote_value = this.responseText;

      if (vote_value == 1) {
        //is downvoted
        document.getElementById("question-upvote").className =
          "question-upvoted";
        document.getElementById("question-downvote").className =
          "question-downvote";
      } else if (vote_value == -1) {
        //is upvoted
        document.getElementById("question-upvote").className =
          "question-upvote";
        document.getElementById("question-downvote").className =
          "question-downvoted";
      } else {
        //is not voted
        document.getElementById("question-upvote").className =
          "question-upvote";
        document.getElementById("question-downvote").className =
          "question-downvote";
      }
    }
  };
    //TODO create php upvote
    xmlhttp.open("GET", "../", true);
    xmlhttp.send();
}
