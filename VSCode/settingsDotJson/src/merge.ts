import { readFileSync, writeFileSync, readdirSync } from "fs";
import { assign, parse, stringify } from "comment-json";
import { join } from "path";

const main = () => {
  const __dirname = import.meta.dirname;
  const dir = join(__dirname, "./modules");

  const files = readdirSync(dir);
  const jsonFiles = files.filter((file) => file.endsWith(".json"));
  let mergedJson = {};

  jsonFiles.forEach((file) => {
    const filePath = join(dir, file);
    const json = parse(readFileSync(filePath, "utf8"));
    mergedJson = assign(mergedJson, json);
  });

  const mergedFilePath = join(__dirname, "../build/settings.json");

  writeFileSync(mergedFilePath, stringify(mergedJson, null, 2));
  console.log(`Merged ${jsonFiles.length} files into ${mergedFilePath}`);
};

main();
