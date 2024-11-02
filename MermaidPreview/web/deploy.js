#!/usr/bin/env bun
import { $ } from "bun";

$.nothrow();
await $`./clean.js`
await $`bun run build`
await $`rm ../Sources/MermaidPreview/_Resources/*`
await $`cp dist/* ../Sources/MermaidPreview/_Resources`

