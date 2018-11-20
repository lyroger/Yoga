//
//  YGAddressDetailByMapVC.m
//  YoGa
//
//  Created by Mac on 2018/9/3.
//  Copyright © 2018年 YugaLian. All rights reserved.
//

#import "YGAddressDetailByMapVC.h"
#import <MapKit/MapKit.h>
#import "MapAnnotation.h"

@interface YGAddressDetailByMapVC ()<MKMapViewDelegate,UIActionSheetDelegate>
{
    MKMapView *mapView;
    CLLocationCoordinate2D coordinate;
}

@property (nonatomic,strong) UIView *bottomView;
@end

@implementation YGAddressDetailByMapVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.titleName;
    mapView = [[MKMapView alloc] init];
    [self.view addSubview:mapView];
    // 设置代理
    mapView.delegate = self;

    coordinate = CLLocationCoordinate2DMake(self.latitude,self.longitude);
    MapAnnotation *annotation = [[MapAnnotation alloc] init];
    annotation.coordinate = coordinate;
    annotation.title = self.address;
    [mapView addAnnotation:annotation];
    [mapView setRegion:MKCoordinateRegionMakeWithDistance(coordinate, 2000, 2000)];


    self.bottomView = [[UIView alloc] init];
    self.bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.bottomView];

    UIImageView *imageIcon = [[UIImageView alloc] init];
    imageIcon.image = [UIImage imageNamed:@"list_ic_location"];
    [self.bottomView addSubview:imageIcon];

    UILabel *addressLabel = [[UILabel alloc] init];
    addressLabel.text = self.address;
    addressLabel.font = [UIFont systemFontOfSize:15];
    addressLabel.textColor = UIColorHex(0x333333);
    addressLabel.userInteractionEnabled = YES;
    [self.bottomView addSubview:addressLabel];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseViewType)];
    [addressLabel addGestureRecognizer:tap];
    // Do any additional setup after loading the view.

    [mapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-50);
    }];

    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(50);
    }];

    [imageIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.centerY.mas_equalTo(self.bottomView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(25, 25));
    }];

    [addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.bottomView.mas_centerY);
        make.top.right.bottom.mas_equalTo(0);
        make.left.mas_equalTo(imageIcon.mas_right).mas_offset(8);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)chooseViewType
{
    UIActionSheet *actionView = [[UIActionSheet alloc] initWithTitle:@"选择地图" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"用iPhone自带地图导航",@"用百度地图导航",@"用高德地图导航", nil];
    [actionView showInView:self.view];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    MKPinAnnotationView *annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"MapSample"];
    annotationView.canShowCallout = YES;
    return annotationView;
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        // 苹果自带
        [self skipToAppleMap:coordinate];
    } else if (buttonIndex == 1) {
        // 百度
        [self skipToBaiduMap:coordinate];
    } else if (buttonIndex == 2) {
        // 高德
        [self skipToGaodeMap:coordinate];
    }
}


- (void)skipToAppleMap:(CLLocationCoordinate2D)coordinate
{
    if ( [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"http://maps.apple.com/"]]){
        MKMapItem *currentLocation = [MKMapItem mapItemForCurrentLocation];
        MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:coordinate addressDictionary:nil]];
        [MKMapItem openMapsWithItems:@[currentLocation, toLocation]
                       launchOptions:@{MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving,
                                       MKLaunchOptionsShowsTrafficKey: [NSNumber numberWithBool:YES]}];
    } else {
        //没有安装该软件
        [HUDManager alertWithTitle:@"没有安装改软件"];
    }
}

- (void)skipToBaiduMap:(CLLocationCoordinate2D)coordinate
{
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"baidumap://"]]) {
        NSString *urlString = [[NSString stringWithFormat:@"baidumap://map/direction?origin={{我的位置}}&destination=latlng:%f,%f|name=目的地&mode=driving&coord_type=gcj02",coordinate.latitude, coordinate.longitude] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
    } else {
        //没有安装该软件
        [HUDManager alertWithTitle:@"没有安装改软件"];
    }
}

- (void)skipToGaodeMap:(CLLocationCoordinate2D)coordinate
{
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"iosamap://"]]) {
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        NSString *appName = [infoDictionary objectForKey:@"CFBundleDisplayName"];

        NSString *urlString = [[NSString stringWithFormat:@"iosamap://navi?sourceApplication=%@&backScheme=%@&lat=%f&lon=%f&dev=0&style=2",appName,@"exmindApp",coordinate.latitude, coordinate.longitude] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
    } else {
        //没有安装该软件
        [HUDManager alertWithTitle:@"没有安装改软件"];
    }

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
