//
//  YGStadiumViewController.m
//  YoGa
//
//  Created by 罗琰 on 2018/8/1.
//  Copyright © 2018年 YugaLian. All rights reserved.
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
        _headView.image = [UIImage imageNamed:@"banner"];
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
    NSLog(@"loadStadiumsData");
    [YGStadiumModel getStadiumListsByName:nil pageSize:10 pageIndex:self.pageIndex*10 target:self success:^(StatusModel *data) {
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

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}

- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
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
}

#pragma mark 定位成功后则执行此代理方法
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
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
}

- (NSString*)getDistance:(YGStadiumModel*)model
{
    CLLocation *orig = [[CLLocation alloc] initWithLatitude:model.latitude  longitude:model.longitude];
    CLLocation* dist = [[CLLocation alloc] initWithLatitude:currentLocation.coordinate.latitude longitude:currentLocation.coordinate.longitude];

    CLLocationDistance meters = [orig distanceFromLocation:dist];
    NSString *distance = [NSString stringWithFormat:@"%.0f",meters];
    NSString *distanceDes = [self getAboutDistance:meters];
    NSLog(@"距离:%@,描述：%@",distance,distanceDes);
    return distanceDes;
}

- (NSString*)getAboutDistance:(CLLocationDistance)distance
{
    NSString *ret = @"";
    //转为为米
    if (distance <= 100) {
        ret = [NSString stringWithFormat:@"%.0fm",distance];
    } else if (distance > 100 && distance <= 500) {
        ret = @"< 500m";
    } else if (distance > 500 && distance <= 1000) {
        ret = @"< 1km";
    } else {
        ret = @"> 1km";
    }
    return ret;
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
