#import <Foundation/Foundation.h>
#import <substrate.h>
#import <mach/mach.h>

static kern_return_t (*orig_task_swap_exception_ports)(
	task_t task,
	exception_mask_t exception_mask,
	mach_port_t new_port,
	exception_behavior_t new_behavior,
	thread_state_flavor_t new_flavor,
	exception_mask_array_t masks,
	mach_msg_type_number_t *masksCnt,
	exception_port_array_t old_handlers,
	exception_behavior_array_t old_behaviors,
	exception_flavor_array_t old_flavors);

static kern_return_t hook_task_swap_exception_ports(
	task_t task,
	exception_mask_t exception_mask,
	mach_port_t new_port,
	exception_behavior_t new_behavior,
	thread_state_flavor_t new_flavor,
	exception_mask_array_t masks,
	mach_msg_type_number_t *masksCnt,
	exception_port_array_t old_handlers,
	exception_behavior_array_t old_behaviors,
	exception_flavor_array_t old_flavors) {
	NSLog(@"[FlexFix] blocked task_swap_exception_ports");
	if (masksCnt) {
		*masksCnt = 0;
	}
	return KERN_SUCCESS;
}

static kern_return_t (*orig_task_set_exception_ports)(
	task_t task,
	exception_mask_t exception_mask,
	mach_port_t new_port,
	exception_behavior_t new_behavior,
	thread_state_flavor_t new_flavor);

static kern_return_t hook_task_set_exception_ports(
	task_t task,
	exception_mask_t exception_mask,
	mach_port_t new_port,
	exception_behavior_t new_behavior,
	thread_state_flavor_t new_flavor) {
	NSLog(@"[FlexFix] blocked task_set_exception_ports");
	return KERN_SUCCESS;
}

static kern_return_t (*orig_thread_set_exception_ports)(
	thread_t thread,
	exception_mask_t exception_mask,
	mach_port_t new_port,
	exception_behavior_t new_behavior,
	thread_state_flavor_t new_flavor);

static kern_return_t hook_thread_set_exception_ports(
	thread_t thread,
	exception_mask_t exception_mask,
	mach_port_t new_port,
	exception_behavior_t new_behavior,
	thread_state_flavor_t new_flavor) {
	NSLog(@"[FlexFix] blocked thread_set_exception_ports");
	return KERN_SUCCESS;
}

%hook Fabric

+ (id)with:(id)kits {
	NSLog(@"[FlexFix] Fabric blocked");
	return nil;
}

%end

%hook Crashlytics

- (void)start {
}

+ (id)startWithAPIKey:(id)k {
	return nil;
}

+ (void)initializeIfNeeded {
}

%end

%ctor {
	MSHookFunction((void *)task_swap_exception_ports, (void *)hook_task_swap_exception_ports, (void **)&orig_task_swap_exception_ports);
	MSHookFunction((void *)task_set_exception_ports, (void *)hook_task_set_exception_ports, (void **)&orig_task_set_exception_ports);
	MSHookFunction((void *)thread_set_exception_ports, (void *)hook_thread_set_exception_ports, (void **)&orig_thread_set_exception_ports);

	%init;
}
