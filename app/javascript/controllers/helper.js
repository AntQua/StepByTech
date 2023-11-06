export function getMetaValue(name) {
    const element = findElement(document.head, `meta[name="${name}"]`);
    if (element) {
        return element.getAttribute("content");
    }
}

export function findElement(root, selector) {
    if (typeof root == "string") {
        selector = root;
        root = document;
    }
    return root.querySelector(selector);
}

export function loadStepsOptions(programId) {
    const url = `/steps/${programId}/table_data`;
    return fetch(url)
        .then(response => {
            if (!response.ok) {
                throw new Error('Network response was not ok');
            }
            return response.json();
        })
        .catch(error => console.error('Error: ', error));
}

export function loadQuestionsOptions(programId) {
    const url = `/step_questions/${programId}/table_data`;
    return fetch(url)
        .then(response => {
            if (!response.ok) {
                throw new Error('Network response was not ok');
            }
            return response.json();
        })
        .catch(error => console.error('Error: ', error));
}

