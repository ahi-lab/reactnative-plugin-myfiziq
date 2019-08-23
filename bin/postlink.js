#!/usr/bin/env node
const path = require("path");
const process = require("process");
var pbxproj = require("@raydeck/xcode");
var fs = require("fs");
var glob = require("glob");
const { spawnSync } = require("child_process");
const registerPodsFromPackage = require("../lib/registerPodsFromPackage");
const dependencies = require("../lib/getProjectDependencies")();
const package = require("../lib/getProject")();
const nodepath = process.cwd() + "/node_modules";
const opts = {
  encoding: "utf8",
  stdio: "inherit"
};
var isSwift = false;
var needsSwiftFix = false;
console.log("postlink.js");
dependencies.map(dependency => {
  const package = require(path.resolve(nodepath, dependency, "package.json"));
  registerPodsFromPackage(package);
  if (package.isSwift) isSwift = true;
  if (package.needsSwiftFix) needsSwiftFix = true;
});
registerPodsFromPackage(package);
if (package.isSwift) isSwift = true;
if (package.needsSwiftFix) needsSwiftFix = true;
//Now that all my pods are here, let's run a pod install
const doFix = isSwift && needsSwiftFix;
const mydir = process.cwd();
process.chdir("./ios");
// Copy in the MYQ binding files
fs.copyFile(nodepath + "/react-native-my-fiziq-sdk/ios/RNMyFiziqSdk.h", "RNMyFiziqSdk.h", (err) => {if (err) throw err;});
fs.copyFile(nodepath + "/react-native-my-fiziq-sdk/ios/RNMyFiziqSdk.m", "RNMyFiziqSdk.m", (err) => {if (err) throw err;});
fs.copyFile(nodepath + "/react-native-my-fiziq-sdk/ios/RNMyFiziqWrapAvatar.h", "RNMyFiziqWrapAvatar.h", (err) => {if (err) throw err;});
fs.copyFile(nodepath + "/react-native-my-fiziq-sdk/ios/RNMyFiziqWrapAvatar.m", "RNMyFiziqWrapAvatar.m", (err) => {if (err) throw err;});
fs.copyFile(nodepath + "/react-native-my-fiziq-sdk/ios/RNMyFiziqWrapCommon.h", "RNMyFiziqWrapCommon.h", (err) => {if (err) throw err;});
fs.copyFile(nodepath + "/react-native-my-fiziq-sdk/ios/RNMyFiziqWrapCommon.m", "RNMyFiziqWrapCommon.m", (err) => {if (err) throw err;});
fs.copyFile(nodepath + "/react-native-my-fiziq-sdk/ios/RNMyFiziqWrapCore.h", "RNMyFiziqWrapCore.h", (err) => {if (err) throw err;});
fs.copyFile(nodepath + "/react-native-my-fiziq-sdk/ios/RNMyFiziqWrapCore.m", "RNMyFiziqWrapCore.m", (err) => {if (err) throw err;});
fs.copyFile(nodepath + "/react-native-my-fiziq-sdk/ios/RNMyFiziqWrapUser.h", "RNMyFiziqWrapUser.h", (err) => {if (err) throw err;});
fs.copyFile(nodepath + "/react-native-my-fiziq-sdk/ios/RNMyFiziqWrapUser.m", "RNMyFiziqWrapUser.m", (err) => {if (err) throw err;});
fs.copyFile(nodepath + "/react-native-my-fiziq-sdk/ios/RNMyFiziqWrapCognitoAuth.h", "RNMyFiziqWrapCognitoAuth.h", (err) => {if (err) throw err;});
fs.copyFile(nodepath + "/react-native-my-fiziq-sdk/ios/RNMyFiziqWrapCognitoAuth.m", "RNMyFiziqWrapCognitoAuth.m", (err) => {if (err) throw err;});
// Update XCode project with new files
const g = path.join(process.cwd(), "**", "project.pbxproj");
glob.sync(g).forEach(path => {
  console.log("Found pbxproj file at ", path);
  const project = pbxproj.project(path);
  project.parse(function (err) {
    console.log("Found Target ", project.getFirstTarget().firstTarget.name);
    var opt = { target : project.getFirstTarget().uuid };
    // project.pbxCreateGroup("RNMyFiziqSdk", "RNMyFiziqSdk");
    // var group = project.findPBXGroupKey({name:'RNMyFiziqSdk'});
    project.addHeaderFile('RNMyFiziqSdk.h', opt);
    project.addSourceFile('RNMyFiziqSdk.m', opt);
    project.addHeaderFile('RNMyFiziqWrapAvatar.h', opt);
    project.addSourceFile('RNMyFiziqWrapAvatar.m', opt);
    project.addHeaderFile('RNMyFiziqWrapCommon.h', opt);
    project.addSourceFile('RNMyFiziqWrapCommon.m', opt);
    project.addHeaderFile('RNMyFiziqWrapCore.h', opt);
    project.addSourceFile('RNMyFiziqWrapCore.m', opt);
    project.addHeaderFile('RNMyFiziqWrapUser.h', opt);
    project.addSourceFile('RNMyFiziqWrapUser.m', opt);
    project.addHeaderFile('RNMyFiziqWrapCognitoAuth.h', opt);
    project.addSourceFile('RNMyFiziqWrapCognitoAuth.m', opt);
    fs.writeFileSync(path, project.writeSync());
    console.log('Add MyFiziq source files...done');
  });
});
// Pod install
spawnSync("pod", ["install"], opts);
if (doFix) {
  const fixPods = require("../lib/fixPods");
  process.chdir(mydir);
  fixPods();
}
// Remove duplicate React package.json
spawnSync("rm", ["-f", "Pods/React/package.json"]);
