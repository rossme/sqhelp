import {Controller} from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["textarea"]

  limit(event) {
    const textareaTarget = this.textareaTarget;
    limitCharacters(textareaTarget, 200);
  }

  hint(event) {
    const exerciseQuery = this.data.element.dataset.exerciseQuery;
    showRedactedHint(event, exerciseQuery);
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
  if (lines.length > 9) {
    // If there are more than 9 lines, remove the extra lines
    lines.length = 9;
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

// Validate the user's answer
function validateAnswer(event, userAnswer) {
  const whitelist = ['SELECT'];

  if (userAnswer.length === 0 || whitelist.some(word => !userAnswer.toUpperCase().includes(word)) ) {
    return userMessage(event, 'Your query must contain the word "SELECT".');
  }

  // fetch the list of blacklisted words
  const blacklist= ['VALUES', 'VIEW', 'TABLE', 'SET', 'INDEX', 'DROP', 'DELETE', 'UPDATE', 'INSERT', 'CREATE', 'ALTER', 'DROP', 'DATABASE', 'COLUMN'];
  const wordsInAnswer = userAnswer.replace(/[^a-zA-Z ]/g, "").split(' ');
  const maliciousWords = wordsInAnswer.filter(word => blacklist.includes(word.toUpperCase()));

  if (maliciousWords.length > 0) {
    return userMessage(event, 'Your query contains "' + maliciousWords.join(', ') + '". The database is read only.');
  }

  if (userAnswer.length > 300) {
    return userMessage(event, "Your query must contain a maximum of 300 characters.");
  }

  if (userAnswer.charAt(userAnswer.length - 1) !== ';') {
    return userMessage(event, "It's always safer to end your query with a semicolon ';'.");
  }

  // Call the exercises controller to update the exercise
  callExercisesController(event, userAnswer)
}

// Display a message to the user
function userMessage(event, message, http_status) {
  // display an alert to the user
  const formValidationElement = document.getElementById('form-validation')

  // if the http status is 200, then the query was successful
  if (http_status === 200) {
    const nextButtonElement = document.getElementById('exercise_next_button')
    const submitButtonElement = document.getElementById('exercise_submit_button')

    submitButtonElement.classList.add('disabled');
    nextButtonElement.classList.toggle('d-none');
    formValidationElement.classList.remove('text-danger');
    formValidationElement.classList.add('text-success');

    const textareaTarget = event.target.closest('form').querySelector('textarea');
    return formValidationElement.innerHTML = "🚀 " + message;
  }

  // display an alert to the user
  formValidationElement.classList.remove('text-success');
  formValidationElement.classList.add('text-danger');
  return formValidationElement.innerHTML = 'Query error: ' + message;
}

function callExercisesController(event, userAnswer) {
  const exerciseUrl = '/exercises';
  const csrfToken = document.querySelector('meta[name="csrf-token"]').getAttribute('content'); // Get the CSRF token from the meta tag

  //
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
    userMessage(event, data.message, data.http);
  })
  .catch(error => {
    // Catch any errors that occurred during the fetch
    console.error('Error:', error);
  });
}

// Show a redacted hint for the exercise
function showRedactedHint(event, exerciseQuery) {
  const hint = document.getElementById('form-hint');

  // Display the redacted result in the 'form-hint' div
  hint.classList.toggle('d-none');
  document.getElementById('form-hint').innerHTML = redactEveryOtherWordOrSymbol(exerciseQuery);
}

// Redact every other word or symbol in the exercise query
function redactEveryOtherWordOrSymbol(exerciseQuery) {
  const wordsOrSymbols = exerciseQuery.split(/\s+/); // Split the input string into words or symbols

  for (let i = 0; i < wordsOrSymbols.length; i++) {
    // Check if the current word or symbol should be redacted (odd position)
    if (i % 2 === 1) {
      // Create a span element with the 'redacted' class and the redacted content
      const redactedSpan = document.createElement('span');
      redactedSpan.classList.add('redacted');
      redactedSpan.textContent = wordsOrSymbols[i];

      // Replace the word with the redacted span
      wordsOrSymbols[i] = redactedSpan.outerHTML;
    }
  }
  // Join the redacted words or symbols back into a string
  return wordsOrSymbols.join(' ');
}
