wdcp-php-upgrade
================

shell script to upgrade wdcp's php version to 5.4

This is not my work, I push this to github for easy access for my own use.

From the original post: http://www.wdlinux.cn/bbs/thread-4771-1-1.html

加入了mysqli、pdo_mysql扩展，提供给喜欢追新或有高版本需求的网友，如无此需要的话，使用原先的PHP 5.2.17即可

注：某些程序可能仅能在低版本下正常工作，如无必要请谨慎升级！

该升级只是升级PHP的版本,相应的zend,eaccelerator没有升级

且zend opt从php5.3开始已不再支持,也就是说有用到zend opt的,就不要升级了,否则只会瞎折腾

升级方法如下：

解压后将sh文件上传到root目录下（或当前工作路径），

然后在SSH里执行此命令

sh php_up54.sh

脚本里的PHP版本为5.4.31，如果以后发布了新版本的话，执行：（将版本号改成实际的版本号即可）

sh php_up54.sh 版本号

引自 33L jacky6388：

make: *** [ext/date/lib/parse_date.lo] Error 1
make err

当出现类似于上面的错误时，可能是由于PHP5.4限制了小于1G内存的主机的安装
可以通过以下步骤来解决：
用专门的文本编辑器（如Notepad++、EditPlus等，不要用记事本打开）打开下载好的sh文件，找到--disable-rpath字段（有两处）
都修改为：--disable-fileinfo
这样就可以绕过检测来安装