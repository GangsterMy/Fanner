//
//  CoreDataStack.m
//  Fanner
//
//  Created by 赵麦 on 7/26/16.
//  Copyright © 2016 歹徒. All rights reserved.
//

#import "CoreDataStack.h"

@interface CoreDataStack ()
@property (nonatomic, strong) NSManagedObjectModel *model;
@property (nonatomic, strong) NSPersistentStoreCoordinator *coordinator;

@end

@implementation CoreDataStack
+(instancetype)sharedCoreDataStack {
    static CoreDataStack *coreDataStack;
    static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
        coreDataStack = [[CoreDataStack alloc] init];
    });
    
    return coreDataStack;
}

-(NSManagedObjectModel *)model {
    if (_model) {
        return _model;
    }
    
    //method 1 url创建model
//    NSURL *url = [[NSBundle mainBundle] URLForResource:@"Model" withExtension:@"momd"];
//    _model = [[NSManagedObjectModel alloc] initWithContentsOfURL:url];
    
    //method 2
    [NSManagedObjectModel mergedModelFromBundles:nil];
    return _model;
}


//for coordinator url
//不知道为啥 反正下面的方法要用文件夹的路径
-(NSURL *)documentURL {
    NSFileManager *fm = [NSFileManager defaultManager];
    NSArray *urls = [fm URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
    return urls[0];
}
//create sqlite
//1. create persistant coordinator
-(NSPersistentStoreCoordinator *)coordinator {
    if (_coordinator) {
        return _coordinator;
    }
    
    _coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.model];
  
    NSURL *sqliteURL = [[self documentURL] URLByAppendingPathComponent:@"Model.sqlite"];
    
    NSError *error;
    NSPersistentStore *store = [_coordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:sqliteURL options:nil error:&error];
    
    if (!store) {
        NSLog(@"%@", error.description);
    }
    
    return _coordinator;
}

-(NSManagedObjectContext *)context {
    if (_context) {
        return  _context;
    }
    
    _context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    return _context;
}

-(void)saveContext {
    NSError *error;
    if ( ![_context save:&error]) {
        NSLog(@"%@", error.description);
    }
}




@end
