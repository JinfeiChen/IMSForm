//
//  IMSFormMapCell.m
//  IMSForm
//
//  Created by cjf on 26/2/2021.
//

#import "IMSFormMapCell.h"

#import <CoreLocation/CoreLocation.h>  //用于地理定位
#import <MapKit/MapKit.h>

#import <IMSForm/IMSPopupSingleSelectListView.h>

@interface IMSFormMapCell () <UITextFieldDelegate, CLLocationManagerDelegate>

@property (strong, nonatomic) IMSPopupSingleSelectListView *singleSelectListView; /**< <#property#> */

@property (strong, nonatomic) MKMapView *mapView; /**< <#property#> */
@property (strong, nonatomic) UITextField *textField; /**< <#property#> */
@property (strong, nonatomic) UIButton *searchButton; /**< <#property#> */

@property (strong, nonatomic) CLLocationManager *locationManager; /**< <#property#> */
@property (strong, nonatomic) MKLocalSearch *localSearch; /**< <#property#> */
@property (assign, nonatomic) CLLocationCoordinate2D coords;
@property (strong, nonatomic) MKLocalSearchRequest *localSearchRequest; /**< <#property#> */

@property (copy, nonatomic) void(^localSearchCompletion)(NSArray *dataArray, NSError *error); /**< <#property#> */

@end

@implementation IMSFormMapCell

@synthesize model = _model;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self buildView];
        
        __weak __typeof__(self) weakSelf = self;
        [[NSNotificationCenter defaultCenter] addObserverForName:UITextFieldTextDidEndEditingNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *_Nonnull note) {
            __typeof__(self) strongSelf = weakSelf;
            if (note.object == strongSelf.textField) {
                // update valueList
                if (strongSelf.model.valueList && strongSelf.model.valueList.count > 0) {
                    IMSFormSelect *selectedModel = [IMSFormSelect yy_modelWithDictionary:self.model.valueList.firstObject];
                    NSString *selectedText = selectedModel.label ? : (selectedModel.value ? : @"");
                    if (![strongSelf.textField.text isEqualToString:selectedText]) {
                        self.model.valueList = [NSMutableArray array];
                    }
                }
            }
        }];
    }
    return self;
}

#pragma mark - UI

- (void)buildView
{
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.infoLabel];
    [self.contentView addSubview:self.bodyView];
    [self.bodyView addSubview:self.searchButton];
    [self.bodyView addSubview:self.textField];
    [self.contentView addSubview:self.mapView];
    
    [self updateUI];
}

