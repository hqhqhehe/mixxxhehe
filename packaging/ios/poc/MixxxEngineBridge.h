#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^MixxxControlObserver)(double value);

@interface MixxxEngineBridge : NSObject

- (instancetype)init;

- (void)setControlWithGroup:(NSString*)group
                       item:(NSString*)item
                      value:(double)value;

- (void)toggleControlWithGroup:(NSString*)group
                          item:(NSString*)item;

- (void)triggerControlWithGroup:(NSString*)group
                           item:(NSString*)item;

- (NSString*)observeControlWithGroup:(NSString*)group
                                item:(NSString*)item
                            callback:(MixxxControlObserver)callback;

- (void)removeObserverWithToken:(NSString*)token;

@end

NS_ASSUME_NONNULL_END
