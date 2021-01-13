//
//  IMSFormFileCell.h
//  IMSForm
//
//  Created by cjf on 7/1/2021.
//

#import <IMSForm/IMSFormTableViewCell.h>
#import <IMSForm/IMSFilePicker.h>

NS_ASSUME_NONNULL_BEGIN

@interface IMSFormFileCell : IMSFormTableViewCell

/**
 数据模型的参数说明
 
 @@param value 文件列表，e.g. [{"idField":"1234","name":"filename","url":"http://www.baidu.com/xxx/filename.pdf","ext":"reserved text"}]
 */

@property (strong, nonatomic) UIButton *addButton; /**< <#property#> */
@property (strong, nonatomic) UITableView *listTableView; /**< <#property#> */
@property (strong, nonatomic) IMSFilePicker *filePicker; /**< 文件管理器 */

@end

NS_ASSUME_NONNULL_END
