import { readFileSync, writeFileSync, readdirSync } from "fs";
import { CommentArray, CommentJSONValue, parse, stringify } from "comment-json";
import { join } from "path";

const main = () => {
  const __dirname = import.meta.dirname;
  const dir = join(__dirname, "./modules");

  const files = readdirSync(dir);
  const jsonFiles = files.filter((file) => file.endsWith(".json"));

  let mergedJson = new CommentArray<CommentJSONValue>();

  jsonFiles.forEach((file) => {
    const filePath = join(dir, file);
    const json = parse<CommentArray<CommentJSONValue>>(
      readFileSync(filePath, "utf8"),
    );
    const offset = mergedJson.length;

    json.forEach((item) => mergedJson.push(item));

    // Remap comment-json symbol indices to preserve inline comments
    Object.getOwnPropertySymbols(json).forEach((sym) => {
      const match = (sym.description ?? "").match(
        /^(before|after|before-value|after-value):(\d+)$/,
      );
      if (match) {
        const newSym = Symbol.for(`${match[1]}:${parseInt(match[2]) + offset}`);
        mergedJson[newSym] = json[sym];
      }
    });
  });

  const mergedFilePath = join(__dirname, "../build", "dist.json");
  writeFileSync(mergedFilePath, stringify(mergedJson, null, 2));
  console.log(`Merged ${jsonFiles.length} files into ${mergedFilePath}`);
};

main();
