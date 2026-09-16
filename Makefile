ifndef THEOS
$(error THEOS is not set)
endif

TARGET := iphone:clang:latest:15.0
ARCHS = arm64 arm64e
THEOS_PACKAGE_SCHEME = rootless

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = FlexFix
FlexFix_FILES = Tweak.x
FlexFix_CFLAGS = -fobjc-arc
FlexFix_LIBRARIES = substrate

include $(THEOS_MAKE_PATH)/tweak.mk
