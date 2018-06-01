let str=require("./a.js"); //自定义模块需要加"./", 如果第三方模块不需要加
console.log(str)

let aa="wxj";
console.log(aa);
let obj1={name:"wxj"};
let obj2={age:18};
let objNew={...obj1,...obj2};
console.log(objNew)

import "./min.css" ;
import "./a.less" ;

import page from "./1.jpg"
let img=new Image();
//img.src="./1.jpg";
img.src=page;
document.body.appendChild(img);