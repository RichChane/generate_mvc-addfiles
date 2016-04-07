//
//  Cus_Generate_Model.h
//  Lion
//
//  Created by Rich on 16/2/3.
//  Copyright © 2016年 JoySim. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Cus_Generate_Model : NSObject

@property (nonatomic,strong) NSString* moduleName;
@property (nonatomic,assign) NSInteger generateType;
@property (nonatomic,strong) NSString* outPutPath;
@property (nonatomic,strong) NSString* inputPath;
@property (nonatomic,strong) NSString* inputFile;
@property (nonatomic,strong) NSString* vcName;
@property (nonatomic,strong) NSDictionary* cell_h_Properties;
@property (nonatomic,strong) NSDictionary* cell_m_Properties;
@property (nonatomic,strong) NSDictionary* vc_h_Properties;
@property (nonatomic,strong) NSDictionary* vc_m_Properties;
@property (nonatomic,strong) NSDictionary* table_h_Properties;
@property (nonatomic,strong) NSDictionary* table_m_Properties;
@property (nonatomic,strong) NSDictionary* requestParamter;
@property (nonatomic,strong) NSArray* cellItems;


+ (NSArray*)getCellItems;

+(id)shareInstance;


@end
