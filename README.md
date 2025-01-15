# DylibInject
通过tweak注入动态库
这里的FLEX.framework只是示例，可以替换成任何你想注入的Framework，记得在Tweak.xm文件中改一下Framework的初始化方法。

```bash
make package
scp -P 22 packages/com.paradiseduo.dylibinject_0.0.1-01+debug_iphoneos-arm.deb root@10.10.10.10:/tmp
```
