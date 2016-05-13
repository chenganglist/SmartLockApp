##代码结构说明
###POST方法封装
	Post.h和Post.m封装了APP与后台的POST请求，基于此实现APP与后台交互。该POST模块
	使用了AFNetworking网络通信类库。AFNetworking网络通信类库通过cocoapods管理。
	本项目通过pod命令行导入外部库。

###界面管理和跳转说明
	项目整体界面通过storyboard实现；具体的功能界面通过Xib实现


###用户信息管理模块
####登录界面
	ViewController实现了登录界面

####用户信息管理
	UserInfoView实现了用户信息的查看

####用户信息修改
	changeUserInfoView实现了用户信息的修改

###工单任务管理模块
####工单申请
	ApplyWorkView实现了工单申请

####工单分类
	ManageWorkView和ClassifyWorkView实现了工单分类查看

####工单查看和审批
	WorkDetail实现了工单查看和审批

####百度定位和导航
	BaiduDituNaviView实现了从当前位置导航到指定位置；Get类通过发送网络请求实现了
	地理位置反向解析经纬度


###电子钥匙和门锁管理模块
####门禁管理页面
	EntranceManageView实现了门禁管理页面

####蓝牙搜索
	KeyManagementView实现了蓝牙搜索;蓝牙功能基于IOS原生蓝牙库CoreBluetooth实现

####CSIS电子钥匙蓝牙通信
	BLECommunication实现了和实验室自制门锁蓝牙的通信

####黑芝麻电子钥匙蓝牙通信
	HeiZhimaDebug用于实现APP和黑芝麻电子钥匙通信

####CSIS门锁蓝牙通信
	APPDoorCommunication实现了和实验室自制门锁蓝牙的通信

####CSIS门锁蓝牙通信
	LocalAppHistory用户管理本地门锁历史记录





