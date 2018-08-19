//
//  YGSelfInfoViewController.m
//  YoGa
//
//  Created by 罗琰 on 2018/8/12.
//  Copyright © 2018年 QinYoga. All rights reserved.
//

#import "YGSelfInfoViewController.h"

@interface YGSelfInfoViewController ()<UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSArray     *data;
@end

@implementation YGSelfInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSubView];
    // Do any additional setup after loading the view.
}

- (void)loadSubView
{
    self.title = @"个人信息";
    self.view.backgroundColor = UIColorHex(0xffffff);
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStyleGrouped];
    self.tableView.backgroundColor = UIColorHex(0xffffff);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView setSeparatorColor:UIColorHex(0xeeeeee)];
    self.tableView.tableFooterView = [UIView new];
    [self.view addSubview:self.tableView];
    
    self.data = @[@[@"头像",
                    @"名字",
                    @"性别",
                    @"电话"
                    ]];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 100)];
    UIButton *btnLoginOut = [UIButton buttonWithType:UIButtonTypeCustom];
    btnLoginOut.frame = CGRectMake(15, 40, kScreenWidth-15*2, 45);
    [btnLoginOut setTitle:@"退出" forState:UIControlStateNormal];
    btnLoginOut.titleLabel.font = [UIFont systemFontOfSize:14];
    [btnLoginOut setTitleColor:UIColorHex(0x121212) forState:UIControlStateNormal];
    btnLoginOut.layer.borderColor = UIColorHex(0x121212).CGColor;
    btnLoginOut.layer.borderWidth = 1;
    btnLoginOut.layer.cornerRadius = 22.5;
    btnLoginOut.layer.masksToBounds = YES;
    [footerView addSubview:btnLoginOut];
    [btnLoginOut addTarget:self action:@selector(loginOut) forControlEvents:UIControlEventTouchUpInside];
    return footerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 100;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.data.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return ((NSArray*)self.data[section]).count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
        cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"list_ic_back"]];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.textLabel.textColor = UIColorHex(0x121212);
        cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
        cell.detailTextLabel.textColor = UIColorHex(0x909090);
        
        UIImageView *image = [UIImageView new];
        image.backgroundColor = UIColorHex(0xf4f4f4);
        image.contentMode = UIViewContentModeScaleAspectFill;
        image.tag = 100;
        [cell.contentView addSubview:image];
        
        [image mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(cell.contentView.mas_centerY);
            make.right.mas_equalTo(-10);
            make.size.mas_equalTo(CGSizeMake(40, 40));
        }];
    }
    
    if (indexPath.section == 0) {
        cell.textLabel.text = self.data[indexPath.section][indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"list_ic_back"]];
        
        if (indexPath.row == 0) {
            UIImageView *imageView = [cell.contentView viewWithTag:100];
            imageView.hidden = NO;
            imageView.layer.cornerRadius = 20;
            imageView.layer.masksToBounds = YES;
            [imageView sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"customer_details_face_man"]];
            
            cell.detailTextLabel.text = nil;
        } else {
            UIImageView *imageView = [cell.contentView viewWithTag:100];
            imageView.hidden = YES;
            NSArray *dataValues = @[@"roger",@"男",@"18677778888",];
            cell.detailTextLabel.text = dataValues[indexPath.row-1];
        }
        
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 15, 0, 0)];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return 65;
        }
    }
    return 45;
}

- (void)loginOut
{
    [UIAlertView alertWithCallBackBlock:^(NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            [YGUserInfo shareUserInfo].token = nil;
            [[YGUserInfo shareUserInfo] clearUserToken];
            [kAppDelegate authorizeOperation];
        }
    } title:@"温馨提示" message:@"是否要退出登录?" cancelButtonName:@"否" otherButtonTitles:@"是", nil];
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
