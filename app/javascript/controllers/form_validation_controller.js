import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["textarea"]

  limit(event) {
    limitCharacters(this.textareaTarget, 30);
  }

  validate(event) {
    const userAnswer = this.textareaTarget.value;
    // Prevent the default form submission behavior
    event.preventDefault();

    // Check if the answer contains the word "SELECT" when certain conditions are met
    validateAnswer(event, userAnswer);
  }
}

// Limit the number of characters and lines in the textarea
function limitCharacters(textarea, lineCharacterLimit) {
  const lines = textarea.value.split('\n');
  if (lines.length > 8) {
    // If there are more than 8 lines, remove the extra lines
    lines.length = 8;
  }

  for (let i = 0; i < lines.length; i++) {
    if (lines[i].length > lineCharacterLimit) {
      // If a line exceeds the character limit, truncate it
      lines[i] = lines[i].slice(0, lineCharacterLimit);
    }
  }

  // Update the textarea's value with the modified lines
  textarea.value = lines.join('\n');
}

function validateAnswer(event, userAnswer) {
  const whitelist = ['SELECT'];

  if (userAnswer.length === 0 || whitelist.some(word => !userAnswer.toUpperCase().includes(word)) ) {
    return userMessage(event, 'Your query must contain the word "SELECT".');
  }

  // fetch the list of blacklisted words
  const blacklist= ['DROP', 'DELETE', 'UPDATE', 'INSERT', 'CREATE', 'ALTER', 'DROP', 'DATABASE'];
  const wordsInAnswer = userAnswer.replace(/[^a-zA-Z ]/g, "").split(' ');
  const maliciousWords = wordsInAnswer.filter(word => blacklist.includes(word.toUpperCase()));

  if (maliciousWords.length > 0) {
    return userMessage(event, 'Your query contains "' + maliciousWords.join(', ') + '". The database is read only.');
  }

  if (userAnswer.length > 100) {
    return userMessage(event, "Your query must contain a maximum of 100 characters.");
  }

  // Call the exercises controller to update the exercise
  callExercisesController(event, userAnswer)
}

function userMessage(event, message) {
  // remove the text from the form
  const textArea = document.getElementById('exercise_user_answer');
  textArea.value = "";

  if (message === 'Correct!') {
    document.getElementById('exercise_next_button').classList.remove('disabled');
  }

  // display an alert to the user
  const formValidationElement = document.getElementById('form-validation')
  return formValidationElement.innerHTML = message;
}

function callExercisesController(event, userAnswer) {
  const exerciseUrl = '/exercises';
  const csrfToken = document.querySelector('meta[name="csrf-token"]').getAttribute('content'); // Get the CSRF token from the meta tag

  fetch(exerciseUrl, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'X-CSRF-Token': csrfToken, // Include the CSRF token in the headers
    },
    body: JSON.stringify({
      exercise: {
        exercise_id: event.target.dataset.exerciseId,
        user_answer: userAnswer
      }
    })
  })
  .then(response => response.json()) // Parse the JSON response into a JavaScript object
  .then(data => {
    // Show the user the result of their query
    userMessage(event, data.message);
  })
  .catch(error => {
    // Catch any errors that occurred during the fetch
    console.error('Error:', error);
  });
}