- (void)updateUI
{
    self.contentView.backgroundColor = IMS_HEXCOLOR([NSString intRGBWithHex:self.model.cpnStyle.backgroundHexColor]);
    
    self.titleLabel.textColor = IMS_HEXCOLOR([NSString intRGBWithHex:self.model.cpnStyle.titleHexColor]);
    self.titleLabel.font = [UIFont systemFontOfSize:self.model.cpnStyle.titleFontSize weight:UIFontWeightMedium];
    
    self.infoLabel.font = [UIFont systemFontOfSize:self.model.cpnStyle.infoFontSize weight:UIFontWeightRegular];
    self.infoLabel.textColor = IMS_HEXCOLOR([NSString intRGBWithHex:self.model.cpnStyle.infoHexColor]);
    
    self.bodyView.userInteractionEnabled = self.model.isEditable;
    self.bodyView.backgroundColor = self.model.isEditable ? kEnabledCellBodyBackgroundColor : kDisabledCellBodyBackgroundColor;
    self.textField.backgroundColor = self.bodyView.backgroundColor;
    self.searchButton.enabled = self.model.isEditable;
    
    self.searchButton.backgroundColor = IMS_HEXCOLOR([NSString intRGBWithHex:self.model.cpnStyle.tintHexColor]);
    
    CGFloat spacing = self.model.cpnStyle.spacing;
    // 只支持竖向布局
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView).mas_offset(self.model.cpnStyle.contentInset.top);
        make.left.mas_equalTo(self.contentView).mas_offset(self.model.cpnStyle.contentInset.left);
        make.right.mas_equalTo(self.contentView).mas_offset(-self.model.cpnStyle.contentInset.right);
    }];
    [self.bodyView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLabel.mas_bottom).mas_offset(spacing);
        make.left.equalTo(self.contentView).offset(self.model.cpnStyle.contentInset.left);
        make.right.equalTo(self.contentView).offset(-self.model.cpnStyle.contentInset.right);
    }];
    CGFloat mapHeight = (IMS_SCREEN_WIDTH - self.model.cpnStyle.contentInset.left - self.model.cpnStyle.contentInset.right) * 2 / 3;
    [self.mapView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.bodyView.mas_bottom).mas_offset(5);
        make.left.right.mas_equalTo(self.bodyView);
        make.height.mas_equalTo(mapHeight);
    }];
    [self.infoLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mapView.mas_bottom).mas_offset(5);
        make.left.right.mas_equalTo(self.bodyView);
        make.bottom.mas_equalTo(self.contentView).mas_offset(-self.model.cpnStyle.contentInset.bottom);
    }];
    
    [self.searchButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.mas_equalTo(self.bodyView).mas_offset(0);
        make.width.mas_equalTo(60);
    }];
    [self.textField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.bodyView).mas_offset(10);
        make.top.bottom.mas_equalTo(self.bodyView).mas_offset(0);
        make.right.mas_equalTo(self.searchButton.mas_left).mas_offset(-10);
        make.height.mas_equalTo(kIMSFormDefaultHeight);
    }];
}

#pragma mark - Public Methods

- (void)setModel:(IMSFormMapModel *)model form:(nonnull IMSFormManager *)form
{
    [super setModel:model form:form];
    
    [self updateUI];
    
    [self clearReuseData];
    [self setTitle:model.title required:model.isRequired];

    self.infoLabel.text = model.info;
    
    // update default value
    
}

#pragma mark - Private Methods

// 清除重用数据
- (void)clearReuseData
{
    self.titleLabel.text = @"";
    self.infoLabel.text = @"";
    self.textField.text = @"";
    self.textField.placeholder = @"Please enter".ims_localizable;
}

- (IMSPopupSingleSelectListViewCellType)cellTypeWithSelectItemType:(NSString *)selectItemType
{
    if ([selectItemType isEqualToString:IMSFormSelectItemType_Custom]) {
        return IMSPopupSingleSelectListViewCellType_Custom;
    }
    else {
        return IMSPopupSingleSelectListViewCellType_Location;
    }
}

#pragma mark - Map

- (void)locan
{
    //定位管理器
    _locationManager = [[CLLocationManager alloc] init];

    if (![CLLocationManager locationServicesEnabled]) {
        NSLog(@"定位服务当前可能尚未打开，请设置打开！");
        [IMSDropHUD showAlertWithType:IMSFormMessageType_Error message:@"Location services may not be turned on at this time".ims_localizable];
        return;
    }

    //如果没有授权则请求用户授权
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
        [_locationManager requestWhenInUseAuthorization];
    } else {
        //设置代理
        _locationManager.delegate = self;
        //设置定位精度
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        [_locationManager requestAlwaysAuthorization];
        //启动跟踪定位
        [_locationManager startUpdatingLocation];
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *currLocation = [locations lastObject];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];

    [_locationManager stopUpdatingLocation];

    [geocoder reverseGeocodeLocation:currLocation completionHandler:^(NSArray *_Nullable placemarks, NSError *_Nullable error) {
        if (error) {
            NSLog(@"查询失败");
            [IMSDropHUD showAlertWithType:IMSFormMessageType_Error message:@"Search error".ims_localizable];
        } else if (placemarks && placemarks.count > 0) {
            [self issueLocalSearchLookup:self.textField.text usingPlacemarksArray:placemarks];
        }
    }];
    
    // MARK: 返回我的位置 方式二
    MKCoordinateRegion region =  MKCoordinateRegionMake(self.mapView.userLocation.location.coordinate, self.mapView.region.span);
    [self.mapView setRegion:region animated:YES];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error;
{
    [IMSDropHUD showAlertWithType:IMSFormMessageType_Error message:@"Locating error".ims_localizable];
    self.searchButton.enabled = YES;
}

