#!/bin/bash
#Date 2013-8-7
#author wwpeng
#email 591826944@qq.com

#该函数用于 合并且压缩 js/css
function mergeFileContent()
{
	data=($5)
	#获得当前时间戳
	time=$(date +%s)
	#创建临时文件，合并所有的js/css
	tempFile=temp-${time}.$1
	touch $tempFile
	#读取 合并 文件
	for (( i = 0; i < ${#data[@]}; ++i )); do 
	
		#检测文件是否存在
		if [ ! -f $2${data[$i]} ] ;
		then
			echo "Warning : File $2${data[$i]} is not exit!!!";
		else
			cache=`cat $2${data[$i]}`
			echo "$cache" >> $tempFile;
		fi
	
	done
	#使用yuicompressor 压缩js/css
	java -jar yuicompressor.jar --type $1 --charset utf-8 -o $3$4 $tempFile
	#删除临时合并的js文件
	rm -if $tempFile
	#修正 yuicompressor 对于 @media 响应式样式的压缩错误
	if [ "$1" == "css" ] ;
	then
		 sed -i.bak "s/and(/and (/g" $3$4
		 rm -f $3$4".bak"
	fi
	#输出提示
	echo "The success of $1 compression!"
}

if [ "$1" == "js" ] ;
then

	#配置要合并的js文件所在的目录
	inputPath="/Users/wwpeng/site/a-ou/themes/a-ou_2013/scripts"
	#配置生成的js 要输出的目录
	outputPath="/Users/wwpeng/site/a-ou/themes/a-ou_2013/scripts"
	#配置要生成的js 文件的文件名
	outputJsName=a-ou_min.js
	#配置要合并的js文件 空格分割
	jsData=(ajaxupload.js a-ou.js jquery.color.js jquery.cookie.js jquery.easing.js jquery.fancybox-1.3.4.min.js jquery.lazyload.js jquery.mousewheel.js waterfall.js handlebars.js)
	
	mergeFileContent $1 $inputPath $outputPath $outputJsName "${jsData[*]}"

elif [ "$1" == "css" ] ;
then

	#配置要合并的css文件所在的目录
	inputPath="/Users/wwpeng/site/a-ou/themes/a-ou_2013/css/"
	#配置生成的css 要输出的目录
	outputPath="/Users/wwpeng/site/a-ou/themes/a-ou_2013/css/"
	#配置要生成的css 文件的文件名
	outputCssName=a-ou_min.css
	#配置要合并的css文件 空格分割
	cssData=(a-ou.css)
	
	mergeFileContent $1 $inputPath $outputPath $outputCssName "${cssData[*]}"

else
	echo "Error : Please make sure the positon variable is js or css!!"
fi


