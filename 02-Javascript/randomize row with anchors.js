function shuffle(array) {
  for (let i = array.length - 1; i > 0; i--) {
    const j = Math.floor(Math.random() * (i + 1));
    [array[i], array[j]] = [array[j], array[i]];
  }
  return array;
}

function randomizeTableRows(anchored) {
  const tableBody = document.querySelector('.sg-table tbody');
  const allRows = Array.from(tableBody.querySelectorAll('tr'));
  const anchoredGroups = [];
  const nonAnchoredRows = [];

  // Build anchored groups
  anchored.forEach(group => {
    anchoredGroups.push(group.map(index => allRows[index - 1])); // -1 because indices are 1-based
  });

  // Identify non-anchored rows
  allRows.forEach((row, index) => {
    if (!anchored.flat().includes(index + 1)) { // +1 because indices are 1-based
      nonAnchoredRows.push(row);
    }
  });

  // Shuffle the non-anchored rows and anchored groups separately
  const shuffledNonAnchoredRows = shuffle(nonAnchoredRows);
  const shuffledAnchoredGroups = shuffle(anchoredGroups);

  // Clear the table body
  tableBody.innerHTML = '';

  // Append the shuffled anchored groups
  shuffledAnchoredGroups.forEach(group => {
    group.forEach(row => tableBody.appendChild(row));
  });

  // Then, append the shuffled non-anchored rows
  shuffledNonAnchoredRows.forEach(row => tableBody.appendChild(row));
}

// Call this function with the array of anchored group indices
const anchored = [[1,2,3],[5,6,7,8],[9,10,11,12,13],[14,15,16]];
randomizeTableRows(anchored);