- (void)issueLocalSearchLookup:(NSString *)searchString usingPlacemarksArray:(NSArray *)placemarks
{
    // Search 0.250km from point for stores.
    CLPlacemark *placemark = placemarks[0];
    CLLocation *location = placemark.location;
    self.coords = location.coordinate;

    // Set the size (local/span) of the region (address, w/e) we want to get search results for.
    MKCoordinateSpan span = MKCoordinateSpanMake(0.6250, 0.6250);
    MKCoordinateRegion region = MKCoordinateRegionMake(self.coords, span);
    [self.mapView setRegion:region animated:NO];

    // Create the search request
    self.localSearchRequest = [[MKLocalSearchRequest alloc] init];
    self.localSearchRequest.region = region;
    self.localSearchRequest.naturalLanguageQuery = searchString;

    // Perform the search request...
    self.localSearch = [[MKLocalSearch alloc] initWithRequest:self.localSearchRequest];

    [self.localSearch startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error) {
        
        self.searchButton.enabled = YES;
        
        if (error) {
            NSLog(@"查询无结果");
            if (self.localSearchCompletion) {
                self.localSearchCompletion(nil, [NSError errorWithDomain:@"IMSFormMapLocalSearch_Error" code:-999 userInfo:@{ NSLocalizedDescriptionKey : error.localizedDescription }]);
            }
            return;
        } else {
            NSMutableArray *resultArray = [NSMutableArray array];
            // We are here because we have data!  Yay..  a whole 10 records of it too *flex*
            // Do whatever with it here...
            NSLog(@"Results: %@", [response mapItems]);
            for (MKMapItem *mapItem in response.mapItems) {
                // Show pins, pix, w/e...
                // Other properties includes: phoneNumber, placemark, url, etc.
                // More info here: https://developer.apple.com/library/ios/#documentation/MapKit/Reference/MKLocalSearch/Reference/Reference.html#//apple_ref/doc/uid/TP40012893
                NSLog(@"Name:%@ Phone:%@ URL:%@", [mapItem name], [mapItem phoneNumber], [mapItem url]);
                NSLog(@"Placemark: %@", [mapItem placemark]);
                MKPlacemark *placemark = [mapItem placemark];
                NSLog(@"Placemark Address: %@", [placemark addressDictionary]);
                MKCoordinateRegion boundingRegion = [response boundingRegion];
                NSLog(@"Bounds: %f %f", boundingRegion.span.latitudeDelta, boundingRegion.span.longitudeDelta);
                
                NSMutableDictionary *mDict = [NSMutableDictionary dictionaryWithDictionary:[placemark addressDictionary]];
                [mDict setValue:[NSString stringWithFormat:@"%@", [mapItem phoneNumber]?:@""] forKey:@"Phone"];
                [mDict setValue:[NSString stringWithFormat:@"%@", [mapItem url]?:@""] forKey:@"URL"];
                [resultArray addObject:mDict];
            }
            MKCoordinateSpan span = MKCoordinateSpanMake(0.2, 0.2);
            MKCoordinateRegion region = MKCoordinateRegionMake(self.coords, span);
            [self.mapView setRegion:region animated:NO];
            
            if (self.localSearchCompletion) {
                self.localSearchCompletion(resultArray, nil);
            }
        }
    }];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (!self.model.isEditable) {
        return NO;
    }
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField reason:(UITextFieldDidEndEditingReason)reason
{
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    [self searchButtonAction:self.searchButton];
    
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    // clear valueList
    self.model.valueList = [NSMutableArray array];
    
    return YES;
}

