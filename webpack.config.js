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
           template:"./src/default.html",
           filename:"default2.html"  
       })
    ]
}