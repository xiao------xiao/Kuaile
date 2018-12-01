//
//  ICEPersistent.h
//  hxjj
//
//  Created by ttouch on 15/7/17.
//  Copyright (c) 2015年 ttouch. All rights reserved.
//

#ifndef hxjj_ICEPersistent_h
#define hxjj_ICEPersistent_h

/**
 *	永久存储对象
 *
 *  NSUserDefaults保存的文件在tmp文件夹里
 *
 *	@param	object      需存储的对象
 *	@param	key         对应的key
 */

#define DEF_PERSISTENT_SET_OBJECT(object, key)                          \
({                                                                      \
NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];       \
[defaults setObject:object forKey:key];                                 \
[defaults synchronize];                                                 \
})

/**
 
 *	取出永久存储的对象
 *
 *	@param	key     所需对象对应的key
 *	@return	key     所对应的对象
 */
#define DEF_PERSISTENT_GET_OBJECT(key)  [[NSUserDefaults standardUserDefaults] objectForKey:key]


/**
 *  清除 NSUserDefaults 保存的所有数据
 */
#define DEF_PERSISTENT_REMOVE_ALLDATA   [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:[[NSBundle mainBundle] bundleIdentifier]]


/**
 *  清除 NSUserDefaults 保存的指定数据
 */
#define DEF_PERSISTENT_REMOVE(_key)                                         \
({                                                                          \
NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];       \
[defaults removeObjectForKey:_key];                                     \
[defaults synchronize];                                                 \
})

#endif