#pragma mark - Actions

- (void)searchButtonAction:(UIButton *)sender
{
    [self.textField endEditing:YES];
    
    if (self.textField.text.length <= 0) {
        NSLog(@"please input some text first");
        [IMSDropHUD showAlertWithType:IMSFormMessageType_Warning message:@"Please input some text first"];
        return;
    }
    
    if (self.form) {
        
        self.singleSelectListView = [[IMSPopupSingleSelectListView alloc] initWithFrame:CGRectZero];
        self.singleSelectListView.cellType = IMSPopupSingleSelectListViewCellType_Location;
        
        @weakify(self);
        self.localSearchCompletion = ^(NSArray *dataArray, NSError *error) {
            @strongify(self);
            
            NSLog(@"search result: %@", dataArray);
            // MARK: 注意 - custom的selectListView，为适应不同的数据模型拓展，dataArray需要在外面转换 [IMSFormSelect, IMSChildFormSelect, ...] 才能回传，否则无法显示
            [self.singleSelectListView setDataArray:dataArray type:self.singleSelectListView.cellType];
            
            [self.singleSelectListView setDidSelectedBlock:^(NSArray * _Nonnull dataArray, IMSFormSelect * _Nonnull selectedModel) {
                @strongify(self);
                IMSPopupSingleSelectLocationModel *newSelectedModel = (IMSPopupSingleSelectLocationModel *)selectedModel;
                // update value
                self.textField.text = [NSString stringWithFormat:@"%@", newSelectedModel.FormattedAddressLines ? newSelectedModel.FormattedAddressLines.firstObject : @"N/A"];
                // update model valueList
                self.model.valueList = selectedModel.isSelected ? [NSMutableArray arrayWithArray:@[[selectedModel yy_modelToJSONObject]]] : [NSMutableArray array];
                
                // call back
                if (self.didUpdateFormModelBlock) {
                    self.didUpdateFormModelBlock(self, self.model, nil);
                }
                
            }];
            
            self.singleSelectListView.tintColor = IMS_HEXCOLOR([NSString intRGBWithHex:self.model.cpnStyle.tintHexColor]);
            
            [self.singleSelectListView showView];
            
        };
        
        // 开始搜索
        [self locan];
        
        self.searchButton.enabled = NO;
        
    }
}

#pragma mark - Getters

- (MKMapView *)mapView
{
    if (!_mapView) {
        _mapView = [[MKMapView alloc] initWithFrame:CGRectZero];
        //显示指南针
        _mapView.showsCompass = YES;
        //显示比例尺
        _mapView.showsScale = YES;
        //显示交通状况
        _mapView.showsTraffic = YES;
        //显示建筑物
        _mapView.showsBuildings = YES;
        //显示用户所在的位置
        _mapView.showsUserLocation = YES;
        //显示感兴趣的东西
        _mapView.showsPointsOfInterest = YES;
    }
    return _mapView;
}

- (UITextField *)textField
{
    if (!_textField) {
        _textField = [[UITextField alloc] init];
        _textField.placeholder = @"Please enter";
        _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _textField.keyboardType = UIKeyboardTypeDefault;
        _textField.delegate = self;
        _textField.font = [UIFont systemFontOfSize:12];
        _textField.returnKeyType = UIReturnKeySearch;
    }
    return _textField;
}

- (UIButton *)searchButton
{
    if (!_searchButton) {
        UIButton *rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 40)];
        [rightButton addTarget:self action:@selector(searchButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [rightButton setImage:[UIImage bundleImageWithNamed:@"search"] forState:UIControlStateNormal];
        _searchButton = rightButton;
    }
    return _searchButton;
}

//- (IMSPopupSingleSelectListView *)singleSelectListView {
//    if (!_singleSelectListView) {
//        _singleSelectListView = [[IMSPopupSingleSelectListView alloc] initWithFrame:CGRectZero];
//    }
//    return _singleSelectListView;
//}

@end
