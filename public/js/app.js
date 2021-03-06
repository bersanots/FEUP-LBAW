"use_strict";

const csrf_token = document.querySelector("meta[name='csrf-token']");
const questionPattern = new RegExp("questions\/[0-9]+");
if (questionPattern.test(window.location.href))
    checkIfVoted();

function voteQuestion(question_id, value) {
    const xmlhttp = new XMLHttpRequest();
    xmlhttp.onload = function() {
        if (this.readyState == 4 && this.status == 200) {
            const myobj = JSON.parse(this.responseText);
            document.getElementById("question-score").innerHTML = myobj['count'];
            upBtn = document.getElementById("questionUpBtn");
            downBtn = document.getElementById("questionDownBtn");
            changeVoteArrows(myobj['userVote'], upBtn, downBtn);
        }
    };
    xmlhttp.open("POST", "vote/question", true);
    xmlhttp.setRequestHeader("Content-Type", "application/json;charset=UTF-8");
    xmlhttp.send(JSON.stringify({
        _token: csrf_token.content,
        question_id: question_id,
        value: value
    }));
}

function favouriteQuestion(question_id) {
    const xmlhttp = new XMLHttpRequest();
    xmlhttp.onload = function() {
        if (this.readyState == 4 && this.status == 200) {
            const myobj = JSON.parse(this.responseText);
            favBtn = document.getElementById("questionFavBtn");
            changeFavouriteStar(myobj, favBtn);
        }
    };
    xmlhttp.open("POST", "favourite", true);
    xmlhttp.setRequestHeader("Content-Type", "application/json;charset=UTF-8");
    xmlhttp.send(JSON.stringify({
        _token: csrf_token.content,
        question_id: question_id,
    }));
}

function checkIfVoted() {
    const xmlhttp = new XMLHttpRequest();
    let question_id = document.getElementById("questionId").innerHTML;
    xmlhttp.onload = function() {
        if (this.readyState == 4 && this.status == 200) {
            const myobj = JSON.parse(this.responseText);
            upBtn = document.getElementById("questionUpBtn");
            downBtn = document.getElementById("questionDownBtn");
            favBtn = document.getElementById("questionFavBtn");
            changeVoteArrows(myobj['vote'], upBtn, downBtn);
            changeFavouriteStar(myobj['favourite'], favBtn);
        }
    };
    xmlhttp.open("POST", "getVoteValue", true);
    xmlhttp.setRequestHeader("Content-Type", "application/json;charset=UTF-8");
    xmlhttp.send(JSON.stringify({
        _token: csrf_token.content,
        question_id: question_id,
    }));
}

function voteAnswer(answer_id, value) {
    const xmlhttp = new XMLHttpRequest();
    xmlhttp.onload = function() {
        if (this.readyState == 4 && this.status == 200) {
            const myobj = JSON.parse(this.responseText);
            console.log(myobj);
            let score = document.querySelector("[id='" + answer_id + "'] .answer-score");
            score.innerHTML = myobj['count'];
            let upBtn = document.querySelector("[id='" + answer_id + "'] .answerUp");
            let downBtn = document.querySelector("[id='" + answer_id + "'] .answerDown");
            changeVoteArrowsAnswer(myobj['userVote'], upBtn, downBtn);
        }
    };
    xmlhttp.open("POST", "vote/answer", true);
    xmlhttp.setRequestHeader("Content-Type", "application/json;charset=UTF-8");
    xmlhttp.send(JSON.stringify({
        _token: csrf_token.content,
        answer_id: answer_id,
        value: value
    }));
}


function changeVoteArrowsAnswer(value, upvoteBtn, downvoteBtn) {
    switch (value) {
        case 1:
            {
                //is upvoted
                upvoteBtn.className = "answerUp upvoted";
                downvoteBtn.className = "answerDown downvote";
                break;
            }
        case -1:
            {
                //is downvoted
                upvoteBtn.className = "answerUp upvote";
                downvoteBtn.className = "answerDown downvoted";
                break;
            }
        default:
            {
                //is not upvoted
                upvoteBtn.className = "answerUp upvote";
                downvoteBtn.className = "answerDown downvote";
            }
    }
}

function changeVoteArrows(value, upvoteBtn, downvoteBtn) {
    switch (value) {
        case 1:
            {
                //is upvoted
                upvoteBtn.className = "question-upvoted";
                downvoteBtn.className = "question-downvote";
                break;
            }
        case -1:
            {
                //is downvoted
                upvoteBtn.className = "question-upvote";
                downvoteBtn.className = "question-downvoted";
                break;
            }
        default:
            {
                //is not upvoted
                upvoteBtn.className = "question-upvote";
                downvoteBtn.className = "question-downvote";
            }
    }
}

function changeFavouriteStar(value, favBtn) {
    if (value)
        favBtn.className = "question-favourited";
    else
        favBtn.className = "question-favourite";
}


function addEventListeners() {
    let answerCheckers = document.querySelectorAll(
        "article.question li.answer input[type=checkbox]"
    );
    [].forEach.call(answerCheckers, function(checker) {
        checker.addEventListener("change", sendanswerUpdateRequest);
    });

    let answerCreators = document.querySelectorAll(
        "article.question form.new_answer"
    );
    [].forEach.call(answerCreators, function(creator) {
        creator.addEventListener("submit", sendCreateanswerRequest);
    });

    let answerDeleters = document.querySelectorAll(
        "article.question li a.delete"
    );
    [].forEach.call(answerDeleters, function(deleter) {
        deleter.addEventListener("click", sendDeleteanswerRequest);
    });

    let questionDeleters = document.querySelectorAll(
        "article.question header a.delete"
    );
    [].forEach.call(questionDeleters, function(deleter) {
        deleter.addEventListener("click", sendDeletequestionRequest);
    });

    let questionCreator = document.querySelector(
        "article.question form.new_question"
    );
    if (questionCreator != null)
        questionCreator.addEventListener("submit", sendCreatequestionRequest);
}

