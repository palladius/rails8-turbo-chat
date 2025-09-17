// lodash.isplainobject@4.0.6 downloaded from https://ga.jspm.io/npm:lodash.isplainobject@4.0.6/index.js

var t={};var r="[object Object]";function isHostObject(t){var r=false;if(null!=t&&"function"!=typeof t.toString)try{r=!!(t+"")}catch(t){}return r}function overArg(t,r){return function(e){return t(r(e))}}var e=Function.prototype,n=Object.prototype;var o=e.toString;var c=n.hasOwnProperty;var i=o.call(Object);var a=n.toString;var u=overArg(Object.getPrototypeOf,Object);function isObjectLike(t){return!!t&&"object"==typeof t}function isPlainObject(t){if(!isObjectLike(t)||a.call(t)!=r||isHostObject(t))return false;var e=u(t);if(null===e)return true;var n=c.call(e,"constructor")&&e.constructor;return"function"==typeof n&&n instanceof n&&o.call(n)==i}t=isPlainObject;var f=t;export default f;

