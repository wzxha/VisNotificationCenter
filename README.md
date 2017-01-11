# VisNotificationCenter
Address some of the issues in the NSNotificationCenter

# 有什么作用?
1. 观察者只会添加同一个通知一次。
2. 能返回一个包含所有通知信息字典的数组。

# 字典结构
|观察者|通知名|发送者|方法|
| ----|:----:| ---:| ---:|
|Observer|Name|Object|SEL|

# In Use
```objc
 [[NSNotificationCenter vis_defaultCenter] addObserver:self selector:@selector(test) name:@"test" object:nil];
 ...
 ...
```
