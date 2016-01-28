'use strict';

module.exports.parseArgsStringToArgv = parseArgsStringToArgv;

function parseArgsStringToArgv(value, env, file) {
    //[^\s'"] Match if not a space ' or "
    //+|['"] or Match ' or "
    //([^'"]*) Match anything that is not ' or "
    //['"] Close match if ' or "
    var myRegexp = /[^\s'"]+|['"]([^'"]*)['"]/gi;
    var myString = value;
    var myArray = [
    ];
    if(env){
        myArray.push(env);
    }
    if(file){
        myArray.push(file);
    }
    var match;
    do {
        //Each call to exec returns the next regex match as an array
        match = myRegexp.exec(myString);
        if (match !== null) {
            //Index 1 in the array is the captured group if it exists
            //Index 0 is the matched text, which we use if no captured group exists
            myArray.push(match[1] ? match[1] : match[0]);
        }
    } while (match !== null);

    return myArray;
}