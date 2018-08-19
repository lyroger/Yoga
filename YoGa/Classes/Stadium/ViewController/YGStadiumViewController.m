//
//  YGStadiumViewController.m
//  YoGa
//
//  Created by 罗琰 on 2018/8/1.
//  Copyright © 2018年 QinYoga. All rights reserved.
//

#import "YGStadiumViewController.h"
#import "YGStadiumCell.h"
#import "YGStadiumModel.h"
#import "YGStadiumDetailVC.h"
#import "YGStadiumSearchViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface YGStadiumViewController ()<UITableViewDelegate,UITableViewDataSource,CLLocationManagerDelegate>
{
    CLLocationManager *locationmanager;//定位服务
    NSString *strlatitude;//经度
    NSString *strlongitude;//纬度
    CLLocation *currentLocation;
}

@property (nonatomic,strong) UITableView *tableViewList;
@property (nonatomic,strong) NSMutableArray *dataList;
@property (nonatomic,strong) UIImageView *headView;
@property (nonatomic,assign) NSInteger pageIndex;
@end

@implementation YGStadiumViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"场馆";
    [self loadSubView];
    // Do any additional setup after loading the view.
}

- (NSMutableArray*)dataList{
    if (!_dataList) {
        _dataList = [[NSMutableArray alloc] init];
    }
    return _dataList;
}

- (UIImageView*)headView
{
    if (!_headView) {
        _headView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 160)];
        _headView.backgroundColor = UIColorHex(0xf4f4f4);
    }
    return _headView;
}

- (void)loadSubView{
    [self rightBarButtonWithName:nil normalImgName:@"nav_ic_search" highlightImgName:@"nav_ic_search" target:self action:@selector(searchStadium)];
    
    self.tableViewList = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableViewList.dataSource = self;
    self.tableViewList.delegate = self;
    self.tableViewList.backgroundColor = UIColorHex(0xffffff);
    self.tableViewList.tableHeaderView = self.headView;
    [self.tableViewList registerClass:[YGStadiumCell class] forCellReuseIdentifier:@"YGStadiumCell"];
    [self.view addSubview:self.tableViewList];
    
    @weakify(self);
    self.tableViewList.mj_header = [MJDIYHeader headerWithRefreshingBlock:^{
        @strongify(self);
        [self refreshData];
    }];
    [self refreshData];

    [self.tableViewList mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.mas_equalTo(0);
    }];

    for (NSInteger i = 0; i< 15; i++) {
        YGStadiumModel *model = [[YGStadiumModel alloc] init];
        model.name = @"紫英瑜伽馆";
        model.address = @"南山区大冲商务中心";
        model.distance = @"南山 < 500m";
        model.imageURL = @"";
        [self.dataList addObject:model];
    }
    [self getLocation];
    [self.tableViewList reloadData];
}

- (void)refreshData
{
    self.pageIndex = 0;
    [self loadStadiumsData];
}

