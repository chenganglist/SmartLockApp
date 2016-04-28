//
//  BaiduDitu.h
//  SmartLock
//
//  Created by csis on 16/4/27.
//  Copyright © 2016年 csis. All rights reserved.
//

#import <UIKit/UIKit.h>
//引入base相关所有的头文件
#import <BaiduMapAPI_Base/BMKBaseComponent.h>

//引入地图功能所有的头文件
#import <BaiduMapAPI_Map/BMKMapComponent.h>

//引入检索功能所有的头文件
#import <BaiduMapAPI_Search/BMKSearchComponent.h>

//引入云检索功能所有的头文件
#import <BaiduMapAPI_Cloud/BMKCloudSearchComponent.h>

//引入定位功能所有的头文件
#import <BaiduMapAPI_Location/BMKLocationComponent.h>

//引入计算工具所有的头文件
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>

//引入周边雷达功能所有的头文件
#import <BaiduMapAPI_Radar/BMKRadarComponent.h>

#import "BNCoreServices.h"
#import "BNUIManagerProtocol.h"
#import "GetDelegate.h"

@interface BaiduDitu : UIViewController<BMKMapViewDelegate,BMKLocationServiceDelegate,
    BNNaviRoutePlanDelegate,
    BNNaviUIManagerDelegate,
    BMKGeoCodeSearchDelegate,GetDelegate>
{
    IBOutlet BMKMapView *_mapView;
    BMKLocationService* _locService;
    BMKGeoCodeSearch* _geocodesearch;
}

- (void)startNavi:(BNPosition*)start withDestination:(BNPosition*)end;

@end
