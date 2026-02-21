#import "MixxxEngineBridge.h"

#import <dispatch/dispatch.h>

#include <functional>
#include <memory>
#include <string>
#include <unordered_map>

namespace {
struct ControlKey {
    std::string group;
    std::string item;
};

class EngineControlAdapter {
  public:
    using Observer = std::function<void(double)>;

    void setControl(const std::string& group, const std::string& item, double value) {
        (void)group;
        (void)item;
        (void)value;
        // PoC: wire to ControlProxy / ControlObject in engine integration step.
    }

    void toggleControl(const std::string& group, const std::string& item) {
        (void)group;
        (void)item;
    }

    void triggerControl(const std::string& group, const std::string& item) {
        (void)group;
        (void)item;
    }

    std::string addObserver(const std::string& group, const std::string& item, Observer observer) {
        const std::string token = group + ":" + item + ":" + std::to_string(++m_nextId);
        m_observers[token] = std::move(observer);
        return token;
    }

    void removeObserver(const std::string& token) {
        m_observers.erase(token);
    }

  private:
    std::unordered_map<std::string, Observer> m_observers;
    int m_nextId{0};
};
} // namespace

@interface MixxxEngineBridge () {
    std::unique_ptr<EngineControlAdapter> _adapter;
}
@end

@implementation MixxxEngineBridge

- (instancetype)init {
    self = [super init];
    if (self) {
        _adapter = std::make_unique<EngineControlAdapter>();
    }
    return self;
}

- (void)setControlWithGroup:(NSString*)group item:(NSString*)item value:(double)value {
    _adapter->setControl(group.UTF8String, item.UTF8String, value);
}

- (void)toggleControlWithGroup:(NSString*)group item:(NSString*)item {
    _adapter->toggleControl(group.UTF8String, item.UTF8String);
}

- (void)triggerControlWithGroup:(NSString*)group item:(NSString*)item {
    _adapter->triggerControl(group.UTF8String, item.UTF8String);
}

- (NSString*)observeControlWithGroup:(NSString*)group
                                item:(NSString*)item
                            callback:(MixxxControlObserver)callback {
    auto observer = [callback](double value) {
        dispatch_async(dispatch_get_main_queue(), ^{
            callback(value);
        });
    };
    std::string token = _adapter->addObserver(group.UTF8String, item.UTF8String, observer);
    return [NSString stringWithUTF8String:token.c_str()];
}

- (void)removeObserverWithToken:(NSString*)token {
    _adapter->removeObserver(token.UTF8String);
}

@end