function encodeForAjax(data) {
    if (data == null) return null;
    return Object.keys(data)
        .map(function(k) {
            return encodeURIComponent(k) + "=" + encodeURIComponent(data[k]);
        })
        .join("&");
}

function sendAjaxRequest(method, url, data, handler) {
    let request = new XMLHttpRequest();

    request.open(method, url, true);
    request.setRequestHeader(
        "X-CSRF-TOKEN",
        document.querySelector('meta[name="csrf-token"]').content
    );
    request.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
    request.addEventListener("load", handler);
    request.send(encodeForAjax(data));
}

function sendAnswerUpdateRequest() {
    let answer = this.closest("li.answer");
    let id = answer.getAttribute("data-id");
    let checked = answer.querySelector("input[type=checkbox]").checked;

    sendAjaxRequest(
        "post",
        "/api/answer/" + id, { done: checked },
        answerUpdatedHandler
    );
}

function sendDeleteAnswerRequest() {
    let id = this.closest("li.answer").getAttribute("data-id");

    sendAjaxRequest("delete", "/api/answer/" + id, null, answerDeletedHandler);
}

function sendCreateAnswerRequest(event) {
    let id = this.closest("article").getAttribute("data-id");
    let description = this.querySelector("input[name=description]").value;

    if (description != "")
        sendAjaxRequest(
            "put",
            "/api/questions/" + id, { description: description },
            answerAddedHandler
        );

    event.preventDefault();
}

function sendDeletequestionRequest(event) {
    let id = this.closest("article").getAttribute("data-id");

    sendAjaxRequest(
        "delete",
        "/api/questions/" + id,
        null,
        questionDeletedHandler
    );
}

function sendCreatequestionRequest(event) {
    let name = this.querySelector("input[name=name]").value;

    if (name != "")
        sendAjaxRequest(
            "put",
            "/api/questions/", { name: name },
            questionAddedHandler
        );

    event.preventDefault();
}

function answerUpdatedHandler() {
    let answer = JSON.parse(this.responseText);
    let element = document.querySelector(
        'li.answer[data-id="' + answer.id + '"]'
    );
    let input = element.querySelector("input[type=checkbox]");
    element.checked = answer.done == "true";
}

function answerAddedHandler() {
    if (this.status != 200) window.location = "/";
    let answer = JSON.parse(this.responseText);

    // Create the new answer
    let new_answer = createAnswer(answer);

    // Insert the new answer
    let question = document.querySelector(
        'article.question[data-id="' + answer.question_id + '"]'
    );
    let form = question.querySelector("form.new_answer");
    form.previousElementSibling.append(new_answer);

    // Reset the new answer form
    form.querySelector("[type=text]").value = "";
}

function answerDeletedHandler() {
    if (this.status != 200) window.location = "/";
    let answer = JSON.parse(this.responseText);
    let element = document.querySelector(
        'li.answer[data-id="' + answer.id + '"]'
    );
    element.remove();
}

function questionDeletedHandler() {
    if (this.status != 200) window.location = "/";
    let question = JSON.parse(this.responseText);
    let article = document.querySelector(
        'article.question[data-id="' + question.id + '"]'
    );
    article.remove();
}

function questionAddedHandler() {
    if (this.status != 200) window.location = "/";
    let question = JSON.parse(this.responseText);

    // Create the new question
    let new_question = createquestion(question);

    // Reset the new question input
    let form = document.querySelector("article.question form.new_question");
    form.querySelector("[type=text]").value = "";

    // Insert the new question
    let article = form.parentElement;
    let section = article.parentElement;
    section.insertBefore(new_question, article);

    // Focus on adding an answer to the new question
    new_question.querySelector("[type=text]").focus();
}

function createquestion(question) {
    let new_question = document.createElement("article");
    new_question.classList.add("question");
    new_question.setAttribute("data-id", question.id);
    new_question.innerHTML = `

  <header>
    <h2><a href="questions/${question.id}">${question.name}</a></h2>
    <a href="#" class="delete">&#10761;</a>
  </header>
  <ul></ul>
  <form class="new_answer">
    <input name="description" type="text">
  </form>`;

    let creator = new_question.querySelector("form.new_answer");
    creator.addEventListener("submit", sendCreateanswerRequest);

    let deleter = new_question.querySelector("header a.delete");
    deleter.addEventListener("click", sendDeletequestionRequest);

    return new_question;
}

function createanswer(answer) {
    let new_answer = document.createElement("li");
    new_answer.classList.add("answer");
    new_answer.setAttribute("data-id", answer.id);
    new_answer.innerHTML = `
  <label>
    <input type="checkbox"> <span>${
        answer.description
        }</span><a href="#" class="delete">&#10761;</a>
  </label>
  `;

    new_answer
        .querySelector("input")
        .addEventListener("change", sendanswerUpdateRequest);
    new_answer
        .querySelector("a.delete")
        .addEventListener("click", sendDeleteanswerRequest);

    return new_answer;
}

addEventListeners();