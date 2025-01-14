TARGET := iphone:clang:latest:13.0
INSTALL_TARGET_PROCESSES = SpringBoard


include $(THEOS)/makefiles/common.mk
ARCHS = arm64
TWEAK_NAME = DylibInject

DylibInject_FRAMEWORKS = UIKit CoreGraphics QuartzCore ImageIO Foundation
DylibInject_FILES = Tweak.xm
DylibInject_CFLAGS = -fobjc-arc -lz -lsqlite3

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
