//
//  GenerateTable_M.m
//  AutoCoding_For_Mac
//
//  Created by Rich on 16/1/28.
//  Copyright © 2016年 Rich. All rights reserved.
//

#import "GenerateTable_M.h"
#import "NSString+LionExtension.h"
#import "GenerateTable_VC.h"
#import "GenerateTable_View.h"
#import "GenerateTable_Cell.h"
#import "Cus_Generate_Model.h"

@implementation GenerateTable_M

+ (id)sharedInstance
{
    static dispatch_once_t once;
    static GenerateTable_M *sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

+ (NSString*)createTable_M_WithName:(NSString*)name andType:(NSInteger)type
{
    NSMutableString *code = [NSMutableString string];
    [self outputHeader:code];
    
    switch (type) {
        case 0:
            return [self createTableVC_M_WithName:name andCode:code];
            
            break;
        case 1:
            return [self createTableView_M_WithName:name andCode:code];
            
            break;
        case 2:
            return [self createTableCell_M_WithName:name andCode:code];
            
            break;
        case 3:
            //            return [self createTheme_M_WithName:name andCode:code];
            
            break;
        case 4:
            return [self createTableCell_Categry_M_With:name andCode:code];
            
            break;
            
        default:
            break;
    }
    return nil;
    
}

#pragma mark create_M

+ (NSString*)createTableVC_M_WithName:(NSString*)name andCode:(NSString*)code
{
    //头文件
    code.LINE( @"\n#import \"FC%@VC.h\"" ,name);
    code.LINE( @"#import \"%@View.h\"" ,name);
    code.LINE( @"#import \"UserService.h\"" );
    code.LINE( @"#import \"ProjectService.h\"" );
    code.LINE( @"#import \"FCRenewalRemindVC.h\"" );
    code.LINE( @"//#import \"%@Model.h\"//需要使用model的自定义",name );
    code.LINE( @"#import \"RenewalProListModel.h\"//暂时写死model" );
    
    code.LINE( @"\n#define  DATA_LIST  @\"dataListArray\"" );
    //属性
    code.LINE( @"\n@interface FC%@VC()<%@ViewDelegate>",name,name );
    code.LINE( @"\n@property(nonatomic, strong) %@View *listView;",name );
    code.LINE( @"@property(nonatomic, strong) NSArray *dataListArray;" );
    code.LINE( @"@property(nonatomic, assign) BOOL isNeedRefresh;" );
    code.LINE( @"@property(nonatomic, assign) NSInteger vcType;" );

    NSDictionary *propertiesDict = [self getProperties_VC_m];
    NSArray *propertyKeys = [propertiesDict allKeys];
    for (NSString *key in propertyKeys)//key是属性名
    {
        NSString *type = [propertiesDict valueForKey:key];
        if ([type isEqualToString:@"NSInteger"] || [type isEqualToString:@"CGFloat"] || [type isEqualToString:@"BOOL"] )
        {
            code.LINE( @"@property(nonatomic, assign) %@ %@;",type,key );
        }
        else
        {
            code.LINE( @"@property(nonatomic, strong) %@ *%@;",[propertiesDict valueForKey:key],key );
        }
        
        
        
    }
    
    code.LINE( @"\n\n@end" );
    
    
    //方法
    [GenerateTable_VC createMethods_M:code proName:name];
    
    return code;
    
}

+ (NSString*)createTableView_M_WithName:(NSString*)name andCode:(NSString*)code
{
    //头文件
    code.LINE( @"\n#import \"%@View.h\"" ,name);
    code.LINE( @"\n#import \"%@Cell.h\"" ,name);
    code.LINE( @"#import \"UIViewExt.h\"" );
    code.LINE( @"#import \"FontConfig.h\"" );
    code.LINE( @"#import \"ColorConfig.h\"" );
    code.LINE( @"#import \"RefreshTableView.h\"" );
    code.LINE( @"#import \"FilterView.h\"" );
    code.LINE( @"#import \"ArrayDataSource.h\"" );
    code.LINE( @"#import \"ProjectCell+Configure.h\"" );
    code.LINE( @"#import \"ThemeManager.h\"");
    code.LINE( @"#import \"%@ThemeVO.h\"",name);
    code.LINE( @"#import \"%@Cell+Config.h\"",name);
    
    //属性
    code.LINE( @"#define LABEL_CONDITION_TAG 200");
    code.LINE( @"\n\n@interface %@View () <UIGestureRecognizerDelegate,UITableViewDelegate,RefreshTableViewDelegate,FilterViewDelegate,%@CellDelegate> ",name,name );
//    code.LINE( @"@property(nonatomic,strong) %@ThemeVO *themeVO;",name);
    code.LINE( @"@property(nonatomic,strong) UIView *topView;");
    code.LINE( @"@property(nonatomic,strong) RefreshTableView *tableView;");
    code.LINE( @"@property(nonatomic,strong) ArrayDataSource *dataSource;");
    code.LINE( @"@property(nonatomic,strong) NSArray *conditionArray;");
    code.LINE( @"@property(nonatomic,assign) NSInteger choosedRow;");
    code.LINE( @"@property(nonatomic,strong) %@ThemeVO *themeVO;",name);
    code.LINE( @"\n\n@end\n" );
    //方法
    [GenerateTable_View createMethods:code proName:name];
    
    
    return code;
}

+ (NSString*)createTableCell_M_WithName:(NSString*)name andCode:(NSString*)code
{
    //头文件
    code.LINE( @"\n#import \"%@Cell.h\"",name);
    code.LINE( @"#import \"FontConfig.h\"");
    code.LINE( @"#import \"UIViewExt.h\"");
    code.LINE( @"#import \"NewControls.h\"");
    code.LINE( @"#import \"HorizonLineView.h\"");
    code.LINE( @"#import \"RectProgessView.h\"");
    code.LINE( @"#import \"ThemeManager.h\"");
    code.LINE( @"" );
    
    //方法
    [GenerateTable_Cell createMethods:code proName:name];
    
    return code;

}

+ (NSString*)createTableCell_Categry_M_With:(NSString*)name andCode:(NSString*)code//cell categry
{

    code.LINE( @"#import \"%@Cell+Config.h\"",name);
    code.LINE( nil );
    code.LINE( @"@implementation %@Cell (Config)",name);
    code.LINE( nil );
    code.LINE( @"- (void)configure:(RenewalProModel*)dataObject");//这里的model暂时写死
    code.LINE( @"{");
    code.LINE( @"    self.deadLine = dataObject.holdDeadLine;");
    code.LINE( @"    switch (dataObject.status) {");
    code.LINE( @"        case 0:");
    code.LINE( @"            self.chooseType = @\"处理中\";");
    code.LINE( @"            self.remindTitle = @\"续期提示\";");
    code.LINE( @"            self.chooseTypeImg = [UIImage imageNamed:@\"cm_cancel\"];");
    code.LINE( @"            break;");
    code.LINE( @"        case 1:");
    code.LINE( @"            self.chooseType = @\"已选择续期\";");
    code.LINE( @"            self.remindTitle = @\"续期提示\";");
    code.LINE( @"            self.chooseTypeImg = nil;");
    code.LINE( @"            break;");
    code.LINE( @"        case 2:");
    code.LINE( @"            self.chooseType = @\"已选择转让\";");
    code.LINE( @"            self.remindTitle = @\"转让提示\";");
    code.LINE( @"            self.chooseTypeImg = nil;");
    code.LINE( @"            break;");
    code.LINE( @"        default:");
    code.LINE( @"            break;");
    code.LINE( @"    }");
    code.LINE( @"    self.proTitle = dataObject.projectName;");
    code.LINE( @"    self.deadLine = dataObject.holdDeadLine;");
    code.LINE( @"}");
    code.LINE( @"\n\n@end\n");
    
    return code;
    
}

#pragma mark -getCustomData

+(NSDictionary*)getProperties_VC_h
{
    Cus_Generate_Model *model = [Cus_Generate_Model shareInstance];
    return model.vc_h_Properties;
    
}

+(NSDictionary*)getProperties_VC_m
{
    Cus_Generate_Model *model = [Cus_Generate_Model shareInstance];
    return model.vc_m_Properties;
    
}

+ (void)outputHeader:(NSMutableString *)code//头部 title author date
{
    NSString *title;
    NSString *author;
    code.LINE( @"// title:  %@", title ? title : @"" );
    code.LINE( @"// author: %@", author ? author : @"unknown" );
    code.LINE( @"// date:   %@", [NSDate date] );
    code.LINE( @"//" );
    code.LINE( nil );
}


@end
