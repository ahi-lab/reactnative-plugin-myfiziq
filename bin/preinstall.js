#!/usr/bin/env node
const execSync = require("child_process").execSync;
console.log("preinstall.js");
out = execSync("which pod");
if(!out) {
    console.log("This package requires cocoapods to be installed on this machine. try running:\n\n\tgem install cocoapods\n\n")
    exit(1); 
}