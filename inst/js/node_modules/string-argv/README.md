
#What is it?
string-argv parses a string into an argument array to mimic process.argv.
This is useful when testing Command Line Utilities that you want to pass arguments to and is the opposite of what the other argv utilities do.

#Installation
```
npm install string-argv --save
```
#Usage
```
var util = require('../index');
var args = util.parseArgsStringToArgv(
    '-testing test -valid=true --quotes "test quotes"', 
    'node', 
    'testing.js'
);

cli.parse(args);
console.log(args);
/** output
[ 'node',
  'testing.js',
  '-testing',
  'test',
  '-valid=true',
  '--quotes',
  'test quotes' ]
  **/
```

##params

__required__: __arguments__ String: arguments that you would normally pass to the command line.

__optional__: __environment__ String: Adds to the environment position in the argv array. If ommitted then there is no need to call argv.split(2) to remove the environment/file values. However if your cli.parse method expects a valid argv value then you should include this value.

__optional__: __file__ String: file that called the arguments. If omitted then there is no need to call argv.split(2) to remove the environment/file values. However if your cli.parse method expects a valid argv value then you should include this value.