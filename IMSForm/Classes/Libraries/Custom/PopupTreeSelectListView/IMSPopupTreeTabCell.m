//
//  IMSPopupTreeTabCell.m
//  IMSForm
//
//  Created by IMS_Mac on 2021/1/13.
//

#import "IMSPopupTreeTabCell.h"


@implementation IMSPopupTreeTabCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.textLabel.font = [UIFont systemFontOfSize:14];
        self.textLabel.numberOfLines = 0;
    }
    return self;
}

- (void)setupData:(IMSFormSelect *)model andIsLast:(BOOL)isLast {
    if (isLast) {
        self.accessoryType = UITableViewCellAccessoryNone;
    }else {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    self.textLabel.text = model.value;
    self.textLabel.textColor = model.selected ? IMS_HEXCOLOR(0xFFC24A) : [UIColor blackColor];
}

@end
