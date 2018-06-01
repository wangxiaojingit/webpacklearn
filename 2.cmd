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

## html 插件 html-webpack-plugin
插件的作用:是以我们自己的html为模板,将打包后的结果,自动引入dist目录下的html 中
1 安装:
  npm install html-webpack-plugin --save-dev
2 修改webpack.config.js

```
 let path=require("path");
let htmlWebpackPlugin=require("html-webpack-plugin");
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
            },
            {test:/\.css$/,
             use:["style-loader","css-loader"]  
            }, 
            {test:/\.less$/,
                use:["style-loader","css-loader","less-loader"]  
            },
            {
              test:/\.(jpg|png|gif)$/,
              use:"url-loader?limit=8192"
            }
        ]
    },
    plugins:[
       new htmlWebpackPlugin({
           template:"./src/default.html"  //找到这个模板路径,会在dist 中产生一个以这样模板的index.html(默认是index.html)
           filename:"index2.html" //修改dist 中默认的index.html 名字为:"index2.html"
       })
    ]
}

```  




##  我们并不想每次都用npm run build;为此我们可以webpack-dev-server
这里面内置了一个服务,帮我们开启了一个端口号,当代码更新时可以自动打包(内存中打包),
代码有变化时重新执行.
1 下载
   npm install webpack-dev-server --save-dev
2 修改配置package.json 

```
   "scripts": {
    "build": "webpack",
    "dev"  :"webpack-dev-server"  //当执行npm run dev 的时候运行的是.bin 下面的webpack-dev-server.js
  },
```
3 运行 npm run dev

如果报错" Cannot find module 'webpack-cli/bin/config-yargs",
是因为安装的webpack 和webpack-dev-server 版本不匹配.
目前安装的webpack 的版本:3.0
webpack-dev-server 的版本:3.0 报错,卸载 cnpm uninstall webpack-dev-server@3 --save-dev
重新安装cnpm install webpack-dev-server@2 --save-dev
      
