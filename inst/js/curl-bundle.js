(function e(t,n,r){function s(o,u){if(!n[o]){if(!t[o]){var a=typeof require=="function"&&require;if(!u&&a)return a(o,!0);if(i)return i(o,!0);var f=new Error("Cannot find module '"+o+"'");throw f.code="MODULE_NOT_FOUND",f}var l=n[o]={exports:{}};t[o][0].call(l.exports,function(e){var n=t[o][1][e];return s(n?n:e)},l,l.exports,e,t,n,r)}return n[o].exports}var i=typeof require=="function"&&require;for(var o=0;o<r.length;o++)s(r[o]);return s})({1:[function(require,module,exports){
(function (global){
global.curlconverter = require('curlconverter')

}).call(this,typeof global !== "undefined" ? global : typeof self !== "undefined" ? self : typeof window !== "undefined" ? window : {})
},{"curlconverter":6}],2:[function(require,module,exports){
/*!
 * cookie
 * Copyright(c) 2012-2014 Roman Shtylman
 * Copyright(c) 2015 Douglas Christopher Wilson
 * MIT Licensed
 */

/**
 * Module exports.
 * @public
 */

exports.parse = parse;
exports.serialize = serialize;

/**
 * Module variables.
 * @private
 */

var decode = decodeURIComponent;
var encode = encodeURIComponent;

/**
 * RegExp to match field-content in RFC 7230 sec 3.2
 *
 * field-content = field-vchar [ 1*( SP / HTAB ) field-vchar ]
 * field-vchar   = VCHAR / obs-text
 * obs-text      = %x80-FF
 */

var fieldContentRegExp = /^[\u0009\u0020-\u007e\u0080-\u00ff]+$/;

/**
 * Parse a cookie header.
 *
 * Parse the given cookie header string into an object
 * The object has the various cookies as keys(names) => values
 *
 * @param {string} str
 * @param {object} [options]
 * @return {object}
 * @public
 */

function parse(str, options) {
  if (typeof str !== 'string') {
    throw new TypeError('argument str must be a string');
  }

  var obj = {}
  var opt = options || {};
  var pairs = str.split(/; */);
  var dec = opt.decode || decode;

  pairs.forEach(function(pair) {
    var eq_idx = pair.indexOf('=')

    // skip things that don't look like key=value
    if (eq_idx < 0) {
      return;
    }

    var key = pair.substr(0, eq_idx).trim()
    var val = pair.substr(++eq_idx, pair.length).trim();

    // quoted values
    if ('"' == val[0]) {
      val = val.slice(1, -1);
    }

    // only assign once
    if (undefined == obj[key]) {
      obj[key] = tryDecode(val, dec);
    }
  });

  return obj;
}

/**
 * Serialize data into a cookie header.
 *
 * Serialize the a name value pair into a cookie string suitable for
 * http headers. An optional options object specified cookie parameters.
 *
 * serialize('foo', 'bar', { httpOnly: true })
 *   => "foo=bar; httpOnly"
 *
 * @param {string} name
 * @param {string} val
 * @param {object} [options]
 * @return {string}
 * @public
 */

function serialize(name, val, options) {
  var opt = options || {};
  var enc = opt.encode || encode;

  if (!fieldContentRegExp.test(name)) {
    throw new TypeError('argument name is invalid');
  }

  var value = enc(val);

  if (value && !fieldContentRegExp.test(value)) {
    throw new TypeError('argument val is invalid');
  }

  var pairs = [name + '=' + value];

  if (null != opt.maxAge) {
    var maxAge = opt.maxAge - 0;
    if (isNaN(maxAge)) throw new Error('maxAge should be a Number');
    pairs.push('Max-Age=' + maxAge);
  }

  if (opt.domain) {
    if (!fieldContentRegExp.test(opt.domain)) {
      throw new TypeError('option domain is invalid');
    }

    pairs.push('Domain=' + opt.domain);
  }

  if (opt.path) {
    if (!fieldContentRegExp.test(opt.path)) {
      throw new TypeError('option path is invalid');
    }

    pairs.push('Path=' + opt.path);
  }

  if (opt.expires) pairs.push('Expires=' + opt.expires.toUTCString());
  if (opt.httpOnly) pairs.push('HttpOnly');
  if (opt.secure) pairs.push('Secure');

  return pairs.join('; ');
}

/**
 * Try decoding a string using a decoding function.
 *
 * @param {string} str
 * @param {function} decode
 * @private
 */

function tryDecode(str, decode) {
  try {
    return decode(str);
  } catch (e) {
    return str;
  }
}

},{}],3:[function(require,module,exports){
var util = require('../util');

var serializeCookies = function(cookieDict) {
    var cookieString = '';
    var i = 0;
    var cookieCount = Object.keys(cookieDict).length;
    for (var cookieName in cookieDict) {
        var cookieValue = cookieDict[cookieName];
        cookieString += cookieName + '=' + cookieValue;
        if (i < cookieCount - 1) {
            cookieString += '; ';
        }
        i++;
    }
    return cookieString;
};
var toNode = function(curlCommand) {
    var request = util.parseCurlCommand(curlCommand);
    var nodeCode = 'var request = require(\'request\');\n\n';
    if (request.headers || request.cookies) {
        nodeCode += 'var headers = {\n';
        var headerCount = Object.keys(request.headers).length;
        var i = 0;
        for (var headerName in request.headers) {
            nodeCode += '    \'' + headerName + '\': \'' + request.headers[headerName] + '\'';
            if (i < headerCount - 1 || request.cookies) {
                nodeCode += ',\n';
            } else {
                nodeCode += '\n';
            }
            i++;
        }
        if (request.cookies) {
            var cookieString = serializeCookies(request.cookies);
            nodeCode += '    \'Cookie\': \'' + cookieString + '\'\n';
        }
        nodeCode += '};\n\n';
    }

    if (request.data) {
        nodeCode += 'var dataString = \'' + request.data + '\';\n\n';
    }

    nodeCode += 'var options = {\n';
    nodeCode += '    url: \'' + request.url + '\'';
    if (request.method !== 'get') {
        nodeCode += ',\n    method: \'' + request.method.toUpperCase() + '\'';
    }

    if (request.headers || request.cookies) {
        nodeCode += ',\n';
        nodeCode += '    headers: headers';
    }
    if (request.data) {
        nodeCode += ',\n    body: dataString\n';
    } else {
        nodeCode += '\n';
    }
    nodeCode += '};\n\n';

    nodeCode += 'function callback(error, response, body) {\n';
    nodeCode += '    if (!error && response.statusCode == 200) {\n';
    nodeCode += '        console.log(body);\n';
    nodeCode += '    }\n';
    nodeCode += '}\n\n';
    nodeCode += 'request(options, callback);';

    return nodeCode;
};

module.exports = toNode;

},{"../util":7}],4:[function(require,module,exports){
var util = require('../util');

var toPython = function(curlCommand) {

    var request = util.parseCurlCommand(curlCommand);
    var cookieDict;
    if (request.cookies) {
        cookieDict = 'cookies = {\n';
        for (var cookieName in request.cookies) {
            cookieDict += "    '" + cookieName + "': '" + request.cookies[cookieName] + "',\n";
        }
        cookieDict += '}\n';
    }
    var headerDict;
    if (request.headers) {
        headerDict = 'headers = {\n';
        for (var headerName in request.headers) {
            headerDict += "    '" + headerName + "': '" + request.headers[headerName] + "',\n";
        }
        headerDict += '}\n';
    }

    var dataString;
    if (request.data) {
        dataString = 'data = \'' + request.data + '\'\n';
    }
    var requestLine = 'requests.' + request.method + '(\'' + request.url + '\'';
    if (request.headers) {
        requestLine += ', headers=headers';
    }
    if (request.cookies) {
        requestLine += ', cookies=cookies';
    }
    if (request.data) {
        requestLine += ', data=data';
    }
    requestLine += ')';

    var pythonCode = '';
    if (cookieDict) {
        pythonCode += cookieDict + '\n';
    }
    if (headerDict) {
        pythonCode += headerDict + '\n';
    }
    if (dataString) {
        pythonCode += dataString + '\n';
    }
    pythonCode += requestLine;

    return pythonCode;
};

module.exports = toPython;
},{"../util":7}],5:[function(require,module,exports){
var util = require('../util');

var toR = function(curlCommand) {

    var request = util.parseCurlCommand(curlCommand);

    // var cookieDict = null;
    // if (request.cookies) {
    //     cookieDict = '"cookies" : {\n';
    //     for (var cookieName in request.cookies) {
    //         cookieDict += "    '" + cookieName + "': '" + request.cookies[cookieName] + "',\n";
    //     }
    //     cookieDict += '}\n';
    // }

    // var headerDict = null;
    // if (request.headers) {
    //     headerDict = '"headers" : {\n';
    //     for (var headerName in request.headers) {
    //         headerDict += "    '" + headerName + "': '" + request.headers[headerName] + "',\n";
    //     }
    //     headerDict += '}\n';
    // }

    // var dataString = null;
    // if (request.data) {
    //     dataString = '"data" : \'' + request.data + '\'\n';
    // }

    return( request );
};

module.exports = toR;

},{"../util":7}],6:[function(require,module,exports){
'use strict';

var toPython = require('./generators/python.js');
var toNode = require('./generators/node.js');
var toR = require('./generators/r.js');

module.exports = {
  toPython: toPython,
  toNode: toNode,
  toR: toR
};
},{"./generators/node.js":3,"./generators/python.js":4,"./generators/r.js":5}],7:[function(require,module,exports){
var cookie = require('cookie');
var stringArgv = require('string-argv');
var parseArgs = require('minimist');

var parseCurlCommand = function(curlCommand) {
    var argumentArray = stringArgv.parseArgsStringToArgv(curlCommand);
    var parsedArguments = parseArgs(argumentArray);

    // minimist fails to parse double quoted json properly
    // hack around that
    if (parsedArguments['data-binary']) {
        var re = /--data-binary '([{}A-z0-9"\s:]+)'/;
        var groups = re.exec(curlCommand);
        if (groups) {
            parsedArguments['data-binary'] = groups[1];
        }
    }

    var cookieString;
    var cookies;
    var url = parsedArguments._[1];
    var headers = null;
    if (parsedArguments.H) {
      if (headers === null) { headers = {} ; }
        if (typeof(parsedArguments.H) === 'string') {
          parsedArguments.H = [ parsedArguments.H ];
        }
        parsedArguments.H.forEach(function (header) {
            if (header.indexOf('Cookie') !== -1) {
                cookieString = header;
            } else {
                var colonIndex = header.indexOf(':');
                var headerName = header.substring(0, colonIndex);
                var headerValue = header.substring(colonIndex + 1).trim();
                headers[headerName] = headerValue;
            }
        });
    }

    if (parsedArguments.header) {
        if (headers === null) { headers = {} ; }
        if (typeof(parsedArguments.header) === 'string') {
          parsedArguments.header = [ parsedArguments.header ];
        }
        parsedArguments.header.forEach(function (header) {
            if (header.indexOf('Cookie') !== -1) {
                cookieString = header;
            } else {
                var colonIndex = header.indexOf(':');
                var headerName = header.substring(0, colonIndex);
                var headerValue = header.substring(colonIndex + 1).trim();
                headers[headerName] = headerValue;
            }
        });
    }
    if (cookieString) {
        var cookieParseOptions = {
            decode: function(s) {return s;}
        };
        cookies = cookie.parse(cookieString.replace('Cookie: ', ''), cookieParseOptions);
    }
    var method;
    if (parsedArguments.X === 'POST') {
        method = 'post';
    } else if (parsedArguments.data || parsedArguments['data-binary']) {
        method = 'post';
    } else {
        method = 'get';
    }
    var request = {
        url: url,
        method: method
    };
    if (headers) {
        request.headers = headers;
    }
    if (cookies) {
        request.cookies = cookies;
    }
    if (parsedArguments.data) {
        request.data = parsedArguments.data;
    } else if (parsedArguments['data-binary']) {
        request.data = parsedArguments['data-binary'];
    }
    return request;
};

module.exports = {
    parseCurlCommand: parseCurlCommand
};

},{"cookie":2,"minimist":8,"string-argv":9}],8:[function(require,module,exports){
module.exports = function (args, opts) {
    if (!opts) opts = {};
    
    var flags = { bools : {}, strings : {}, unknownFn: null };

    if (typeof opts['unknown'] === 'function') {
        flags.unknownFn = opts['unknown'];
    }

    if (typeof opts['boolean'] === 'boolean' && opts['boolean']) {
      flags.allBools = true;
    } else {
      [].concat(opts['boolean']).filter(Boolean).forEach(function (key) {
          flags.bools[key] = true;
      });
    }
    
    var aliases = {};
    Object.keys(opts.alias || {}).forEach(function (key) {
        aliases[key] = [].concat(opts.alias[key]);
        aliases[key].forEach(function (x) {
            aliases[x] = [key].concat(aliases[key].filter(function (y) {
                return x !== y;
            }));
        });
    });

    [].concat(opts.string).filter(Boolean).forEach(function (key) {
        flags.strings[key] = true;
        if (aliases[key]) {
            flags.strings[aliases[key]] = true;
        }
     });

    var defaults = opts['default'] || {};
    
    var argv = { _ : [] };
    Object.keys(flags.bools).forEach(function (key) {
        setArg(key, defaults[key] === undefined ? false : defaults[key]);
    });
    
    var notFlags = [];

    if (args.indexOf('--') !== -1) {
        notFlags = args.slice(args.indexOf('--')+1);
        args = args.slice(0, args.indexOf('--'));
    }

    function argDefined(key, arg) {
        return (flags.allBools && /^--[^=]+$/.test(arg)) ||
            flags.strings[key] || flags.bools[key] || aliases[key];
    }

    function setArg (key, val, arg) {
        if (arg && flags.unknownFn && !argDefined(key, arg)) {
            if (flags.unknownFn(arg) === false) return;
        }

        var value = !flags.strings[key] && isNumber(val)
            ? Number(val) : val
        ;
        setKey(argv, key.split('.'), value);
        
        (aliases[key] || []).forEach(function (x) {
            setKey(argv, x.split('.'), value);
        });
    }

    function setKey (obj, keys, value) {
        var o = obj;
        keys.slice(0,-1).forEach(function (key) {
            if (o[key] === undefined) o[key] = {};
            o = o[key];
        });

        var key = keys[keys.length - 1];
        if (o[key] === undefined || flags.bools[key] || typeof o[key] === 'boolean') {
            o[key] = value;
        }
        else if (Array.isArray(o[key])) {
            o[key].push(value);
        }
        else {
            o[key] = [ o[key], value ];
        }
    }
    
    function aliasIsBoolean(key) {
      return aliases[key].some(function (x) {
          return flags.bools[x];
      });
    }

    for (var i = 0; i < args.length; i++) {
        var arg = args[i];
        
        if (/^--.+=/.test(arg)) {
            // Using [\s\S] instead of . because js doesn't support the
            // 'dotall' regex modifier. See:
            // http://stackoverflow.com/a/1068308/13216
            var m = arg.match(/^--([^=]+)=([\s\S]*)$/);
            var key = m[1];
            var value = m[2];
            if (flags.bools[key]) {
                value = value !== 'false';
            }
            setArg(key, value, arg);
        }
        else if (/^--no-.+/.test(arg)) {
            var key = arg.match(/^--no-(.+)/)[1];
            setArg(key, false, arg);
        }
        else if (/^--.+/.test(arg)) {
            var key = arg.match(/^--(.+)/)[1];
            var next = args[i + 1];
            if (next !== undefined && !/^-/.test(next)
            && !flags.bools[key]
            && !flags.allBools
            && (aliases[key] ? !aliasIsBoolean(key) : true)) {
                setArg(key, next, arg);
                i++;
            }
            else if (/^(true|false)$/.test(next)) {
                setArg(key, next === 'true', arg);
                i++;
            }
            else {
                setArg(key, flags.strings[key] ? '' : true, arg);
            }
        }
        else if (/^-[^-]+/.test(arg)) {
            var letters = arg.slice(1,-1).split('');
            
            var broken = false;
            for (var j = 0; j < letters.length; j++) {
                var next = arg.slice(j+2);
                
                if (next === '-') {
                    setArg(letters[j], next, arg)
                    continue;
                }
                
                if (/[A-Za-z]/.test(letters[j]) && /=/.test(next)) {
                    setArg(letters[j], next.split('=')[1], arg);
                    broken = true;
                    break;
                }
                
                if (/[A-Za-z]/.test(letters[j])
                && /-?\d+(\.\d*)?(e-?\d+)?$/.test(next)) {
                    setArg(letters[j], next, arg);
                    broken = true;
                    break;
                }
                
                if (letters[j+1] && letters[j+1].match(/\W/)) {
                    setArg(letters[j], arg.slice(j+2), arg);
                    broken = true;
                    break;
                }
                else {
                    setArg(letters[j], flags.strings[letters[j]] ? '' : true, arg);
                }
            }
            
            var key = arg.slice(-1)[0];
            if (!broken && key !== '-') {
                if (args[i+1] && !/^(-|--)[^-]/.test(args[i+1])
                && !flags.bools[key]
                && (aliases[key] ? !aliasIsBoolean(key) : true)) {
                    setArg(key, args[i+1], arg);
                    i++;
                }
                else if (args[i+1] && /true|false/.test(args[i+1])) {
                    setArg(key, args[i+1] === 'true', arg);
                    i++;
                }
                else {
                    setArg(key, flags.strings[key] ? '' : true, arg);
                }
            }
        }
        else {
            if (!flags.unknownFn || flags.unknownFn(arg) !== false) {
                argv._.push(
                    flags.strings['_'] || !isNumber(arg) ? arg : Number(arg)
                );
            }
            if (opts.stopEarly) {
                argv._.push.apply(argv._, args.slice(i + 1));
                break;
            }
        }
    }
    
    Object.keys(defaults).forEach(function (key) {
        if (!hasKey(argv, key.split('.'))) {
            setKey(argv, key.split('.'), defaults[key]);
            
            (aliases[key] || []).forEach(function (x) {
                setKey(argv, x.split('.'), defaults[key]);
            });
        }
    });
    
    if (opts['--']) {
        argv['--'] = new Array();
        notFlags.forEach(function(key) {
            argv['--'].push(key);
        });
    }
    else {
        notFlags.forEach(function(key) {
            argv._.push(key);
        });
    }

    return argv;
};

function hasKey (obj, keys) {
    var o = obj;
    keys.slice(0,-1).forEach(function (key) {
        o = (o[key] || {});
    });

    var key = keys[keys.length - 1];
    return key in o;
}

function isNumber (x) {
    if (typeof x === 'number') return true;
    if (/^0x[0-9a-f]+$/i.test(x)) return true;
    return /^[-+]?(?:\d+(?:\.\d*)?|\.\d+)(e[-+]?\d+)?$/.test(x);
}


},{}],9:[function(require,module,exports){
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
},{}]},{},[1]);
