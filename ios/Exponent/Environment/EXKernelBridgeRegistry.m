// Copyright 2015-present 650 Industries. All rights reserved.

#import "EXKernelBridgeRegistry.h"

#import <React/RCTBridge.h>
#import "EXFrame.h"

@interface EXKernelBridgeRegistry ()

@property (nonatomic, strong) NSMapTable<id, EXKernelBridgeRecord *> *bridgeRegistry;
@property (nonatomic, assign) RCTBridge *kernelBridge;
@property (nonatomic, strong) NSMutableSet *experienceIdErrorRecoverySet;

@end

@implementation EXKernelBridgeRegistry

- (instancetype)init
{
  if (self = [super init]) {
    _bridgeRegistry = [NSMapTable mapTableWithKeyOptions:NSPointerFunctionsWeakMemory valueOptions:NSPointerFunctionsStrongMemory];
    _experienceIdErrorRecoverySet = [NSMutableSet set];
  }
  return self;
}

- (void)registerBridge:(id)bridge forExperienceId:(NSString *)experienceId frame:(EXFrame *)frame
{
  NSAssert(experienceId, @"Cannot register a bridge with no experience id");
  for (id bridge in self.bridgeEnumerator) {
    EXKernelBridgeRecord *record = [self recordForBridge:bridge];
    if ([record.experienceId isEqualToString:experienceId]) {
      NSAssert(NO, @"Cannot register a bridge with a non-unique experience id");
    }
  }
  [_bridgeRegistry setObject:[EXKernelBridgeRecord recordWithExperienceId:experienceId frame:frame] forKey:bridge];

  // if this experience had a loading error previously, consider it recovered now
  [_experienceIdErrorRecoverySet removeObject:experienceId];

  if (_lastKnownForegroundBridge == nil) {
    // TODO: this assumes we always load bridges in the foreground (true at time of writing)
    _lastKnownForegroundBridge = bridge;
  }
}

- (void)unregisterBridge:(id)bridge
{
  EXKernelBridgeRecord *record = [_bridgeRegistry objectForKey:bridge];
  if (record) {
    [_bridgeRegistry removeObjectForKey:bridge];
  }
}

- (void)setError:(NSError *)error forBridge:(id)bridge
{
  EXKernelBridgeRecord *record = [self recordForBridge:bridge];
  if (record) {
    record.error = error;
    if (error) {
      // mark this experience id as having loading problems, so future attempts will bust the cache
      [_experienceIdErrorRecoverySet addObject:record.experienceId];
    }
  }
}

- (BOOL)errorBelongsToBridge:(NSError *)error
{
  for (id bridge in self.bridgeEnumerator) {
    EXKernelBridgeRecord *record = [self recordForBridge:bridge];
    if (record.error && [record.error isEqual:error]) {
      return YES;
    }
  }
  return NO;
}

- (void)registerKernelBridge:(RCTBridge *)bridge
{
  _kernelBridge = bridge;
}

- (void)unregisterKernelBridge
{
  _kernelBridge = nil;
}

- (RCTBridge *)kernelBridge
{
  return _kernelBridge;
}

- (EXKernelBridgeRecord *)recordForBridge:(id)bridge
{
  return [_bridgeRegistry objectForKey:bridge];
}

- (NSEnumerator<id> *)bridgeEnumerator
{
  return [_bridgeRegistry keyEnumerator];
}

- (BOOL)experienceIdIsRecoveringFromError:(NSString *)experienceId
{
  return (experienceId && [_experienceIdErrorRecoverySet containsObject:experienceId]);
}

- (NSString *)description
{
  if (_bridgeRegistry.count > 0) {
    NSMutableString *results = [NSMutableString string];
    for (id bridge in self.bridgeEnumerator) {
      EXKernelBridgeRecord *record = [self recordForBridge:bridge];
      [results appendString:[NSString stringWithFormat:@"  %@: %@\n", bridge, record.experienceId]];
    }
    return [NSString stringWithFormat:@"EXKernelBridgeRegistry with bridges: {\n%@}", results];
  }
  return @"EXKernelBridgeRegistry (empty)";
}

@end
