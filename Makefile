ARCHS = arm64 arm64e

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = MusicLocker
MusicLocker_FILES = Tweak.xm
MusicLocker_LIBRARIES += nepeta
MusicLocker_PRIVATE_FRAMEWORKS = MediaRemote

SHARED_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
