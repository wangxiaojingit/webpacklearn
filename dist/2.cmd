### webpack 

1 npm init -y  //初始化package.json
2 npm install webpack@3 --save-dev   //开发环境的webpack
3 修改package.json 里面的配置项:
  ```
  "scripts": {
    "build": "webpack"
  }

  ```
  命令的解释:在package.json 中配置一个文本,web的执行命令是webpack,回去当前的
  nodemodules 下去找.bin 文件下的webpack.cmd,让其执行的是webpack\bin\webpack.js,
  webpack.js 需要当前目录下有个叫webpack.config.js,我们通过npm run bulid 执行的目录是
  当前目录,所以会去当前目录下查找.

  4 在根目录下添加webpack.config.js

  ```
     let path=require("path")
     module.exports={
         entry:"./src/main.js" //入口文件
         output:{
             filename:"bundle.js" //打包后的文件名字
             path:path.resolve(__dirname,"./dist") //打包后的文件路径(放到哪)
         }
     }
  ```

  ## es6 转换为es5 用babel
  1 npm install babel-core
  2 npm install babel-loader
  
  让翻译官拥有解析es6语法的功能
  3 npm install babel-preset-es2015 --save-dev
  要想把es6翻译成es5 还需要增加一个.babelrc
  
  ```
    {
      "presets":["es2015"]
    }
  ```
   解析es7语法
   4 npm install babel-preset-stage-0 --save-dev

   ```
   {
     "presets":["es2015","stage-0"]
   }

   ```
   webpack.config.js   es6转换为es5,过滤掉node_module 下面的js
```
module.exports={

    entry:"./src/main.js", //入口
    output:{
        path:path.resolve("./dist"), //把相对路径解析成绝对路径
        filename:"bundle.js" //打包后的文件名字
       
    },
    module:{
        rules:[
            {test:/\.js$/,
             use:"babel-loader",
             exclude:/node_module/  
            }
        ]
    }
}



```

## css 如何引入到js中
1 需要下载 cnpm install css-loader style-loader --save-dev
2 webpack.config.js 中进行配置

```
  module:{
        rules:[
            {test:/\.js$/,
             use:"babel-loader",
             exclude:/node_module/
            },
            {test:/\.css$/,
             //use 中的顺序是从右往左,先解析css-loader 然后再用style-loader 去插入
             use:["style-loader","css-loader"]  
            },
            {test:/\.less$/,
             use:["less-loader","style-loader","css-loader"]
            
            }
        ]
    }
```
3 在main.js 中引入css
```
import "./min.css"

```

### 用less的时候
1 cnpm install less less-loader --save-dev

2 在webpack.config.js 中配置 
```
    {   test:/\.less$/,
        use:["style-loader","css-loader","less-loader"]  
    }
```

### 解析图片路径
1 需要下载 npm install file-loader url-loader (url-loader 是依赖于file-loader的,但需要安装两个)
2 配置webpack.config.js

```
module:{
        rules:[
            {test:/\.js$/,
             use:"babel-loader",
             exclude:/node_module/
            },
            {test:/\.css$/,
             use:["style-loader","css-loader"]  
            }, 
            {test:/\.less$/,
                use:["style-loader","css-loader","less-loader"]  
            },
            {
              test:/\.(jpg|png|gif)$/,
              //如果图片大于8k 即8192个字节,就不要转换成base64,直接把图片打包出去
              use:"url-loader?limit=8192" 
            }
        ]
    }
```
3 在main.css 中引入图片
```
body{
    background:green;
    background:url("./default.gif");
    
}
```
4 如果不是在css 中引入图片,在js 中引入图片,
```
 let img=new Image();
 img.src="./1.jpg"; //这个路径会当成字符串
 document.body.appendChild(img);
```
如果按照上面的写法,图片路径会当成字符串,找不到下面的1.jpg,如果在js中引入图片,
```
  import page from "./1.jpg";
  let img=new Image();
  img.src=page;
  document.body.append(img)

```