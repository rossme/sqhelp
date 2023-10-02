import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["textarea"]

  validate(event) {
    const userAnswer = this.textareaTarget.value;

    // Check if the answer contains the word "SELECT" when certain conditions are met
    validateAnswer(userAnswer, event)
  }
}

function validateAnswer(userAnswer, event) {
  const whitelist = ['SELECT'];
  const form = document.getElementById('form-validation')

  if (userAnswer.length === 0 || whitelist.some(word => !userAnswer.toUpperCase().includes(word)) ) {
    // prevent the form from being submitted
    event.preventDefault();

    // remove the text from the form
    const textArea = document.getElementById('exercise_user_answer');
    textArea.value = "";

    // display an alert to the user
    return form.innerHTML = "Your query must contain a SELECT statement.";
  }

  // fetch the list of blacklisted words
  const blacklist= ['DROP', 'DELETE', 'UPDATE', 'INSERT', 'CREATE', 'ALTER', 'DROP', 'DATABASE'];
  const wordsInAnswer = userAnswer.replace(/[^a-zA-Z ]/g, "").split(' ');
  const maliciousWords = wordsInAnswer.filter(word => blacklist.includes(word.toUpperCase()));

  if (maliciousWords.length > 0) {
    // prevent the form from being submitted
    event.preventDefault();

    // remove the text from the form
    const textArea = document.getElementById('exercise_user_answer');
    textArea.value = "";

    // display an alert to the user
    return form.innerHTML = "Your query contains " + maliciousWords.join(', ') + ". This database is read only.";
  }

  if (userAnswer.length > 100) {
    // prevent the form from being submitted
    event.preventDefault();

    // remove the text from the form
    const textArea = document.getElementById('exercise_user_answer');
    textArea.value = "";

    // display an alert to the user
    return form.innerHTML = "Your query must contain a maximum of 100 characters.";
  }
}
