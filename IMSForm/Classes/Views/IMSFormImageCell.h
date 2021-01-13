//
//  IMSFormImageCell.h
//  IMSForm
//
//  Created by cjf on 7/1/2021.
//

#import <IMSForm/IMSFormTableViewCell.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CJFFormTBImageUpload001CollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImageView *videoImageView;
@property (nonatomic, strong) UIButton *deleteBtn;
@property (nonatomic, strong) UILabel *gifLable;
@property (nonatomic, assign) NSInteger row;
@property (nonatomic, strong) id asset;

- (UIView *)snapshotView;

@property (nonatomic, strong) NSURL * _Nullable videoURL;
@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) AVPlayerLayer *playerLayer;

@end

@interface IMSFormImageCell : IMSFormTableViewCell

/**
 数据模型的参数说明
 
 @@param value 图片地址列表，e.g. ["http://www.baidu.com/pic/01/01/12313.png"]
 */

@end

NS_ASSUME_NONNULL_END
