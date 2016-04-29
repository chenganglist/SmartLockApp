//
//  BaiduDitu.m
//  SmartLock
//
//  Created by csis on 16/4/27.
//  Copyright © 2016年 csis. All rights reserved.
//

#import "BaiduDituNaviView.h"

@interface BaiduDituNaviView ()

@end

@implementation BaiduDituNaviView
@synthesize _address;

- (void)viewDidLoad {
    [super viewDidLoad];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self action:@selector(viewTapped:)];
    tap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap];
    
    // Do any additional setup after loading the view from its nib.
    //定位服务
    _locService = [[BMKLocationService alloc]init];
    _locService.delegate = self;
    //启动LocationService
    [_locService startUserLocationService];
    
    //地理信息反向编码
    _geocodesearch = [[BMKGeoCodeSearch alloc] init];
    //编码服务的初始化(就是获取经纬度,或者获取地理位置服务)
    _geocodesearch.delegate = self;//设置代理为self

    
}



//实现相关delegate 处理位置信息更新


//处理方向变更信息
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    NSLog(@"heading is %@",userLocation.heading);
}


//处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    //打印经纬度
    _mapView.showsUserLocation = YES;//显示定位图层
    [_mapView updateLocationData:userLocation];
    
    //longitude经度-x   latitude纬度-y
    NSLog(@"didUpdateUserLocation lat %f,long %f",
    userLocation.location.coordinate.latitude,
    userLocation.location.coordinate.longitude);
    
    CLLocationCoordinate2D coor = (CLLocationCoordinate2D){0, 0};//初始化;
    coor.latitude = userLocation.location.coordinate.latitude;
    coor.longitude = userLocation.location.coordinate.longitude;
    BMKCoordinateRegion viewRegion = BMKCoordinateRegionMake(coor, BMKCoordinateSpanMake(0.02f,0.02f));
    BMKCoordinateRegion adjustedRegion = [_mapView regionThatFits:viewRegion];
    [_mapView setRegion:adjustedRegion animated:YES];
 
    [_locService stopUserLocationService];
    
    
    //起点
    _startNode = [[BNRoutePlanNode alloc] init];
    _startNode.pos = [[BNPosition alloc] init];
    _startNode.pos.x =  userLocation.location.coordinate.longitude;//经度
    _startNode.pos.y = userLocation.location.coordinate.latitude;//纬度
    _startNode.pos.eType = BNCoordinate_BaiduMapSDK;
    
    [self getDestinationPosition];
    NSLog(@"开始检索地理位置经纬度");
//    //进行地理位置反向编码
//    BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];//初始化反编码请求
//    reverseGeocodeSearchOption.reverseGeoPoint = coor;//设置反编码的店为pt
//    BOOL flag = [_geocodesearch reverseGeoCode:reverseGeocodeSearchOption];//发送反编码请求.并返回是否成功
//    if(flag)
//    {
//        NSLog(@"反geo检索发送成功");
//    }
//    else
//    {
//        NSLog(@"反geo检索发送失败");
//    }
    
    
}

-(void)getDestinationPosition{
    
    Get* get = [[Get alloc] init];
    NSString *urlString = @"http://api.map.baidu.com/geocoder/v2/";
    [get setDelegate:self];
    NSDictionary *parameters = @{
            @"ak":@"hDZ8Dh0Z18xmGlcZlZifo6US7oipIKhr",
            @"address":@"成都市金牛区跃进村",
            @"output":@"json"};
    [get getUrl:urlString withParams:parameters];
    
}

-(void)alertUI:(NSError *)error
{
    //初始化提示框；
    NSString* info = [[NSString alloc] initWithFormat:@"错误：%@",error];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示"
        message:info preferredStyle: UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"返回解析地址" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //点击按钮的响应事件；
    }]];
    
    //弹出提示框；
    [self presentViewController:alert animated:true completion:nil];
}

-(void)updateUI:(NSDictionary*)data
{
    NSLog(@"UpdateUI %@",data);
    
    NSDictionary* result = data[@"result"];
    NSDictionary* location = result[@"location"];

    NSLog(@"纬度： %@  经度： %@",location[@"lat"],location[@"lng"]);
    
    //终点
    _endNode = [[BNRoutePlanNode alloc] init];
    _endNode.pos = [[BNPosition alloc] init];
    _endNode.pos.x = [location[@"lng"] doubleValue]; //经度
    _endNode.pos.y = [location[@"lat"] doubleValue]; //纬度
    _endNode.pos.eType = BNCoordinate_BaiduMapSDK;
    
    NSLog(@"开始导航到目的地");
    [self startNavi:_startNode withDestination:_endNode];

}


-(void) onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    if (error == 0) {
        BMKPointAnnotation* item = [[BMKPointAnnotation alloc]init];
        item.coordinate = result.location;
        item.title = result.address;
        NSString* showmeg = [NSString stringWithFormat:@"%@",item.title];
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"反向地理编码"
           message:showmeg preferredStyle: UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
                          {
                               [self getDestinationPosition];
                          }]];
        [self presentViewController:alert animated:true completion:nil];

    }
}


-(void)viewWillAppear:(BOOL)animated
{
    [_mapView viewWillAppear];
    _mapView.delegate = self;
    // 此处记得不用的时候需要置nil，否则影响内存的释放
}

-(void)viewWillDisappear:(BOOL)animated
{
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
}


//发起导航
- (void)startNavi:(BNRoutePlanNode*)startNode withDestination:(BNRoutePlanNode*)endNode
{
    //节点数组
    NSMutableArray *nodesArray = [[NSMutableArray alloc]    initWithCapacity:2];

    [nodesArray addObject:startNode];
    [nodesArray addObject:endNode];
    //发起路径规划
    [BNCoreServices_RoutePlan startNaviRoutePlan:BNRoutePlanMode_Recommend naviNodes:nodesArray time:nil delegete:self userInfo:nil];
}

//算路成功回调
-(void)routePlanDidFinished:(NSDictionary *)userInfo
{
    NSLog(@"算路成功");
    
    //路径规划成功，开始导航
    [BNCoreServices_UI showNaviUI: BN_NaviTypeReal delegete:self isNeedLandscape:YES];
}

//算路失败回调
- (void)routePlanDidFailedWithError:(NSError *)error andUserInfo:(NSDictionary *)userInfo
{
    NSLog(@"算路失败");
    if ([error code] == BNRoutePlanError_LocationFailed) {
        NSLog(@"获取地理位置失败");
    }
    else if ([error code] == BNRoutePlanError_RoutePlanFailed)
    {
        NSLog(@"定位服务未开启");
    }
}

//算路取消
-(void)routePlanDidUserCanceled:(NSDictionary*)userInfo {
    NSLog(@"算路取消");
}


-(void)viewTapped:(UITapGestureRecognizer*)tap
{
    
    [self.view endEditing:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
