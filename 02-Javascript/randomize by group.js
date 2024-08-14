document.addEventListener('DOMContentLoaded', function() {
    var fieldsets = document.querySelectorAll('.sg-question-set fieldset');
    fieldsets.forEach(function(fieldset) {
        processFieldset(fieldset);
    });
});

function processFieldset(fieldset) {
    var specialTexts = ['OTHERS']; // Replace with your special texts
    var listItems = fieldset.querySelectorAll('.sg-question-options ul li');
    var groups = [];
    var currentGroup = [];
    var specialGroups = [];

    // Group list items based on the presence of an input tag within the li element
    listItems.forEach(function(item) {
        // If the item does not contain an input, it's a group header
        if (!item.querySelector('input')) {
            // When a new group header is encountered, push the previous group to the list of groups
            if (currentGroup.length > 0) {
                groups.push(currentGroup);
                currentGroup = [];
            }
        }
        // Keep adding list items to the current group
        currentGroup.push(item);
    });
    // Don't forget to push the last group if there is one
    if (currentGroup.length > 0) {
        groups.push(currentGroup);
    }

    // Identify special groups and separate them
    groups = groups.filter(function(group) {
        var groupHeader = group[0].querySelector('strong')?.textContent.trim();
        // Check if the group header is one of the special texts
        if (specialTexts.includes(groupHeader)) {
            // If so, push the entire group to the specialGroups array
            specialGroups.push(group);
            return false;
        }
        return true;
    });

    // Shuffle the remaining groups
    shuffleArray(groups);

    // Append special groups at the end of the regular groups
    specialGroups.forEach(function(group) {
        groups.push(group);
    });

    // Rearrange elements in the DOM according to the new group order
    var listContainer = fieldset.querySelector('.sg-question-options ul');
    groups.forEach(function(group) {
        group.forEach(function(item) {
            listContainer.appendChild(item);
            // Clear all first/last classes
            item.classList.remove('sg-first-li', 'sg-last-li');
        });
        // Add the sg-first-li class to the first item of the first group
        group[0].classList.add('sg-first-li');
        // Add the sg-last-li class to the last item of the last group
        group[group.length - 1].classList.add('sg-last-li');
    });
}

function shuffleArray(array) {
    for (var i = array.length - 1; i > 0; i--) {
        var j = Math.floor(Math.random() * (i + 1));
        var temp = array[i];
        array[i] = array[j];
        array[j] = temp;
    }
}
