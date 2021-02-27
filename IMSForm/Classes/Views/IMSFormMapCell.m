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

// MARK: 自定义大头针
//自定义 LPAnnotation
@interface LPAnnotation : NSObject <MKAnnotation>

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, copy) NSString *icon;

@end

@implementation LPAnnotation

@end

//自定义 LPAnnotationView
@interface LPAnnotationView : MKAnnotationView

@end

@implementation LPAnnotationView

+ (instancetype)annotationViewWithMapView:(MKMapView *)mapView
{
    LPAnnotationView *annotaionView = (LPAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"id"];
    if (!annotaionView) {
        annotaionView = [[LPAnnotationView alloc]initWithAnnotation:nil reuseIdentifier:@"id"];
    }
    return annotaionView;
}

- (id)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithAnnotation:annotation reuseIdentifier:@"id"]) {
        self.canShowCallout = YES;
    }
    return self;
}

- (void)setAnnotation:(LPAnnotation *)annotation
{
    [super setAnnotation:annotation];
    self.image = [UIImage imageNamed:annotation.icon];
}

@end

@interface IMSFormMapCell () <UITextFieldDelegate, CLLocationManagerDelegate, MKMapViewDelegate>

@property (strong, nonatomic) IMSPopupSingleSelectListView *singleSelectListView; /**< <#property#> */

@property (strong, nonatomic) MKMapView *mapView; /**< <#property#> */
@property (strong, nonatomic) UITextField *textField; /**< <#property#> */
@property (strong, nonatomic) UIButton *searchButton; /**< <#property#> */

@property (strong, nonatomic) CLLocationManager *locationManager; /**< <#property#> */
@property (strong, nonatomic) MKLocalSearch *localSearch; /**< <#property#> */
@property (assign, nonatomic) CLLocationCoordinate2D coords;
@property (strong, nonatomic) MKLocalSearchRequest *localSearchRequest; /**< <#property#> */

@property (copy, nonatomic) void (^ localSearchCompletion)(NSArray *dataArray, NSError *error); /**< <#property#> */

@property (strong, nonatomic) NSArray<MKMapItem *> *mapItems;  /**< 临时存储位置探索结果列表 */
@property (strong, nonatomic) MKMapItem *selectedMapItem; /**< 当前选中的位置对象 */
@property (strong, nonatomic) LPAnnotation *annotation; /**< 大头针 */

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
    } else {
        return IMSPopupSingleSelectListViewCellType_Location;
    }
}

// 返回用户当前的位置
- (void)reLocationUserLocation
{
    if (!self.selectedMapItem) {
        MKCoordinateRegion region = MKCoordinateRegionMake(self.mapView.userLocation.location.coordinate, self.mapView.region.span);
        [self.mapView setRegion:region animated:NO];
    }
}

// MARK: 显示位置和显示区域
- (void)locateToLatitude:(CGFloat)JingDu longitude:(CGFloat)WeiDu
{
    // 设置地图中心的经、纬度
    CLLocationCoordinate2D center = { JingDu, WeiDu };
    // 设置地图显示的范围，
    MKCoordinateSpan span;
    // 地图显示范围越小，细节越清楚
    span.latitudeDelta = 0.01;
    span.longitudeDelta = 0.01;
    // 创建MKCoordinateRegion对象，该对象代表了地图的显示中心和显示范围。
    MKCoordinateRegion region = { center, span };
    // 设置当前地图的显示中心和显示范围
    [self.mapView setRegion:region animated:YES];
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
        //设置距离筛选器
        _locationManager.distanceFilter = 1000.0f;
        [_locationManager requestAlwaysAuthorization];
        //启动跟踪定位
        [_locationManager startUpdatingLocation];
    }
}

#pragma mark - CLLocationManagerDelegate

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

    // MARK: 返回我的位置
    [self reLocationUserLocation];
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
//    MKCoordinateSpan span = MKCoordinateSpanMake(0.6250, 0.6250);
//    MKCoordinateRegion region = MKCoordinateRegionMake(self.coords, span);
//    [self.mapView setRegion:region animated:YES];
    MKCoordinateRegion region = MKCoordinateRegionMake(self.mapView.userLocation.location.coordinate, self.mapView.region.span);
//    [self.mapView setRegion:region animated:NO];

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
                self.localSearchCompletion(nil, [NSError errorWithDomain:@"IMSFormMapLocalSearch_Error" code:-999 userInfo:@{ NSLocalizedDescriptionKey: error.localizedDescription }]);
            }
            return;
        } else {
            NSMutableArray *resultArray = [NSMutableArray array];
            // We are here because we have data!  Yay..  a whole 10 records of it too *flex*
            // Do whatever with it here...
            NSLog(@"Results: %@", [response mapItems]);
            self.mapItems = [response mapItems];
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
                NSLog(@"Center: %f %f", boundingRegion.center.latitude, boundingRegion.center.longitude);

                NSMutableDictionary *mDict = [NSMutableDictionary dictionaryWithDictionary:[placemark addressDictionary]];
                [mDict setValue:[NSString stringWithFormat:@"%@", [mapItem phoneNumber] ? : @""] forKey:@"Phone"];
                [mDict setValue:[NSString stringWithFormat:@"%@", [mapItem url] ? : @""] forKey:@"URL"];
                [resultArray addObject:mDict];
            }

            if (self.localSearchCompletion) {
                self.localSearchCompletion(resultArray, nil);
            }
        }
    }];
}