- (void)loadStadiumsData
{
    [YGStadiumModel getStadiumListsByName:nil pageSize:20 pageIndex:self.pageIndex target:self success:^(StatusModel *data) {
        [self.tableViewList.mj_header endRefreshing];
        [self.tableViewList.mj_footer endRefreshing];
        
        if (data.code == 0) {
            NSArray *stadiums = [YGStadiumModel mj_objectArrayWithKeyValuesArray:[data.originalData objectForKey:@"rows"]];
            if (currentLocation) {
                [stadiums enumerateObjectsUsingBlock:^(YGStadiumModel  *model, NSUInteger idx, BOOL * _Nonnull stop) {
                    model.distance = [self getDistance:model];
                }];
            }
            if (self.pageIndex == 0) {
                [self.dataList removeAllObjects];
            }
            [self.dataList addObjectsFromArray:stadiums];
            BOOL hasMoreData = true;
            if ([[data.originalData objectForKey:@"total"] integerValue] == self.dataList.count) {
                [self.tableViewList.mj_footer endRefreshingWithNoMoreData];
                hasMoreData = false;
            } else {
                self.pageIndex ++;
            }
            if (self.pageIndex == 1 && hasMoreData) {
                self.tableViewList.mj_footer = [MJDIYFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadStadiumsData)];
            }
            [self.tableViewList reloadData];
        } else {
            
        }
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    YGStadiumModel *model = self.dataList[indexPath.row];
    YGStadiumDetailVC *vc = [[YGStadiumDetailVC alloc] init];
    vc.stadiumInfo = model;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 87;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataList.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YGStadiumCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YGStadiumCell"];
    [cell model:self.dataList[indexPath.row]];
    return cell;
}

- (void)searchStadium
{
    YGStadiumSearchViewController *searchVC = [[YGStadiumSearchViewController alloc] init];
    searchVC.hidesBottomBarWhenPushed = YES;
    UINavigationController *searchNav = [[UINavigationController alloc] initWithRootViewController:searchVC];
    [self presentViewController:searchNav animated:YES completion:nil];
}

- (void)getLocation
{
    //判断定位功能是否打开
    if ([CLLocationManager locationServicesEnabled]) {
        locationmanager = [[CLLocationManager alloc]init];
        locationmanager.delegate = self;
        [locationmanager requestAlwaysAuthorization];
        [locationmanager requestWhenInUseAuthorization];
        
        //设置寻址精度
        locationmanager.desiredAccuracy = kCLLocationAccuracyBest;
        locationmanager.distanceFilter = 5.0;
        [locationmanager startUpdatingLocation];
    }
}

#pragma mark CoreLocation delegate (定位失败)
//定位失败后调用此代理方法
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    //设置提示提醒用户打开定位服务
    NSLog(@"定位失败");
//    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"允许定位提示" message:@"请在设置中打开定位" preferredStyle:UIAlertControllerStyleAlert];
//    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"打开定位" style:UIAlertActionStyleDefault handler:nil];
//
//    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
//    [alert addAction:okAction];
//    [alert addAction:cancelAction];
//    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark 定位成功后则执行此代理方法
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    [locationmanager stopUpdatingHeading];
    //旧址
    currentLocation = [locations lastObject];
    [self.dataList enumerateObjectsUsingBlock:^(YGStadiumModel  *model, NSUInteger idx, BOOL * _Nonnull stop) {
        model.distance = [self getDistance:model];
    }];
    [self.tableViewList reloadData];
//    CLGeocoder *geoCoder = [[CLGeocoder alloc]init];
    //打印当前的经度与纬度
    NSLog(@"%f,%f",currentLocation.coordinate.latitude,currentLocation.coordinate.longitude);
    
//    //反地理编码
//    [geoCoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
//        if (placemarks.count > 0) {
//            CLPlacemark *placeMark = placemarks[0];
//            currentCity = placeMark.locality;
//            if (!currentCity) {
//                currentCity = @"无法定位当前城市";
//            }
//
//            /*看需求定义一个全局变量来接收赋值*/
//            NSLog(@"----%@",placeMark.country);//当前国家
//            NSLog(@"%@",currentCity);//当前的城市
//            //            NSLog(@"%@",placeMark.subLocality);//当前的位置
//            //            NSLog(@"%@",placeMark.thoroughfare);//当前街道
//            //            NSLog(@"%@",placeMark.name);//具体地址
//
//        }
//    }];
    
}

- (NSString*)getDistance:(YGStadiumModel*)model
{
    CLLocation *orig = [[CLLocation alloc] initWithLatitude:model.latitude  longitude:model.longitude];
    CLLocation* dist = [[CLLocation alloc] initWithLatitude:currentLocation.coordinate.latitude longitude:currentLocation.coordinate.longitude];

    CLLocationDistance kilometers = [orig distanceFromLocation:dist]/1000;
    NSString *distance = [NSString stringWithFormat:@"%zd",kilometers];
    NSLog(@"距离:%zd",kilometers);
    return distance;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
