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

function copyFileSync( source, target ) {
  var targetFile = target;
  //if target is a directory a new file with the same name will be created
  if ( fs.existsSync( target ) ) {
      if ( fs.lstatSync( target ).isDirectory() ) {
          targetFile = path.join( target, path.basename( source ) );
      }
  }
  fs.writeFileSync(targetFile, fs.readFileSync(source));
}

// function copyFolderRecursiveSync( source, target ) {
//   var files = [];
//   //check if folder needs to be created or integrated
//   var targetFolder = path.join( target, path.basename( source ) );
//   if ( !fs.existsSync( targetFolder ) ) {
//       fs.mkdirSync( targetFolder );
//   }
//   //copy
//   if ( fs.lstatSync( source ).isDirectory() ) {
//       files = fs.readdirSync( source );
//       files.forEach( function ( file ) {
//           var curSource = path.join( source, file );
//           if ( fs.lstatSync( curSource ).isDirectory() ) {
//               copyFolderRecursiveSync( curSource, targetFolder );
//           } else {
//               copyFileSync( curSource, targetFolder );
//           }
//       } );
//   }
// }

function updateXcodeProject(callback) {
  const g = path.join(process.cwd(), "**", "project.pbxproj");
  glob.sync(g).forEach(path => {
    console.log("Found pbxproj file at ", path);
    const project = pbxproj.project(path);
    project.parse(function (err) {
      console.log("Found Target ", project.getFirstTarget().firstTarget.name);
      var opt = { target : project.getFirstTarget().uuid };
      // project.pbxCreateGroup("RNMyFiziqSdk", "RNMyFiziqSdk");
      // var group = project.findPBXGroupKey({name:'RNMyFiziqSdk'});
      project.addHeaderFile(nodepath + "/reactnative-plugin-myfiziq/ios/RNMyFiziqSdk.h", opt);
      project.addSourceFile(nodepath + "/reactnative-plugin-myfiziq/ios/RNMyFiziqSdk.m", opt);
      project.addHeaderFile(nodepath + "/reactnative-plugin-myfiziq/ios/RNMyFiziqWrapAvatar.h", opt);
      project.addSourceFile(nodepath + "/reactnative-plugin-myfiziq/ios/RNMyFiziqWrapAvatar.m", opt);
      project.addHeaderFile(nodepath + "/reactnative-plugin-myfiziq/ios/RNMyFiziqWrapCommon.h", opt);
      project.addSourceFile(nodepath + "/reactnative-plugin-myfiziq/ios/RNMyFiziqWrapCommon.m", opt);
      project.addHeaderFile(nodepath + "/reactnative-plugin-myfiziq/ios/RNMyFiziqWrapCore.h", opt);
      project.addSourceFile(nodepath + "/reactnative-plugin-myfiziq/ios/RNMyFiziqWrapCore.m", opt);
      project.addHeaderFile(nodepath + "/reactnative-plugin-myfiziq/ios/RNMyFiziqWrapUser.h", opt);
      project.addSourceFile(nodepath + "/reactnative-plugin-myfiziq/ios/RNMyFiziqWrapUser.m", opt);
      project.addHeaderFile(nodepath + "/reactnative-plugin-myfiziq/ios/RNMyFiziqWrapCognitoAuth.h", opt);
      project.addSourceFile(nodepath + "/reactnative-plugin-myfiziq/ios/RNMyFiziqWrapCognitoAuth.m", opt);
      fs.writeFileSync(path, project.writeSync());
      console.log('Add MyFiziq source files...done');
      if (callback) {
        callback();
      }
    });
  });
}

// Update XCode project with new files
updateXcodeProject(() => {
  // Pod install
  spawnSync("pod", ["install"], opts);
  if (doFix) {
    const fixPods = require("../lib/fixPods");
    process.chdir(mydir);
    fixPods();
  }
  // Remove duplicate React package.json
  spawnSync("rm", ["-f", "Pods/React/package.json"]);
});

