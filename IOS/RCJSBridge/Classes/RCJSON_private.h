//
//  RCJSON_private.h
//  RCJSBridgeDemo1
//
//  Created by 刘立新 on 2019/2/18.
//  Copyright © 2019年 刘立新. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray(RCJSONSerializingPrivate)
- (NSString*)rc_JSONString;
@end

@interface NSDictionary (RCJSONSerializingPrivate)
- (NSString*)rc_JSONString;
@end

@interface NSString (RCJSONSerializingPrivate)
- (id)rc_JSONObject;
- (id)rc_JSONFragment;
@end
