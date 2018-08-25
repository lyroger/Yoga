//
//  YGSelfInfoViewController.m
//  YoGa
//
//  Created by 罗琰 on 2018/8/12.
//  Copyright © 2018年 QinYoga. All rights reserved.
//

#import "YGSelfInfoViewController.h"
#import "YGEditUserInfoVC.h"
#import "HAlertController.h"
#import "MicAssistant.h"
#import "TZImagePickerController.h"
#import "YGImagePickerController.h"

@interface YGSelfInfoViewController ()<UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate, UIImagePickerControllerDelegate,TZImagePickerControllerDelegate,UIActionSheetDelegate>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSArray     *data;
@property (nonatomic, strong) UIImagePickerController *imagePickerVc;
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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"buttonIndex = %zd",buttonIndex);
    if (buttonIndex == 0 || buttonIndex==1) {
        [YGUserInfo updateUserInfoUserName:nil gender:buttonIndex headImage:nil target:self success:^(StatusModel *data) {
            if (data.code == 0) {
                [YGUserInfo shareUserInfo].gender = buttonIndex;
                [[YGUserInfo shareUserInfo] updateUserInfoToDB];
                [self.tableView reloadData];
            }
        }];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        // 上传头像
        @weakify(self);
        HAlertController *alertController = [HAlertController alertControllerWithTitle:nil message:nil cannelButton:@"取消" otherButtons:@[@"从手机相册选取",@"拍照"] type:HAlertControllerTypeCustomValue1 complete:^(NSUInteger buttonIndex, HAlertController *actionController) {
            @strongify(self);
            if (buttonIndex == 2) {
                // 拍照
                [self takePhoto];
            } else if (buttonIndex == 1) {
                // 从相册选择
                [self pushImagePickerController];
            }
        }];
        NSArray *array = [alertController buttonArrayWithCustomValue1];
        [array[0] setTitleColor:UIColorHex(0x333333) forState:UIControlStateNormal];
        [array[1] setTitleColor:UIColorHex(0x333333) forState:UIControlStateNormal];
        [array[2] setTitleColor:UIColorHex(0x999999) forState:UIControlStateNormal];
        [alertController showInController:self];
    }else if (indexPath.row == 1) {
        YGEditUserInfoVC *vc = [[YGEditUserInfoVC alloc] init];
        vc.titleName = @"名称";
        [self.navigationController pushViewController:vc animated:YES];
    } else if (indexPath.row == 2) {
        UIActionSheet *myActionSheet = [[UIActionSheet alloc]initWithTitle:nil
                                                                  delegate:self
                                                         cancelButtonTitle:@"取消"
                                                    destructiveButtonTitle:nil
                                                         otherButtonTitles:@"男",@"女",nil];



        [myActionSheet showInView:self.view];
    }
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
            [imageView sd_setImageWithURL:[NSURL URLWithString:[YGUserInfo shareUserInfo].headImageUrl] placeholderImage:[UIImage imageNamed:@"personal_ic_pic"]];
            
            cell.detailTextLabel.text = nil;
        } else {
            UIImageView *imageView = [cell.contentView viewWithTag:100];
            imageView.hidden = YES;
            NSString *name = [YGUserInfo shareUserInfo].nickName?[YGUserInfo shareUserInfo].nickName:@"";
            NSString *gender = [YGUserInfo shareUserInfo].gender==0?@"男":@"女";
            NSString *phone = [YGUserInfo shareUserInfo].phone?[YGUserInfo shareUserInfo].phone:@"";
            NSArray *dataValues = @[name,gender,phone];
            cell.detailTextLabel.text = dataValues[indexPath.row-1];

            if (indexPath.row == 3) {
                cell.accessoryType = UITableViewCellAccessoryNone;
                cell.accessoryView = nil;
            }
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
            [YGUserInfo logOutRequestTarget:self success:^(StatusModel *data) {
                
            }];

            [YGUserInfo shareUserInfo].token = nil;
            [[YGUserInfo shareUserInfo] updateUserInfoToDB];
            [HUDManager showHUDWithMessage:@"退出中..."];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [HUDManager hiddenHUD];
                NSLog(@"重新鉴权登录页");
                [kAppDelegate authorizeOperation];
            });
        }
    } title:@"温馨提示" message:@"是否要退出登录?" cancelButtonName:@"否" otherButtonTitles:@"是", nil];
}

#pragma mark - UIImagePickerController
- (UIImagePickerController *)imagePickerVc {
    if (_imagePickerVc == nil) {
        _imagePickerVc = [[UIImagePickerController alloc] init];
        _imagePickerVc.delegate = self;
        _imagePickerVc.allowsEditing = YES;
    }
    return _imagePickerVc;
}

#pragma mark - TZImagePickerController
- (void)pushImagePickerController {
    //    if (![[MicAssistant sharedInstance] checkAccessPermissions:NoAccessPhotoType]) {
    //        return;
    //    }

    @weakify(self);
    [[MicAssistant sharedInstance] checkPhotoServiceOnCompletion:^(BOOL isPermision, BOOL isFirstAsked) {
        @strongify(self);
        if (isPermision) {
            YGImagePickerController *imagePickerVc = [[YGImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
            imagePickerVc.isSelectOriginalPhoto = NO;
            imagePickerVc.allowTakePicture = NO;
            imagePickerVc.allowPickingVideo = NO;
            imagePickerVc.allowPickingOriginalPhoto = NO;
            imagePickerVc.sortAscendingByModificationDate = YES;
            imagePickerVc.barItemTextColor = UIColorHex(0x333333);
            imagePickerVc.navigationBar.barTintColor = UIColorHex(0x333333);;
            imagePickerVc.navigationBar.tintColor = UIColorHex(0x333333);;
            imagePickerVc.oKButtonTitleColorDisabled = [UIColor lightGrayColor];
            imagePickerVc.oKButtonTitleColorNormal = [UIColor greenColor];
            [self presentViewController:imagePickerVc animated:YES completion:nil];
            [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
                if (photos.count > 0) {
                    [self uploadPhoto:photos[0]];
                }
            }];
        } else {
            [MicAssistant guidUserToSettingsWhenNoAccessRight:NoAccessPhotoType];
        }
    }];

}

- (void)takePhoto {
    if (![[MicAssistant sharedInstance] checkAccessPermissions:NoAccessCamaratype]) {
        return;
    }

    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
        self.imagePickerVc.sourceType = sourceType;
        if(iOS8Later) {
            self.imagePickerVc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        }
        [self.navigationController.tabBarController presentViewController:self.imagePickerVc animated:YES completion:nil];
    } else {
        NSLog(@"模拟器中无法打开照相机,请在真机中使用");
    }
}

#pragma mark- UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    if (image) {
        // 上传头像
        [self uploadPhoto:image];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark- upload
- (void)uploadPhoto:(UIImage *)photo
{
    if (!photo) {
        [HUDManager alertWithTitle:@"上传的头像为空!"];
        return;
    }
    @weakify(self);
    [YGUserInfo updateUserInfoUserName:nil gender:-1 headImage:photo target:self success:^(StatusModel *data) {
        @strongify(self);
        if (data.code == 0) {
            [YGUserInfo shareUserInfo].headImageUrl = [data.originalData objectForKey:@"headerPicture"];
            [[YGUserInfo shareUserInfo] updateUserInfoToDB];
            [self.tableView reloadData];
        }
    }];
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
