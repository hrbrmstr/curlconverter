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
    var headers;
    if (parsedArguments.H) {
        headers = {};
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
},{}]},{},[1])
//# sourceMappingURL=data:application/json;charset=utf-8;base64,eyJ2ZXJzaW9uIjozLCJzb3VyY2VzIjpbIi4uLy4uLy4uLy4uLy4uLy4uL3Vzci9sb2NhbC9saWIvbm9kZV9tb2R1bGVzL2Jyb3dzZXJpZnkvbm9kZV9tb2R1bGVzL2Jyb3dzZXItcGFjay9fcHJlbHVkZS5qcyIsImluLmpzIiwibm9kZV9tb2R1bGVzL2Nvb2tpZS9pbmRleC5qcyIsIm5vZGVfbW9kdWxlcy9jdXJsY29udmVydGVyL2dlbmVyYXRvcnMvbm9kZS5qcyIsIm5vZGVfbW9kdWxlcy9jdXJsY29udmVydGVyL2dlbmVyYXRvcnMvcHl0aG9uLmpzIiwibm9kZV9tb2R1bGVzL2N1cmxjb252ZXJ0ZXIvZ2VuZXJhdG9ycy9yLmpzIiwibm9kZV9tb2R1bGVzL2N1cmxjb252ZXJ0ZXIvaW5kZXguanMiLCJub2RlX21vZHVsZXMvY3VybGNvbnZlcnRlci91dGlsLmpzIiwibm9kZV9tb2R1bGVzL21pbmltaXN0L2luZGV4LmpzIiwibm9kZV9tb2R1bGVzL3N0cmluZy1hcmd2L2luZGV4LmpzIl0sIm5hbWVzIjpbXSwibWFwcGluZ3MiOiJBQUFBOztBQ0FBO0FBQ0E7Ozs7QUNEQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7QUM1SkE7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBOztBQ3ZFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7O0FDckRBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBOztBQ2pDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBOztBQ1ZBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7O0FDdEVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7QUM1T0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQSIsImZpbGUiOiJnZW5lcmF0ZWQuanMiLCJzb3VyY2VSb290IjoiIiwic291cmNlc0NvbnRlbnQiOlsiKGZ1bmN0aW9uIGUodCxuLHIpe2Z1bmN0aW9uIHMobyx1KXtpZighbltvXSl7aWYoIXRbb10pe3ZhciBhPXR5cGVvZiByZXF1aXJlPT1cImZ1bmN0aW9uXCImJnJlcXVpcmU7aWYoIXUmJmEpcmV0dXJuIGEobywhMCk7aWYoaSlyZXR1cm4gaShvLCEwKTt2YXIgZj1uZXcgRXJyb3IoXCJDYW5ub3QgZmluZCBtb2R1bGUgJ1wiK28rXCInXCIpO3Rocm93IGYuY29kZT1cIk1PRFVMRV9OT1RfRk9VTkRcIixmfXZhciBsPW5bb109e2V4cG9ydHM6e319O3Rbb11bMF0uY2FsbChsLmV4cG9ydHMsZnVuY3Rpb24oZSl7dmFyIG49dFtvXVsxXVtlXTtyZXR1cm4gcyhuP246ZSl9LGwsbC5leHBvcnRzLGUsdCxuLHIpfXJldHVybiBuW29dLmV4cG9ydHN9dmFyIGk9dHlwZW9mIHJlcXVpcmU9PVwiZnVuY3Rpb25cIiYmcmVxdWlyZTtmb3IodmFyIG89MDtvPHIubGVuZ3RoO28rKylzKHJbb10pO3JldHVybiBzfSkiLCJnbG9iYWwuY3VybGNvbnZlcnRlciA9IHJlcXVpcmUoJ2N1cmxjb252ZXJ0ZXInKVxuIiwiLyohXHJcbiAqIGNvb2tpZVxyXG4gKiBDb3B5cmlnaHQoYykgMjAxMi0yMDE0IFJvbWFuIFNodHlsbWFuXHJcbiAqIENvcHlyaWdodChjKSAyMDE1IERvdWdsYXMgQ2hyaXN0b3BoZXIgV2lsc29uXHJcbiAqIE1JVCBMaWNlbnNlZFxyXG4gKi9cclxuXHJcbi8qKlxyXG4gKiBNb2R1bGUgZXhwb3J0cy5cclxuICogQHB1YmxpY1xyXG4gKi9cclxuXHJcbmV4cG9ydHMucGFyc2UgPSBwYXJzZTtcclxuZXhwb3J0cy5zZXJpYWxpemUgPSBzZXJpYWxpemU7XHJcblxyXG4vKipcclxuICogTW9kdWxlIHZhcmlhYmxlcy5cclxuICogQHByaXZhdGVcclxuICovXHJcblxyXG52YXIgZGVjb2RlID0gZGVjb2RlVVJJQ29tcG9uZW50O1xyXG52YXIgZW5jb2RlID0gZW5jb2RlVVJJQ29tcG9uZW50O1xyXG5cclxuLyoqXHJcbiAqIFJlZ0V4cCB0byBtYXRjaCBmaWVsZC1jb250ZW50IGluIFJGQyA3MjMwIHNlYyAzLjJcclxuICpcclxuICogZmllbGQtY29udGVudCA9IGZpZWxkLXZjaGFyIFsgMSooIFNQIC8gSFRBQiApIGZpZWxkLXZjaGFyIF1cclxuICogZmllbGQtdmNoYXIgICA9IFZDSEFSIC8gb2JzLXRleHRcclxuICogb2JzLXRleHQgICAgICA9ICV4ODAtRkZcclxuICovXHJcblxyXG52YXIgZmllbGRDb250ZW50UmVnRXhwID0gL15bXFx1MDAwOVxcdTAwMjAtXFx1MDA3ZVxcdTAwODAtXFx1MDBmZl0rJC87XHJcblxyXG4vKipcclxuICogUGFyc2UgYSBjb29raWUgaGVhZGVyLlxyXG4gKlxyXG4gKiBQYXJzZSB0aGUgZ2l2ZW4gY29va2llIGhlYWRlciBzdHJpbmcgaW50byBhbiBvYmplY3RcclxuICogVGhlIG9iamVjdCBoYXMgdGhlIHZhcmlvdXMgY29va2llcyBhcyBrZXlzKG5hbWVzKSA9PiB2YWx1ZXNcclxuICpcclxuICogQHBhcmFtIHtzdHJpbmd9IHN0clxyXG4gKiBAcGFyYW0ge29iamVjdH0gW29wdGlvbnNdXHJcbiAqIEByZXR1cm4ge29iamVjdH1cclxuICogQHB1YmxpY1xyXG4gKi9cclxuXHJcbmZ1bmN0aW9uIHBhcnNlKHN0ciwgb3B0aW9ucykge1xyXG4gIGlmICh0eXBlb2Ygc3RyICE9PSAnc3RyaW5nJykge1xyXG4gICAgdGhyb3cgbmV3IFR5cGVFcnJvcignYXJndW1lbnQgc3RyIG11c3QgYmUgYSBzdHJpbmcnKTtcclxuICB9XHJcblxyXG4gIHZhciBvYmogPSB7fVxyXG4gIHZhciBvcHQgPSBvcHRpb25zIHx8IHt9O1xyXG4gIHZhciBwYWlycyA9IHN0ci5zcGxpdCgvOyAqLyk7XHJcbiAgdmFyIGRlYyA9IG9wdC5kZWNvZGUgfHwgZGVjb2RlO1xyXG5cclxuICBwYWlycy5mb3JFYWNoKGZ1bmN0aW9uKHBhaXIpIHtcclxuICAgIHZhciBlcV9pZHggPSBwYWlyLmluZGV4T2YoJz0nKVxyXG5cclxuICAgIC8vIHNraXAgdGhpbmdzIHRoYXQgZG9uJ3QgbG9vayBsaWtlIGtleT12YWx1ZVxyXG4gICAgaWYgKGVxX2lkeCA8IDApIHtcclxuICAgICAgcmV0dXJuO1xyXG4gICAgfVxyXG5cclxuICAgIHZhciBrZXkgPSBwYWlyLnN1YnN0cigwLCBlcV9pZHgpLnRyaW0oKVxyXG4gICAgdmFyIHZhbCA9IHBhaXIuc3Vic3RyKCsrZXFfaWR4LCBwYWlyLmxlbmd0aCkudHJpbSgpO1xyXG5cclxuICAgIC8vIHF1b3RlZCB2YWx1ZXNcclxuICAgIGlmICgnXCInID09IHZhbFswXSkge1xyXG4gICAgICB2YWwgPSB2YWwuc2xpY2UoMSwgLTEpO1xyXG4gICAgfVxyXG5cclxuICAgIC8vIG9ubHkgYXNzaWduIG9uY2VcclxuICAgIGlmICh1bmRlZmluZWQgPT0gb2JqW2tleV0pIHtcclxuICAgICAgb2JqW2tleV0gPSB0cnlEZWNvZGUodmFsLCBkZWMpO1xyXG4gICAgfVxyXG4gIH0pO1xyXG5cclxuICByZXR1cm4gb2JqO1xyXG59XHJcblxyXG4vKipcclxuICogU2VyaWFsaXplIGRhdGEgaW50byBhIGNvb2tpZSBoZWFkZXIuXHJcbiAqXHJcbiAqIFNlcmlhbGl6ZSB0aGUgYSBuYW1lIHZhbHVlIHBhaXIgaW50byBhIGNvb2tpZSBzdHJpbmcgc3VpdGFibGUgZm9yXHJcbiAqIGh0dHAgaGVhZGVycy4gQW4gb3B0aW9uYWwgb3B0aW9ucyBvYmplY3Qgc3BlY2lmaWVkIGNvb2tpZSBwYXJhbWV0ZXJzLlxyXG4gKlxyXG4gKiBzZXJpYWxpemUoJ2ZvbycsICdiYXInLCB7IGh0dHBPbmx5OiB0cnVlIH0pXHJcbiAqICAgPT4gXCJmb289YmFyOyBodHRwT25seVwiXHJcbiAqXHJcbiAqIEBwYXJhbSB7c3RyaW5nfSBuYW1lXHJcbiAqIEBwYXJhbSB7c3RyaW5nfSB2YWxcclxuICogQHBhcmFtIHtvYmplY3R9IFtvcHRpb25zXVxyXG4gKiBAcmV0dXJuIHtzdHJpbmd9XHJcbiAqIEBwdWJsaWNcclxuICovXHJcblxyXG5mdW5jdGlvbiBzZXJpYWxpemUobmFtZSwgdmFsLCBvcHRpb25zKSB7XHJcbiAgdmFyIG9wdCA9IG9wdGlvbnMgfHwge307XHJcbiAgdmFyIGVuYyA9IG9wdC5lbmNvZGUgfHwgZW5jb2RlO1xyXG5cclxuICBpZiAoIWZpZWxkQ29udGVudFJlZ0V4cC50ZXN0KG5hbWUpKSB7XHJcbiAgICB0aHJvdyBuZXcgVHlwZUVycm9yKCdhcmd1bWVudCBuYW1lIGlzIGludmFsaWQnKTtcclxuICB9XHJcblxyXG4gIHZhciB2YWx1ZSA9IGVuYyh2YWwpO1xyXG5cclxuICBpZiAodmFsdWUgJiYgIWZpZWxkQ29udGVudFJlZ0V4cC50ZXN0KHZhbHVlKSkge1xyXG4gICAgdGhyb3cgbmV3IFR5cGVFcnJvcignYXJndW1lbnQgdmFsIGlzIGludmFsaWQnKTtcclxuICB9XHJcblxyXG4gIHZhciBwYWlycyA9IFtuYW1lICsgJz0nICsgdmFsdWVdO1xyXG5cclxuICBpZiAobnVsbCAhPSBvcHQubWF4QWdlKSB7XHJcbiAgICB2YXIgbWF4QWdlID0gb3B0Lm1heEFnZSAtIDA7XHJcbiAgICBpZiAoaXNOYU4obWF4QWdlKSkgdGhyb3cgbmV3IEVycm9yKCdtYXhBZ2Ugc2hvdWxkIGJlIGEgTnVtYmVyJyk7XHJcbiAgICBwYWlycy5wdXNoKCdNYXgtQWdlPScgKyBtYXhBZ2UpO1xyXG4gIH1cclxuXHJcbiAgaWYgKG9wdC5kb21haW4pIHtcclxuICAgIGlmICghZmllbGRDb250ZW50UmVnRXhwLnRlc3Qob3B0LmRvbWFpbikpIHtcclxuICAgICAgdGhyb3cgbmV3IFR5cGVFcnJvcignb3B0aW9uIGRvbWFpbiBpcyBpbnZhbGlkJyk7XHJcbiAgICB9XHJcblxyXG4gICAgcGFpcnMucHVzaCgnRG9tYWluPScgKyBvcHQuZG9tYWluKTtcclxuICB9XHJcblxyXG4gIGlmIChvcHQucGF0aCkge1xyXG4gICAgaWYgKCFmaWVsZENvbnRlbnRSZWdFeHAudGVzdChvcHQucGF0aCkpIHtcclxuICAgICAgdGhyb3cgbmV3IFR5cGVFcnJvcignb3B0aW9uIHBhdGggaXMgaW52YWxpZCcpO1xyXG4gICAgfVxyXG5cclxuICAgIHBhaXJzLnB1c2goJ1BhdGg9JyArIG9wdC5wYXRoKTtcclxuICB9XHJcblxyXG4gIGlmIChvcHQuZXhwaXJlcykgcGFpcnMucHVzaCgnRXhwaXJlcz0nICsgb3B0LmV4cGlyZXMudG9VVENTdHJpbmcoKSk7XHJcbiAgaWYgKG9wdC5odHRwT25seSkgcGFpcnMucHVzaCgnSHR0cE9ubHknKTtcclxuICBpZiAob3B0LnNlY3VyZSkgcGFpcnMucHVzaCgnU2VjdXJlJyk7XHJcblxyXG4gIHJldHVybiBwYWlycy5qb2luKCc7ICcpO1xyXG59XHJcblxyXG4vKipcclxuICogVHJ5IGRlY29kaW5nIGEgc3RyaW5nIHVzaW5nIGEgZGVjb2RpbmcgZnVuY3Rpb24uXHJcbiAqXHJcbiAqIEBwYXJhbSB7c3RyaW5nfSBzdHJcclxuICogQHBhcmFtIHtmdW5jdGlvbn0gZGVjb2RlXHJcbiAqIEBwcml2YXRlXHJcbiAqL1xyXG5cclxuZnVuY3Rpb24gdHJ5RGVjb2RlKHN0ciwgZGVjb2RlKSB7XHJcbiAgdHJ5IHtcclxuICAgIHJldHVybiBkZWNvZGUoc3RyKTtcclxuICB9IGNhdGNoIChlKSB7XHJcbiAgICByZXR1cm4gc3RyO1xyXG4gIH1cclxufVxyXG4iLCJ2YXIgdXRpbCA9IHJlcXVpcmUoJy4uL3V0aWwnKTtcblxudmFyIHNlcmlhbGl6ZUNvb2tpZXMgPSBmdW5jdGlvbihjb29raWVEaWN0KSB7XG4gICAgdmFyIGNvb2tpZVN0cmluZyA9ICcnO1xuICAgIHZhciBpID0gMDtcbiAgICB2YXIgY29va2llQ291bnQgPSBPYmplY3Qua2V5cyhjb29raWVEaWN0KS5sZW5ndGg7XG4gICAgZm9yICh2YXIgY29va2llTmFtZSBpbiBjb29raWVEaWN0KSB7XG4gICAgICAgIHZhciBjb29raWVWYWx1ZSA9IGNvb2tpZURpY3RbY29va2llTmFtZV07XG4gICAgICAgIGNvb2tpZVN0cmluZyArPSBjb29raWVOYW1lICsgJz0nICsgY29va2llVmFsdWU7XG4gICAgICAgIGlmIChpIDwgY29va2llQ291bnQgLSAxKSB7XG4gICAgICAgICAgICBjb29raWVTdHJpbmcgKz0gJzsgJztcbiAgICAgICAgfVxuICAgICAgICBpKys7XG4gICAgfVxuICAgIHJldHVybiBjb29raWVTdHJpbmc7XG59O1xudmFyIHRvTm9kZSA9IGZ1bmN0aW9uKGN1cmxDb21tYW5kKSB7XG4gICAgdmFyIHJlcXVlc3QgPSB1dGlsLnBhcnNlQ3VybENvbW1hbmQoY3VybENvbW1hbmQpO1xuICAgIHZhciBub2RlQ29kZSA9ICd2YXIgcmVxdWVzdCA9IHJlcXVpcmUoXFwncmVxdWVzdFxcJyk7XFxuXFxuJztcbiAgICBpZiAocmVxdWVzdC5oZWFkZXJzIHx8IHJlcXVlc3QuY29va2llcykge1xuICAgICAgICBub2RlQ29kZSArPSAndmFyIGhlYWRlcnMgPSB7XFxuJztcbiAgICAgICAgdmFyIGhlYWRlckNvdW50ID0gT2JqZWN0LmtleXMocmVxdWVzdC5oZWFkZXJzKS5sZW5ndGg7XG4gICAgICAgIHZhciBpID0gMDtcbiAgICAgICAgZm9yICh2YXIgaGVhZGVyTmFtZSBpbiByZXF1ZXN0LmhlYWRlcnMpIHtcbiAgICAgICAgICAgIG5vZGVDb2RlICs9ICcgICAgXFwnJyArIGhlYWRlck5hbWUgKyAnXFwnOiBcXCcnICsgcmVxdWVzdC5oZWFkZXJzW2hlYWRlck5hbWVdICsgJ1xcJyc7XG4gICAgICAgICAgICBpZiAoaSA8IGhlYWRlckNvdW50IC0gMSB8fCByZXF1ZXN0LmNvb2tpZXMpIHtcbiAgICAgICAgICAgICAgICBub2RlQ29kZSArPSAnLFxcbic7XG4gICAgICAgICAgICB9IGVsc2Uge1xuICAgICAgICAgICAgICAgIG5vZGVDb2RlICs9ICdcXG4nO1xuICAgICAgICAgICAgfVxuICAgICAgICAgICAgaSsrO1xuICAgICAgICB9XG4gICAgICAgIGlmIChyZXF1ZXN0LmNvb2tpZXMpIHtcbiAgICAgICAgICAgIHZhciBjb29raWVTdHJpbmcgPSBzZXJpYWxpemVDb29raWVzKHJlcXVlc3QuY29va2llcyk7XG4gICAgICAgICAgICBub2RlQ29kZSArPSAnICAgIFxcJ0Nvb2tpZVxcJzogXFwnJyArIGNvb2tpZVN0cmluZyArICdcXCdcXG4nO1xuICAgICAgICB9XG4gICAgICAgIG5vZGVDb2RlICs9ICd9O1xcblxcbic7XG4gICAgfVxuXG4gICAgaWYgKHJlcXVlc3QuZGF0YSkge1xuICAgICAgICBub2RlQ29kZSArPSAndmFyIGRhdGFTdHJpbmcgPSBcXCcnICsgcmVxdWVzdC5kYXRhICsgJ1xcJztcXG5cXG4nO1xuICAgIH1cblxuICAgIG5vZGVDb2RlICs9ICd2YXIgb3B0aW9ucyA9IHtcXG4nO1xuICAgIG5vZGVDb2RlICs9ICcgICAgdXJsOiBcXCcnICsgcmVxdWVzdC51cmwgKyAnXFwnJztcbiAgICBpZiAocmVxdWVzdC5tZXRob2QgIT09ICdnZXQnKSB7XG4gICAgICAgIG5vZGVDb2RlICs9ICcsXFxuICAgIG1ldGhvZDogXFwnJyArIHJlcXVlc3QubWV0aG9kLnRvVXBwZXJDYXNlKCkgKyAnXFwnJztcbiAgICB9XG5cbiAgICBpZiAocmVxdWVzdC5oZWFkZXJzIHx8IHJlcXVlc3QuY29va2llcykge1xuICAgICAgICBub2RlQ29kZSArPSAnLFxcbic7XG4gICAgICAgIG5vZGVDb2RlICs9ICcgICAgaGVhZGVyczogaGVhZGVycyc7XG4gICAgfVxuICAgIGlmIChyZXF1ZXN0LmRhdGEpIHtcbiAgICAgICAgbm9kZUNvZGUgKz0gJyxcXG4gICAgYm9keTogZGF0YVN0cmluZ1xcbic7XG4gICAgfSBlbHNlIHtcbiAgICAgICAgbm9kZUNvZGUgKz0gJ1xcbic7XG4gICAgfVxuICAgIG5vZGVDb2RlICs9ICd9O1xcblxcbic7XG5cbiAgICBub2RlQ29kZSArPSAnZnVuY3Rpb24gY2FsbGJhY2soZXJyb3IsIHJlc3BvbnNlLCBib2R5KSB7XFxuJztcbiAgICBub2RlQ29kZSArPSAnICAgIGlmICghZXJyb3IgJiYgcmVzcG9uc2Uuc3RhdHVzQ29kZSA9PSAyMDApIHtcXG4nO1xuICAgIG5vZGVDb2RlICs9ICcgICAgICAgIGNvbnNvbGUubG9nKGJvZHkpO1xcbic7XG4gICAgbm9kZUNvZGUgKz0gJyAgICB9XFxuJztcbiAgICBub2RlQ29kZSArPSAnfVxcblxcbic7XG4gICAgbm9kZUNvZGUgKz0gJ3JlcXVlc3Qob3B0aW9ucywgY2FsbGJhY2spOyc7XG5cbiAgICByZXR1cm4gbm9kZUNvZGU7XG59O1xuXG5tb2R1bGUuZXhwb3J0cyA9IHRvTm9kZTtcbiIsInZhciB1dGlsID0gcmVxdWlyZSgnLi4vdXRpbCcpO1xuXG52YXIgdG9QeXRob24gPSBmdW5jdGlvbihjdXJsQ29tbWFuZCkge1xuXG4gICAgdmFyIHJlcXVlc3QgPSB1dGlsLnBhcnNlQ3VybENvbW1hbmQoY3VybENvbW1hbmQpO1xuICAgIHZhciBjb29raWVEaWN0O1xuICAgIGlmIChyZXF1ZXN0LmNvb2tpZXMpIHtcbiAgICAgICAgY29va2llRGljdCA9ICdjb29raWVzID0ge1xcbic7XG4gICAgICAgIGZvciAodmFyIGNvb2tpZU5hbWUgaW4gcmVxdWVzdC5jb29raWVzKSB7XG4gICAgICAgICAgICBjb29raWVEaWN0ICs9IFwiICAgICdcIiArIGNvb2tpZU5hbWUgKyBcIic6ICdcIiArIHJlcXVlc3QuY29va2llc1tjb29raWVOYW1lXSArIFwiJyxcXG5cIjtcbiAgICAgICAgfVxuICAgICAgICBjb29raWVEaWN0ICs9ICd9XFxuJztcbiAgICB9XG4gICAgdmFyIGhlYWRlckRpY3Q7XG4gICAgaWYgKHJlcXVlc3QuaGVhZGVycykge1xuICAgICAgICBoZWFkZXJEaWN0ID0gJ2hlYWRlcnMgPSB7XFxuJztcbiAgICAgICAgZm9yICh2YXIgaGVhZGVyTmFtZSBpbiByZXF1ZXN0LmhlYWRlcnMpIHtcbiAgICAgICAgICAgIGhlYWRlckRpY3QgKz0gXCIgICAgJ1wiICsgaGVhZGVyTmFtZSArIFwiJzogJ1wiICsgcmVxdWVzdC5oZWFkZXJzW2hlYWRlck5hbWVdICsgXCInLFxcblwiO1xuICAgICAgICB9XG4gICAgICAgIGhlYWRlckRpY3QgKz0gJ31cXG4nO1xuICAgIH1cblxuICAgIHZhciBkYXRhU3RyaW5nO1xuICAgIGlmIChyZXF1ZXN0LmRhdGEpIHtcbiAgICAgICAgZGF0YVN0cmluZyA9ICdkYXRhID0gXFwnJyArIHJlcXVlc3QuZGF0YSArICdcXCdcXG4nO1xuICAgIH1cbiAgICB2YXIgcmVxdWVzdExpbmUgPSAncmVxdWVzdHMuJyArIHJlcXVlc3QubWV0aG9kICsgJyhcXCcnICsgcmVxdWVzdC51cmwgKyAnXFwnJztcbiAgICBpZiAocmVxdWVzdC5oZWFkZXJzKSB7XG4gICAgICAgIHJlcXVlc3RMaW5lICs9ICcsIGhlYWRlcnM9aGVhZGVycyc7XG4gICAgfVxuICAgIGlmIChyZXF1ZXN0LmNvb2tpZXMpIHtcbiAgICAgICAgcmVxdWVzdExpbmUgKz0gJywgY29va2llcz1jb29raWVzJztcbiAgICB9XG4gICAgaWYgKHJlcXVlc3QuZGF0YSkge1xuICAgICAgICByZXF1ZXN0TGluZSArPSAnLCBkYXRhPWRhdGEnO1xuICAgIH1cbiAgICByZXF1ZXN0TGluZSArPSAnKSc7XG5cbiAgICB2YXIgcHl0aG9uQ29kZSA9ICcnO1xuICAgIGlmIChjb29raWVEaWN0KSB7XG4gICAgICAgIHB5dGhvbkNvZGUgKz0gY29va2llRGljdCArICdcXG4nO1xuICAgIH1cbiAgICBpZiAoaGVhZGVyRGljdCkge1xuICAgICAgICBweXRob25Db2RlICs9IGhlYWRlckRpY3QgKyAnXFxuJztcbiAgICB9XG4gICAgaWYgKGRhdGFTdHJpbmcpIHtcbiAgICAgICAgcHl0aG9uQ29kZSArPSBkYXRhU3RyaW5nICsgJ1xcbic7XG4gICAgfVxuICAgIHB5dGhvbkNvZGUgKz0gcmVxdWVzdExpbmU7XG5cbiAgICByZXR1cm4gcHl0aG9uQ29kZTtcbn07XG5cbm1vZHVsZS5leHBvcnRzID0gdG9QeXRob247IiwidmFyIHV0aWwgPSByZXF1aXJlKCcuLi91dGlsJyk7XG5cbnZhciB0b1IgPSBmdW5jdGlvbihjdXJsQ29tbWFuZCkge1xuXG4gICAgdmFyIHJlcXVlc3QgPSB1dGlsLnBhcnNlQ3VybENvbW1hbmQoY3VybENvbW1hbmQpO1xuXG4gICAgLy8gdmFyIGNvb2tpZURpY3QgPSBudWxsO1xuICAgIC8vIGlmIChyZXF1ZXN0LmNvb2tpZXMpIHtcbiAgICAvLyAgICAgY29va2llRGljdCA9ICdcImNvb2tpZXNcIiA6IHtcXG4nO1xuICAgIC8vICAgICBmb3IgKHZhciBjb29raWVOYW1lIGluIHJlcXVlc3QuY29va2llcykge1xuICAgIC8vICAgICAgICAgY29va2llRGljdCArPSBcIiAgICAnXCIgKyBjb29raWVOYW1lICsgXCInOiAnXCIgKyByZXF1ZXN0LmNvb2tpZXNbY29va2llTmFtZV0gKyBcIicsXFxuXCI7XG4gICAgLy8gICAgIH1cbiAgICAvLyAgICAgY29va2llRGljdCArPSAnfVxcbic7XG4gICAgLy8gfVxuXG4gICAgLy8gdmFyIGhlYWRlckRpY3QgPSBudWxsO1xuICAgIC8vIGlmIChyZXF1ZXN0LmhlYWRlcnMpIHtcbiAgICAvLyAgICAgaGVhZGVyRGljdCA9ICdcImhlYWRlcnNcIiA6IHtcXG4nO1xuICAgIC8vICAgICBmb3IgKHZhciBoZWFkZXJOYW1lIGluIHJlcXVlc3QuaGVhZGVycykge1xuICAgIC8vICAgICAgICAgaGVhZGVyRGljdCArPSBcIiAgICAnXCIgKyBoZWFkZXJOYW1lICsgXCInOiAnXCIgKyByZXF1ZXN0LmhlYWRlcnNbaGVhZGVyTmFtZV0gKyBcIicsXFxuXCI7XG4gICAgLy8gICAgIH1cbiAgICAvLyAgICAgaGVhZGVyRGljdCArPSAnfVxcbic7XG4gICAgLy8gfVxuXG4gICAgLy8gdmFyIGRhdGFTdHJpbmcgPSBudWxsO1xuICAgIC8vIGlmIChyZXF1ZXN0LmRhdGEpIHtcbiAgICAvLyAgICAgZGF0YVN0cmluZyA9ICdcImRhdGFcIiA6IFxcJycgKyByZXF1ZXN0LmRhdGEgKyAnXFwnXFxuJztcbiAgICAvLyB9XG5cbiAgICByZXR1cm4oIHJlcXVlc3QgKTtcbn07XG5cbm1vZHVsZS5leHBvcnRzID0gdG9SO1xuIiwiJ3VzZSBzdHJpY3QnO1xuXG52YXIgdG9QeXRob24gPSByZXF1aXJlKCcuL2dlbmVyYXRvcnMvcHl0aG9uLmpzJyk7XG52YXIgdG9Ob2RlID0gcmVxdWlyZSgnLi9nZW5lcmF0b3JzL25vZGUuanMnKTtcbnZhciB0b1IgPSByZXF1aXJlKCcuL2dlbmVyYXRvcnMvci5qcycpO1xuXG5tb2R1bGUuZXhwb3J0cyA9IHtcbiAgdG9QeXRob246IHRvUHl0aG9uLFxuICB0b05vZGU6IHRvTm9kZSxcbiAgdG9SOiB0b1Jcbn07IiwidmFyIGNvb2tpZSA9IHJlcXVpcmUoJ2Nvb2tpZScpO1xudmFyIHN0cmluZ0FyZ3YgPSByZXF1aXJlKCdzdHJpbmctYXJndicpO1xudmFyIHBhcnNlQXJncyA9IHJlcXVpcmUoJ21pbmltaXN0Jyk7XG5cbnZhciBwYXJzZUN1cmxDb21tYW5kID0gZnVuY3Rpb24oY3VybENvbW1hbmQpIHtcbiAgICB2YXIgYXJndW1lbnRBcnJheSA9IHN0cmluZ0FyZ3YucGFyc2VBcmdzU3RyaW5nVG9Bcmd2KGN1cmxDb21tYW5kKTtcbiAgICB2YXIgcGFyc2VkQXJndW1lbnRzID0gcGFyc2VBcmdzKGFyZ3VtZW50QXJyYXkpO1xuXG4gICAgLy8gbWluaW1pc3QgZmFpbHMgdG8gcGFyc2UgZG91YmxlIHF1b3RlZCBqc29uIHByb3Blcmx5XG4gICAgLy8gaGFjayBhcm91bmQgdGhhdFxuICAgIGlmIChwYXJzZWRBcmd1bWVudHNbJ2RhdGEtYmluYXJ5J10pIHtcbiAgICAgICAgdmFyIHJlID0gLy0tZGF0YS1iaW5hcnkgJyhbe31BLXowLTlcIlxcczpdKyknLztcbiAgICAgICAgdmFyIGdyb3VwcyA9IHJlLmV4ZWMoY3VybENvbW1hbmQpO1xuICAgICAgICBpZiAoZ3JvdXBzKSB7XG4gICAgICAgICAgICBwYXJzZWRBcmd1bWVudHNbJ2RhdGEtYmluYXJ5J10gPSBncm91cHNbMV07XG4gICAgICAgIH1cbiAgICB9XG5cbiAgICB2YXIgY29va2llU3RyaW5nO1xuICAgIHZhciBjb29raWVzO1xuICAgIHZhciB1cmwgPSBwYXJzZWRBcmd1bWVudHMuX1sxXTtcbiAgICB2YXIgaGVhZGVycztcbiAgICBpZiAocGFyc2VkQXJndW1lbnRzLkgpIHtcbiAgICAgICAgaGVhZGVycyA9IHt9O1xuICAgICAgICBwYXJzZWRBcmd1bWVudHMuSC5mb3JFYWNoKGZ1bmN0aW9uIChoZWFkZXIpIHtcbiAgICAgICAgICAgIGlmIChoZWFkZXIuaW5kZXhPZignQ29va2llJykgIT09IC0xKSB7XG4gICAgICAgICAgICAgICAgY29va2llU3RyaW5nID0gaGVhZGVyO1xuICAgICAgICAgICAgfSBlbHNlIHtcbiAgICAgICAgICAgICAgICB2YXIgY29sb25JbmRleCA9IGhlYWRlci5pbmRleE9mKCc6Jyk7XG4gICAgICAgICAgICAgICAgdmFyIGhlYWRlck5hbWUgPSBoZWFkZXIuc3Vic3RyaW5nKDAsIGNvbG9uSW5kZXgpO1xuICAgICAgICAgICAgICAgIHZhciBoZWFkZXJWYWx1ZSA9IGhlYWRlci5zdWJzdHJpbmcoY29sb25JbmRleCArIDEpLnRyaW0oKTtcbiAgICAgICAgICAgICAgICBoZWFkZXJzW2hlYWRlck5hbWVdID0gaGVhZGVyVmFsdWU7XG4gICAgICAgICAgICB9XG4gICAgICAgIH0pO1xuICAgIH1cbiAgICBpZiAoY29va2llU3RyaW5nKSB7XG4gICAgICAgIHZhciBjb29raWVQYXJzZU9wdGlvbnMgPSB7XG4gICAgICAgICAgICBkZWNvZGU6IGZ1bmN0aW9uKHMpIHtyZXR1cm4gczt9XG4gICAgICAgIH07XG4gICAgICAgIGNvb2tpZXMgPSBjb29raWUucGFyc2UoY29va2llU3RyaW5nLnJlcGxhY2UoJ0Nvb2tpZTogJywgJycpLCBjb29raWVQYXJzZU9wdGlvbnMpO1xuICAgIH1cbiAgICB2YXIgbWV0aG9kO1xuICAgIGlmIChwYXJzZWRBcmd1bWVudHMuWCA9PT0gJ1BPU1QnKSB7XG4gICAgICAgIG1ldGhvZCA9ICdwb3N0JztcbiAgICB9IGVsc2UgaWYgKHBhcnNlZEFyZ3VtZW50cy5kYXRhIHx8IHBhcnNlZEFyZ3VtZW50c1snZGF0YS1iaW5hcnknXSkge1xuICAgICAgICBtZXRob2QgPSAncG9zdCc7XG4gICAgfSBlbHNlIHtcbiAgICAgICAgbWV0aG9kID0gJ2dldCc7XG4gICAgfVxuICAgIHZhciByZXF1ZXN0ID0ge1xuICAgICAgICB1cmw6IHVybCxcbiAgICAgICAgbWV0aG9kOiBtZXRob2RcbiAgICB9O1xuICAgIGlmIChoZWFkZXJzKSB7XG4gICAgICAgIHJlcXVlc3QuaGVhZGVycyA9IGhlYWRlcnM7XG4gICAgfVxuICAgIGlmIChjb29raWVzKSB7XG4gICAgICAgIHJlcXVlc3QuY29va2llcyA9IGNvb2tpZXM7XG4gICAgfVxuICAgIGlmIChwYXJzZWRBcmd1bWVudHMuZGF0YSkge1xuICAgICAgICByZXF1ZXN0LmRhdGEgPSBwYXJzZWRBcmd1bWVudHMuZGF0YTtcbiAgICB9IGVsc2UgaWYgKHBhcnNlZEFyZ3VtZW50c1snZGF0YS1iaW5hcnknXSkge1xuICAgICAgICByZXF1ZXN0LmRhdGEgPSBwYXJzZWRBcmd1bWVudHNbJ2RhdGEtYmluYXJ5J107XG4gICAgfVxuICAgIHJldHVybiByZXF1ZXN0O1xufTtcblxubW9kdWxlLmV4cG9ydHMgPSB7XG4gICAgcGFyc2VDdXJsQ29tbWFuZDogcGFyc2VDdXJsQ29tbWFuZFxufTtcbiIsIm1vZHVsZS5leHBvcnRzID0gZnVuY3Rpb24gKGFyZ3MsIG9wdHMpIHtcbiAgICBpZiAoIW9wdHMpIG9wdHMgPSB7fTtcbiAgICBcbiAgICB2YXIgZmxhZ3MgPSB7IGJvb2xzIDoge30sIHN0cmluZ3MgOiB7fSwgdW5rbm93bkZuOiBudWxsIH07XG5cbiAgICBpZiAodHlwZW9mIG9wdHNbJ3Vua25vd24nXSA9PT0gJ2Z1bmN0aW9uJykge1xuICAgICAgICBmbGFncy51bmtub3duRm4gPSBvcHRzWyd1bmtub3duJ107XG4gICAgfVxuXG4gICAgaWYgKHR5cGVvZiBvcHRzWydib29sZWFuJ10gPT09ICdib29sZWFuJyAmJiBvcHRzWydib29sZWFuJ10pIHtcbiAgICAgIGZsYWdzLmFsbEJvb2xzID0gdHJ1ZTtcbiAgICB9IGVsc2Uge1xuICAgICAgW10uY29uY2F0KG9wdHNbJ2Jvb2xlYW4nXSkuZmlsdGVyKEJvb2xlYW4pLmZvckVhY2goZnVuY3Rpb24gKGtleSkge1xuICAgICAgICAgIGZsYWdzLmJvb2xzW2tleV0gPSB0cnVlO1xuICAgICAgfSk7XG4gICAgfVxuICAgIFxuICAgIHZhciBhbGlhc2VzID0ge307XG4gICAgT2JqZWN0LmtleXMob3B0cy5hbGlhcyB8fCB7fSkuZm9yRWFjaChmdW5jdGlvbiAoa2V5KSB7XG4gICAgICAgIGFsaWFzZXNba2V5XSA9IFtdLmNvbmNhdChvcHRzLmFsaWFzW2tleV0pO1xuICAgICAgICBhbGlhc2VzW2tleV0uZm9yRWFjaChmdW5jdGlvbiAoeCkge1xuICAgICAgICAgICAgYWxpYXNlc1t4XSA9IFtrZXldLmNvbmNhdChhbGlhc2VzW2tleV0uZmlsdGVyKGZ1bmN0aW9uICh5KSB7XG4gICAgICAgICAgICAgICAgcmV0dXJuIHggIT09IHk7XG4gICAgICAgICAgICB9KSk7XG4gICAgICAgIH0pO1xuICAgIH0pO1xuXG4gICAgW10uY29uY2F0KG9wdHMuc3RyaW5nKS5maWx0ZXIoQm9vbGVhbikuZm9yRWFjaChmdW5jdGlvbiAoa2V5KSB7XG4gICAgICAgIGZsYWdzLnN0cmluZ3Nba2V5XSA9IHRydWU7XG4gICAgICAgIGlmIChhbGlhc2VzW2tleV0pIHtcbiAgICAgICAgICAgIGZsYWdzLnN0cmluZ3NbYWxpYXNlc1trZXldXSA9IHRydWU7XG4gICAgICAgIH1cbiAgICAgfSk7XG5cbiAgICB2YXIgZGVmYXVsdHMgPSBvcHRzWydkZWZhdWx0J10gfHwge307XG4gICAgXG4gICAgdmFyIGFyZ3YgPSB7IF8gOiBbXSB9O1xuICAgIE9iamVjdC5rZXlzKGZsYWdzLmJvb2xzKS5mb3JFYWNoKGZ1bmN0aW9uIChrZXkpIHtcbiAgICAgICAgc2V0QXJnKGtleSwgZGVmYXVsdHNba2V5XSA9PT0gdW5kZWZpbmVkID8gZmFsc2UgOiBkZWZhdWx0c1trZXldKTtcbiAgICB9KTtcbiAgICBcbiAgICB2YXIgbm90RmxhZ3MgPSBbXTtcblxuICAgIGlmIChhcmdzLmluZGV4T2YoJy0tJykgIT09IC0xKSB7XG4gICAgICAgIG5vdEZsYWdzID0gYXJncy5zbGljZShhcmdzLmluZGV4T2YoJy0tJykrMSk7XG4gICAgICAgIGFyZ3MgPSBhcmdzLnNsaWNlKDAsIGFyZ3MuaW5kZXhPZignLS0nKSk7XG4gICAgfVxuXG4gICAgZnVuY3Rpb24gYXJnRGVmaW5lZChrZXksIGFyZykge1xuICAgICAgICByZXR1cm4gKGZsYWdzLmFsbEJvb2xzICYmIC9eLS1bXj1dKyQvLnRlc3QoYXJnKSkgfHxcbiAgICAgICAgICAgIGZsYWdzLnN0cmluZ3Nba2V5XSB8fCBmbGFncy5ib29sc1trZXldIHx8IGFsaWFzZXNba2V5XTtcbiAgICB9XG5cbiAgICBmdW5jdGlvbiBzZXRBcmcgKGtleSwgdmFsLCBhcmcpIHtcbiAgICAgICAgaWYgKGFyZyAmJiBmbGFncy51bmtub3duRm4gJiYgIWFyZ0RlZmluZWQoa2V5LCBhcmcpKSB7XG4gICAgICAgICAgICBpZiAoZmxhZ3MudW5rbm93bkZuKGFyZykgPT09IGZhbHNlKSByZXR1cm47XG4gICAgICAgIH1cblxuICAgICAgICB2YXIgdmFsdWUgPSAhZmxhZ3Muc3RyaW5nc1trZXldICYmIGlzTnVtYmVyKHZhbClcbiAgICAgICAgICAgID8gTnVtYmVyKHZhbCkgOiB2YWxcbiAgICAgICAgO1xuICAgICAgICBzZXRLZXkoYXJndiwga2V5LnNwbGl0KCcuJyksIHZhbHVlKTtcbiAgICAgICAgXG4gICAgICAgIChhbGlhc2VzW2tleV0gfHwgW10pLmZvckVhY2goZnVuY3Rpb24gKHgpIHtcbiAgICAgICAgICAgIHNldEtleShhcmd2LCB4LnNwbGl0KCcuJyksIHZhbHVlKTtcbiAgICAgICAgfSk7XG4gICAgfVxuXG4gICAgZnVuY3Rpb24gc2V0S2V5IChvYmosIGtleXMsIHZhbHVlKSB7XG4gICAgICAgIHZhciBvID0gb2JqO1xuICAgICAgICBrZXlzLnNsaWNlKDAsLTEpLmZvckVhY2goZnVuY3Rpb24gKGtleSkge1xuICAgICAgICAgICAgaWYgKG9ba2V5XSA9PT0gdW5kZWZpbmVkKSBvW2tleV0gPSB7fTtcbiAgICAgICAgICAgIG8gPSBvW2tleV07XG4gICAgICAgIH0pO1xuXG4gICAgICAgIHZhciBrZXkgPSBrZXlzW2tleXMubGVuZ3RoIC0gMV07XG4gICAgICAgIGlmIChvW2tleV0gPT09IHVuZGVmaW5lZCB8fCBmbGFncy5ib29sc1trZXldIHx8IHR5cGVvZiBvW2tleV0gPT09ICdib29sZWFuJykge1xuICAgICAgICAgICAgb1trZXldID0gdmFsdWU7XG4gICAgICAgIH1cbiAgICAgICAgZWxzZSBpZiAoQXJyYXkuaXNBcnJheShvW2tleV0pKSB7XG4gICAgICAgICAgICBvW2tleV0ucHVzaCh2YWx1ZSk7XG4gICAgICAgIH1cbiAgICAgICAgZWxzZSB7XG4gICAgICAgICAgICBvW2tleV0gPSBbIG9ba2V5XSwgdmFsdWUgXTtcbiAgICAgICAgfVxuICAgIH1cbiAgICBcbiAgICBmdW5jdGlvbiBhbGlhc0lzQm9vbGVhbihrZXkpIHtcbiAgICAgIHJldHVybiBhbGlhc2VzW2tleV0uc29tZShmdW5jdGlvbiAoeCkge1xuICAgICAgICAgIHJldHVybiBmbGFncy5ib29sc1t4XTtcbiAgICAgIH0pO1xuICAgIH1cblxuICAgIGZvciAodmFyIGkgPSAwOyBpIDwgYXJncy5sZW5ndGg7IGkrKykge1xuICAgICAgICB2YXIgYXJnID0gYXJnc1tpXTtcbiAgICAgICAgXG4gICAgICAgIGlmICgvXi0tLis9Ly50ZXN0KGFyZykpIHtcbiAgICAgICAgICAgIC8vIFVzaW5nIFtcXHNcXFNdIGluc3RlYWQgb2YgLiBiZWNhdXNlIGpzIGRvZXNuJ3Qgc3VwcG9ydCB0aGVcbiAgICAgICAgICAgIC8vICdkb3RhbGwnIHJlZ2V4IG1vZGlmaWVyLiBTZWU6XG4gICAgICAgICAgICAvLyBodHRwOi8vc3RhY2tvdmVyZmxvdy5jb20vYS8xMDY4MzA4LzEzMjE2XG4gICAgICAgICAgICB2YXIgbSA9IGFyZy5tYXRjaCgvXi0tKFtePV0rKT0oW1xcc1xcU10qKSQvKTtcbiAgICAgICAgICAgIHZhciBrZXkgPSBtWzFdO1xuICAgICAgICAgICAgdmFyIHZhbHVlID0gbVsyXTtcbiAgICAgICAgICAgIGlmIChmbGFncy5ib29sc1trZXldKSB7XG4gICAgICAgICAgICAgICAgdmFsdWUgPSB2YWx1ZSAhPT0gJ2ZhbHNlJztcbiAgICAgICAgICAgIH1cbiAgICAgICAgICAgIHNldEFyZyhrZXksIHZhbHVlLCBhcmcpO1xuICAgICAgICB9XG4gICAgICAgIGVsc2UgaWYgKC9eLS1uby0uKy8udGVzdChhcmcpKSB7XG4gICAgICAgICAgICB2YXIga2V5ID0gYXJnLm1hdGNoKC9eLS1uby0oLispLylbMV07XG4gICAgICAgICAgICBzZXRBcmcoa2V5LCBmYWxzZSwgYXJnKTtcbiAgICAgICAgfVxuICAgICAgICBlbHNlIGlmICgvXi0tLisvLnRlc3QoYXJnKSkge1xuICAgICAgICAgICAgdmFyIGtleSA9IGFyZy5tYXRjaCgvXi0tKC4rKS8pWzFdO1xuICAgICAgICAgICAgdmFyIG5leHQgPSBhcmdzW2kgKyAxXTtcbiAgICAgICAgICAgIGlmIChuZXh0ICE9PSB1bmRlZmluZWQgJiYgIS9eLS8udGVzdChuZXh0KVxuICAgICAgICAgICAgJiYgIWZsYWdzLmJvb2xzW2tleV1cbiAgICAgICAgICAgICYmICFmbGFncy5hbGxCb29sc1xuICAgICAgICAgICAgJiYgKGFsaWFzZXNba2V5XSA/ICFhbGlhc0lzQm9vbGVhbihrZXkpIDogdHJ1ZSkpIHtcbiAgICAgICAgICAgICAgICBzZXRBcmcoa2V5LCBuZXh0LCBhcmcpO1xuICAgICAgICAgICAgICAgIGkrKztcbiAgICAgICAgICAgIH1cbiAgICAgICAgICAgIGVsc2UgaWYgKC9eKHRydWV8ZmFsc2UpJC8udGVzdChuZXh0KSkge1xuICAgICAgICAgICAgICAgIHNldEFyZyhrZXksIG5leHQgPT09ICd0cnVlJywgYXJnKTtcbiAgICAgICAgICAgICAgICBpKys7XG4gICAgICAgICAgICB9XG4gICAgICAgICAgICBlbHNlIHtcbiAgICAgICAgICAgICAgICBzZXRBcmcoa2V5LCBmbGFncy5zdHJpbmdzW2tleV0gPyAnJyA6IHRydWUsIGFyZyk7XG4gICAgICAgICAgICB9XG4gICAgICAgIH1cbiAgICAgICAgZWxzZSBpZiAoL14tW14tXSsvLnRlc3QoYXJnKSkge1xuICAgICAgICAgICAgdmFyIGxldHRlcnMgPSBhcmcuc2xpY2UoMSwtMSkuc3BsaXQoJycpO1xuICAgICAgICAgICAgXG4gICAgICAgICAgICB2YXIgYnJva2VuID0gZmFsc2U7XG4gICAgICAgICAgICBmb3IgKHZhciBqID0gMDsgaiA8IGxldHRlcnMubGVuZ3RoOyBqKyspIHtcbiAgICAgICAgICAgICAgICB2YXIgbmV4dCA9IGFyZy5zbGljZShqKzIpO1xuICAgICAgICAgICAgICAgIFxuICAgICAgICAgICAgICAgIGlmIChuZXh0ID09PSAnLScpIHtcbiAgICAgICAgICAgICAgICAgICAgc2V0QXJnKGxldHRlcnNbal0sIG5leHQsIGFyZylcbiAgICAgICAgICAgICAgICAgICAgY29udGludWU7XG4gICAgICAgICAgICAgICAgfVxuICAgICAgICAgICAgICAgIFxuICAgICAgICAgICAgICAgIGlmICgvW0EtWmEtel0vLnRlc3QobGV0dGVyc1tqXSkgJiYgLz0vLnRlc3QobmV4dCkpIHtcbiAgICAgICAgICAgICAgICAgICAgc2V0QXJnKGxldHRlcnNbal0sIG5leHQuc3BsaXQoJz0nKVsxXSwgYXJnKTtcbiAgICAgICAgICAgICAgICAgICAgYnJva2VuID0gdHJ1ZTtcbiAgICAgICAgICAgICAgICAgICAgYnJlYWs7XG4gICAgICAgICAgICAgICAgfVxuICAgICAgICAgICAgICAgIFxuICAgICAgICAgICAgICAgIGlmICgvW0EtWmEtel0vLnRlc3QobGV0dGVyc1tqXSlcbiAgICAgICAgICAgICAgICAmJiAvLT9cXGQrKFxcLlxcZCopPyhlLT9cXGQrKT8kLy50ZXN0KG5leHQpKSB7XG4gICAgICAgICAgICAgICAgICAgIHNldEFyZyhsZXR0ZXJzW2pdLCBuZXh0LCBhcmcpO1xuICAgICAgICAgICAgICAgICAgICBicm9rZW4gPSB0cnVlO1xuICAgICAgICAgICAgICAgICAgICBicmVhaztcbiAgICAgICAgICAgICAgICB9XG4gICAgICAgICAgICAgICAgXG4gICAgICAgICAgICAgICAgaWYgKGxldHRlcnNbaisxXSAmJiBsZXR0ZXJzW2orMV0ubWF0Y2goL1xcVy8pKSB7XG4gICAgICAgICAgICAgICAgICAgIHNldEFyZyhsZXR0ZXJzW2pdLCBhcmcuc2xpY2UoaisyKSwgYXJnKTtcbiAgICAgICAgICAgICAgICAgICAgYnJva2VuID0gdHJ1ZTtcbiAgICAgICAgICAgICAgICAgICAgYnJlYWs7XG4gICAgICAgICAgICAgICAgfVxuICAgICAgICAgICAgICAgIGVsc2Uge1xuICAgICAgICAgICAgICAgICAgICBzZXRBcmcobGV0dGVyc1tqXSwgZmxhZ3Muc3RyaW5nc1tsZXR0ZXJzW2pdXSA/ICcnIDogdHJ1ZSwgYXJnKTtcbiAgICAgICAgICAgICAgICB9XG4gICAgICAgICAgICB9XG4gICAgICAgICAgICBcbiAgICAgICAgICAgIHZhciBrZXkgPSBhcmcuc2xpY2UoLTEpWzBdO1xuICAgICAgICAgICAgaWYgKCFicm9rZW4gJiYga2V5ICE9PSAnLScpIHtcbiAgICAgICAgICAgICAgICBpZiAoYXJnc1tpKzFdICYmICEvXigtfC0tKVteLV0vLnRlc3QoYXJnc1tpKzFdKVxuICAgICAgICAgICAgICAgICYmICFmbGFncy5ib29sc1trZXldXG4gICAgICAgICAgICAgICAgJiYgKGFsaWFzZXNba2V5XSA/ICFhbGlhc0lzQm9vbGVhbihrZXkpIDogdHJ1ZSkpIHtcbiAgICAgICAgICAgICAgICAgICAgc2V0QXJnKGtleSwgYXJnc1tpKzFdLCBhcmcpO1xuICAgICAgICAgICAgICAgICAgICBpKys7XG4gICAgICAgICAgICAgICAgfVxuICAgICAgICAgICAgICAgIGVsc2UgaWYgKGFyZ3NbaSsxXSAmJiAvdHJ1ZXxmYWxzZS8udGVzdChhcmdzW2krMV0pKSB7XG4gICAgICAgICAgICAgICAgICAgIHNldEFyZyhrZXksIGFyZ3NbaSsxXSA9PT0gJ3RydWUnLCBhcmcpO1xuICAgICAgICAgICAgICAgICAgICBpKys7XG4gICAgICAgICAgICAgICAgfVxuICAgICAgICAgICAgICAgIGVsc2Uge1xuICAgICAgICAgICAgICAgICAgICBzZXRBcmcoa2V5LCBmbGFncy5zdHJpbmdzW2tleV0gPyAnJyA6IHRydWUsIGFyZyk7XG4gICAgICAgICAgICAgICAgfVxuICAgICAgICAgICAgfVxuICAgICAgICB9XG4gICAgICAgIGVsc2Uge1xuICAgICAgICAgICAgaWYgKCFmbGFncy51bmtub3duRm4gfHwgZmxhZ3MudW5rbm93bkZuKGFyZykgIT09IGZhbHNlKSB7XG4gICAgICAgICAgICAgICAgYXJndi5fLnB1c2goXG4gICAgICAgICAgICAgICAgICAgIGZsYWdzLnN0cmluZ3NbJ18nXSB8fCAhaXNOdW1iZXIoYXJnKSA/IGFyZyA6IE51bWJlcihhcmcpXG4gICAgICAgICAgICAgICAgKTtcbiAgICAgICAgICAgIH1cbiAgICAgICAgICAgIGlmIChvcHRzLnN0b3BFYXJseSkge1xuICAgICAgICAgICAgICAgIGFyZ3YuXy5wdXNoLmFwcGx5KGFyZ3YuXywgYXJncy5zbGljZShpICsgMSkpO1xuICAgICAgICAgICAgICAgIGJyZWFrO1xuICAgICAgICAgICAgfVxuICAgICAgICB9XG4gICAgfVxuICAgIFxuICAgIE9iamVjdC5rZXlzKGRlZmF1bHRzKS5mb3JFYWNoKGZ1bmN0aW9uIChrZXkpIHtcbiAgICAgICAgaWYgKCFoYXNLZXkoYXJndiwga2V5LnNwbGl0KCcuJykpKSB7XG4gICAgICAgICAgICBzZXRLZXkoYXJndiwga2V5LnNwbGl0KCcuJyksIGRlZmF1bHRzW2tleV0pO1xuICAgICAgICAgICAgXG4gICAgICAgICAgICAoYWxpYXNlc1trZXldIHx8IFtdKS5mb3JFYWNoKGZ1bmN0aW9uICh4KSB7XG4gICAgICAgICAgICAgICAgc2V0S2V5KGFyZ3YsIHguc3BsaXQoJy4nKSwgZGVmYXVsdHNba2V5XSk7XG4gICAgICAgICAgICB9KTtcbiAgICAgICAgfVxuICAgIH0pO1xuICAgIFxuICAgIGlmIChvcHRzWyctLSddKSB7XG4gICAgICAgIGFyZ3ZbJy0tJ10gPSBuZXcgQXJyYXkoKTtcbiAgICAgICAgbm90RmxhZ3MuZm9yRWFjaChmdW5jdGlvbihrZXkpIHtcbiAgICAgICAgICAgIGFyZ3ZbJy0tJ10ucHVzaChrZXkpO1xuICAgICAgICB9KTtcbiAgICB9XG4gICAgZWxzZSB7XG4gICAgICAgIG5vdEZsYWdzLmZvckVhY2goZnVuY3Rpb24oa2V5KSB7XG4gICAgICAgICAgICBhcmd2Ll8ucHVzaChrZXkpO1xuICAgICAgICB9KTtcbiAgICB9XG5cbiAgICByZXR1cm4gYXJndjtcbn07XG5cbmZ1bmN0aW9uIGhhc0tleSAob2JqLCBrZXlzKSB7XG4gICAgdmFyIG8gPSBvYmo7XG4gICAga2V5cy5zbGljZSgwLC0xKS5mb3JFYWNoKGZ1bmN0aW9uIChrZXkpIHtcbiAgICAgICAgbyA9IChvW2tleV0gfHwge30pO1xuICAgIH0pO1xuXG4gICAgdmFyIGtleSA9IGtleXNba2V5cy5sZW5ndGggLSAxXTtcbiAgICByZXR1cm4ga2V5IGluIG87XG59XG5cbmZ1bmN0aW9uIGlzTnVtYmVyICh4KSB7XG4gICAgaWYgKHR5cGVvZiB4ID09PSAnbnVtYmVyJykgcmV0dXJuIHRydWU7XG4gICAgaWYgKC9eMHhbMC05YS1mXSskL2kudGVzdCh4KSkgcmV0dXJuIHRydWU7XG4gICAgcmV0dXJuIC9eWy0rXT8oPzpcXGQrKD86XFwuXFxkKik/fFxcLlxcZCspKGVbLStdP1xcZCspPyQvLnRlc3QoeCk7XG59XG5cbiIsIid1c2Ugc3RyaWN0JztcblxubW9kdWxlLmV4cG9ydHMucGFyc2VBcmdzU3RyaW5nVG9Bcmd2ID0gcGFyc2VBcmdzU3RyaW5nVG9Bcmd2O1xuXG5mdW5jdGlvbiBwYXJzZUFyZ3NTdHJpbmdUb0FyZ3YodmFsdWUsIGVudiwgZmlsZSkge1xuICAgIC8vW15cXHMnXCJdIE1hdGNoIGlmIG5vdCBhIHNwYWNlICcgb3IgXCJcbiAgICAvLyt8WydcIl0gb3IgTWF0Y2ggJyBvciBcIlxuICAgIC8vKFteJ1wiXSopIE1hdGNoIGFueXRoaW5nIHRoYXQgaXMgbm90ICcgb3IgXCJcbiAgICAvL1snXCJdIENsb3NlIG1hdGNoIGlmICcgb3IgXCJcbiAgICB2YXIgbXlSZWdleHAgPSAvW15cXHMnXCJdK3xbJ1wiXShbXidcIl0qKVsnXCJdL2dpO1xuICAgIHZhciBteVN0cmluZyA9IHZhbHVlO1xuICAgIHZhciBteUFycmF5ID0gW1xuICAgIF07XG4gICAgaWYoZW52KXtcbiAgICAgICAgbXlBcnJheS5wdXNoKGVudik7XG4gICAgfVxuICAgIGlmKGZpbGUpe1xuICAgICAgICBteUFycmF5LnB1c2goZmlsZSk7XG4gICAgfVxuICAgIHZhciBtYXRjaDtcbiAgICBkbyB7XG4gICAgICAgIC8vRWFjaCBjYWxsIHRvIGV4ZWMgcmV0dXJucyB0aGUgbmV4dCByZWdleCBtYXRjaCBhcyBhbiBhcnJheVxuICAgICAgICBtYXRjaCA9IG15UmVnZXhwLmV4ZWMobXlTdHJpbmcpO1xuICAgICAgICBpZiAobWF0Y2ggIT09IG51bGwpIHtcbiAgICAgICAgICAgIC8vSW5kZXggMSBpbiB0aGUgYXJyYXkgaXMgdGhlIGNhcHR1cmVkIGdyb3VwIGlmIGl0IGV4aXN0c1xuICAgICAgICAgICAgLy9JbmRleCAwIGlzIHRoZSBtYXRjaGVkIHRleHQsIHdoaWNoIHdlIHVzZSBpZiBubyBjYXB0dXJlZCBncm91cCBleGlzdHNcbiAgICAgICAgICAgIG15QXJyYXkucHVzaChtYXRjaFsxXSA/IG1hdGNoWzFdIDogbWF0Y2hbMF0pO1xuICAgICAgICB9XG4gICAgfSB3aGlsZSAobWF0Y2ggIT09IG51bGwpO1xuXG4gICAgcmV0dXJuIG15QXJyYXk7XG59Il19
