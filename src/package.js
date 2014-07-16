var exec = require('child_process').exec;
var sysPath = require('path');
var fs = require('fs');

var mode = process.argv[2];

var fsExists = fs.exists || sysPath.exists;

var execute = function(pathParts, params, callback) {
  if (callback == null) callback = function() {};
  var path = sysPath.join.apply(null, pathParts);
  var command = 'node ' + path + ' ' + params;
  console.log('Executing', command);
  exec(command, function(error, stdout, stderr) {
    if (error != null) return process.stderr.write(stderr.toString());
    console.log(stdout.toString());
  });
};

if (mode.match(/postinstall|prepublish|postinstall|build|watch/)) {
  fsExists(sysPath.join(__dirname, 'tabcordion.js'), function(exists) {
    if (mode === 'postinstall' && exists) return;
    execute(['node_modules', 'jade', 'bin', 'jade'], (mode === 'watch' ? '-w ' : '') + '-O . *.jade');
  });
} else if (mode === 'test') {
  execute(['node_modules', 'mocha', 'bin', 'mocha'],
    '--require test/common.js --colors');
}
