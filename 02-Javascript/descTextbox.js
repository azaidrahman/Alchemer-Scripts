const surveyID = 7236838;
const pageID = 70;
const regexString = `sgE-${surveyID}-${pageID}-(\\d+)-element`;
const regex = new RegExp(regexString);

const inputs = Array.from(document.querySelectorAll(`input[id^="sgE-${surveyID}-${pageID}-"][id$="-element"]`));

const smallestIndex = Math.min(
    ...inputs.map((input) => {
        const match = input.id.match(regex);
        if (!match) {
            return Infinity;
        }
        return parseInt(match[1]);
    })
);

const expectedOrder = [0, 2, 3, 1]; // specified order

// Create an array to store the entered prices
let originalPricesID = [];
let prices = [];

// Add an event listener to each input element
inputs.forEach((input) => {
    input.addEventListener("blur", () => {
        // Get the entered price from the input field
        const price = parseFloat(input.value);

        // Get the index of the input element
        // const regex = /sgE-7236838-70-(\d+)-element/;
        const match = input.id.match(regex);
        if (!match) {
            console.log("Could not determine input position.");
            return;
        }
        const position = parseInt(match[1]) - smallestIndex;

        // Add the entered price to the prices array
        prices[position] = price;
        originalPricesID[position] = parseInt(match[1]);

        console.log("prices", prices);
        console.log("ids", originalPricesID);

        const findInput = (givenID) => {
            for (let i = 0; i < inputs.length; i++) {
                console.log(inputs[i].id.match(regex)[1]);
                if (parseInt(inputs[i].id.match(regex)[1]) === givenID) {
                    return inputs[i];
                }
            }
            return;
        };

        // Check if all prices have been entered
        if (prices.length === 4 && prices.every((price) => !isNaN(price)) && !prices.includes(undefined)) {
            // Check if the entered prices follow the required order
            if (prices[0] >= prices[2] && prices[2] >= prices[3] && prices[3] >= prices[1]) {
                // The entered prices are valid
                console.log("Entered prices are valid:", prices);
            } else {
                const wrongValues = []; // initialize the array to store wrong values

                for (let i = 0; i < expectedOrder.length; i++) {
                    let flag = false;
                    const current = prices[expectedOrder[i]];
                    const prev = expectedOrder.hasOwnProperty(i - 1) ? prices[expectedOrder[i - 1]] : null;
                    const after = expectedOrder.hasOwnProperty(i + 1) ? prices[expectedOrder[i + 1]] : null;
                    if (i === 0) {
                        //first
                        if (current < after) {
                            flag = true;
                        }
                    } else if (!after) {
                        //last
                        if (current > prev) {
                            flag = true;
                        }
                    } else if (current > prev) {
                        if (current > after && i != 1) {
                            // has at least one correct that means the previous is wrong AND cant be 1 because then it will trigger twice with first condition
                            wrongValues.push(expectedOrder[i - 1]);
                        }
                    }

                    if (flag) {
                        wrongValues.push(expectedOrder[i]);
                    }
                }

                console.log("wrong values:", wrongValues);

                if (wrongValues.length <= 1) {
                    const wrongValue = wrongValues[0];
                    const elem = findInput(originalPricesID[wrongValue]);
                    prices[wrongValue] = "";
                    elem.value = "";
                } else {
                    inputs.forEach((input) => (input.value = ""));
                }
                wrongValues.length = 0;
                alert("Please enter a valid price");
            }
        }
    });
});
