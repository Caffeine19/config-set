const main = () => {
    // merge all json files in the current directory into a single json file
    const fs = require('fs');
    const path = require('path');
    const dir = path.join(__dirname, 'json');
    const files = fs.readdirSync(dir);
    const jsonFiles = files.filter(file => file.endsWith('.json'));
    const mergedJson = {};
    jsonFiles.forEach(file => {
        const filePath = path.join(dir, file);
        const json = JSON.parse(fs.readFileSync(filePath, 'utf8'));
        Object.keys(json).forEach(key => {
            if (mergedJson[key]) {
                mergedJson[key] = { ...mergedJson[key], ...json[key] };
            } else {
                mergedJson[key] = json[key];
            }
        });
    }
    const mergedFilePath = path.join(dir, 'merged.json');
    fs.writeFileSync(mergedFilePath, JSON.stringify(mergedJson, null, 2));
    console.log(`Merged ${jsonFiles.length} files into ${mergedFilePath}`);
}

main()