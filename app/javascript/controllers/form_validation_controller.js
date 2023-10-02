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
  const blacklist= ['DROP', 'DELETE', 'UPDATE', 'INSERT', 'CREATE', 'ALTER', 'DROP', 'DATABASE'];
  const wordsInAnswer = userAnswer.replace(/[^a-zA-Z]/g, "").split(' ');
  const maliciousWords = wordsInAnswer.filter(word => blacklist.includes(word.toUpperCase()));

  if (maliciousWords.length > 0) {
    event.preventDefault();
    return alert("Your query contains " + maliciousWords.join(', ') + ". It does not meet the conditions for inclusion. Please review your answer.");
  }

  if (userAnswer.length > 100) {
    event.preventDefault();
    return alert("Your query must contain a maximum of 100 characters. It does not meet the conditions for inclusion. Please review your answer.");
  }
}
