setup:
	pod install

clean:
	rm -rf Pods Podfile.lock

.PHONY: setup clean