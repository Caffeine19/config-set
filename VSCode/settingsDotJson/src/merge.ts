import { readFileSync, writeFileSync, readdirSync } from "fs";
import { assign, parse, stringify } from "comment-json";
import { join } from "path";

const main = () => {
  const __dirname = import.meta.dirname;
  const dir = join(__dirname, "./modules");

  // Check if building for insiders
  const isInsiders = process.argv.includes("--insiders");

  const files = readdirSync(dir);
  let jsonFiles = files.filter((file) => file.endsWith(".json"));

  // Handle file selection based on target
  if (isInsiders) {
    // For insiders, prefer .insiders.json versions when available
    const processedFiles = new Set();
    const finalFiles = [];

    jsonFiles.forEach((file) => {
      if (file.endsWith(".insiders.json")) {
        // This is an insiders file, add it
        finalFiles.push(file);
        // Mark the base name as processed to avoid adding the regular version
        const baseName = file.replace(".insiders.json", ".json");
        processedFiles.add(baseName);
      } else if (!processedFiles.has(file)) {
        // Check if there's an insiders version of this file
        const insidersVersion = file.replace(".json", ".insiders.json");
        if (!jsonFiles.includes(insidersVersion)) {
          // No insiders version exists, use the regular file
          finalFiles.push(file);
        }
        // If insiders version exists, skip this regular file
      }
    });

    jsonFiles = finalFiles;
  } else {
    // For regular Code, exclude all .insiders.json files
    jsonFiles = jsonFiles.filter((file) => !file.endsWith(".insiders.json"));
  }

  let mergedJson = {};

  jsonFiles.forEach((file) => {
    const filePath = join(dir, file);
    const json = parse(readFileSync(filePath, "utf8"));
    mergedJson = assign(mergedJson, json);
  });

  // Add build timestamp comment inside the JSON object
  const buildTimestamp = new Date().toISOString();
  mergedJson["// build at"] =
    buildTimestamp + (isInsiders ? " (insiders)" : "");

  const outputFileName = isInsiders ? "dist.insiders.json" : "dist.json";
  const mergedFilePath = join(__dirname, "../build", outputFileName);
  writeFileSync(mergedFilePath, stringify(mergedJson, null, 2));
  console.log(
    `Merged ${jsonFiles.length} files into ${mergedFilePath}${
      isInsiders ? " (insiders)" : ""
    }`
  );
};

main();
