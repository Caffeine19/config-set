import { readFileSync, writeFileSync, readdirSync } from "fs";
import { assign, parse, stringify } from "comment-json";
import { join } from "path";
import { diff } from "radash";

/**
 * Check if building for insiders
 */
const isInsiders = process.argv.includes("--insiders");

const JSON_EXT = ".json";
const INSIDERS_JSON_EXT = ".insiders.json";

const main = () => {
  const __dirname = import.meta.dirname;
  const dir = join(__dirname, "./modules");

  const files = readdirSync(dir);
  let jsonFiles = files.filter((file) => file.endsWith(JSON_EXT));

  // Handle file selection based on target
  if (isInsiders) {
    // For insiders, prefer .insiders.json versions when available
    const overridden = jsonFiles
      .filter((f) => f.endsWith(INSIDERS_JSON_EXT))
      .map((f) => f.replace(INSIDERS_JSON_EXT, JSON_EXT));
    jsonFiles = diff(jsonFiles, overridden);
  } else {
    // For regular Code, exclude all .insiders.json files
    jsonFiles = jsonFiles.filter((file) => !file.endsWith(INSIDERS_JSON_EXT));
  }

  const buildTimestamp = new Date().toISOString();

  let mergedJson: any = jsonFiles.reduce((prev, cur) => {
    return assign(prev, parse(readFileSync(join(dir, cur), "utf8")));
  }, {});

  mergedJson["// build at"] = buildTimestamp;

  const outputFileName = isInsiders ? "dist.insiders.json" : "dist.json";
  const mergedFilePath = join(__dirname, "../build", outputFileName);
  writeFileSync(mergedFilePath, stringify(mergedJson, null, 2));
  console.log(
    `Merged ${jsonFiles.length} files into ${mergedFilePath}${
      isInsiders ? " (insiders)" : ""
    }`,
  );
};

main();