//- (MKAnnotationView *)mapView:(MKMapView *)mV viewForAnnotation:(id )annotation
//{
//    MKPinAnnotationView *pinView = nil;
//    static NSString *defaultPinID = @"com.invasivecode.pin";
//    pinView = (MKPinAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:defaultPinID];
//    if (pinView == nil) {
//        pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:defaultPinID];
//        pinView.pinColor = MKPinAnnotationColorRed;
//        pinView.canShowCallout = YES;
//        pinView.animatesDrop = YES;
//        [self.mapView.userLocation setTitle:@"标题，这里一般放位置名称"];
//        [self.mapView.userLocation setSubtitle:@"副标题，这里一般放位置地址信息"];
//    }
//    return pinView;
//}

#pragma mark - MKMapViewDelegate

- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated
{
    NSLog(@"地图控件的显示区域将要发生改变！");
}

// MKMapViewDelegate协议中的方法，当MKMapView显示区域改变完成时激发该方法
- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    NSLog(@"地图控件的显示区域完成了改变！");
}

// MKMapViewDelegate协议中的方法，当MKMapView开始加载数据时激发该方法
- (void)mapViewWillStartLoadingMap:(MKMapView *)mapView
{
    NSLog(@"地图控件开始加载地图数据！");
}

// MKMapViewDelegate协议中的方法，当MKMapView加载数据完成时激发该方法
- (void)mapViewDidFinishLoadingMap:(MKMapView *)mapView
{
    NSLog(@"地图控件加载地图数据完成！");
}

// MKMapViewDelegate协议中的方法，当MKMapView加载数据失败时激发该方法
- (void)mapViewDidFailLoadingMap:(MKMapView *)mapView
                       withError:(NSError *)error
{
    NSLog(@"地图控件加载地图数据发生错误，错误信息 %@！", error);
}

// MKMapViewDelegate协议中的方法，当MKMapView开始渲染地图时激发该方法
- (void)mapViewWillStartRenderingMap:(MKMapView *)mapView
{
    NSLog(@"地图控件开始渲染地图！");
}

// MKMapViewDelegate协议中的方法，当MKMapView渲染地图完成时激发该方法
- (void)mapViewDidFinishRenderingMap:(MKMapView *)mapView fullyRendered:(BOOL)fullyRendered
{
    NSLog(@"地图控件渲染地图完成！");
    
    
    [self reLocationUserLocation];
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

    // MARK: 返回我的位置
    self.selectedMapItem = nil;
    [self reLocationUserLocation];

    return YES;
}

#pragma mark - Actions

- (void)searchButtonAction:(UIButton *)sender
{
    [self.textField endEditing:YES];

    if (self.textField.text.length <= 0) {
        NSLog(@"please input some text first");
        [IMSDropHUD showAlertWithType:IMSFormMessageType_Warning message:@"Please input some text first"];
        self.selectedMapItem = nil;
        [self reLocationUserLocation];
        return;
    }

    if (self.form) {
        self.singleSelectListView = [[IMSPopupSingleSelectListView alloc] initWithFrame:CGRectZero];
        self.singleSelectListView.cellType = IMSPopupSingleSelectListViewCellType_Location;

        @weakify(self);
        self.localSearchCompletion = ^(NSArray *dataArray, NSError *error) {
            @strongify(self);

            NSLog(@"search result: %@", dataArray);
            
            // 移除大头针
            [self.mapView removeAnnotation:self.annotation];
            
            // MARK: 注意 - custom的selectListView，为适应不同的数据模型拓展，dataArray需要在外面转换 [IMSFormSelect, IMSChildFormSelect, ...] 才能回传，否则无法显示
            [self.singleSelectListView setDataArray:dataArray type:self.singleSelectListView.cellType];

            [self.singleSelectListView setDidSelectedLocationBlock:^(NSArray *_Nonnull dataArray, IMSFormSelect *_Nonnull selectedModel, NSIndexPath *_Nonnull indexPath) {
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

                // MARK: 定位到选中的位置
                MKMapItem *mapItem = [self.mapItems objectAtIndex:indexPath.row];
                self.selectedMapItem = mapItem;
                [self locateToLatitude:mapItem.placemark.location.coordinate.latitude longitude:mapItem.placemark.location.coordinate.longitude];

                // MARK: 放置大头针
                LPAnnotation *ann = [[LPAnnotation alloc] init];
                self.annotation = ann;
                ann.title = mapItem.placemark.name;
                ann.subtitle = self.textField.text;
                ann.coordinate = mapItem.placemark.location.coordinate;
                [self.mapView addAnnotation:ann];
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
        // 设置地图类型
        _mapView.mapType = MKMapTypeStandard;
        // 设置地图可缩放
        _mapView.zoomEnabled = YES;
        // 设置地图可滚动
        _mapView.scrollEnabled = YES;
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
        _mapView.delegate = self;
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
