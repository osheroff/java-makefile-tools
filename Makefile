# modify the compile directive for your env:  compile-java or compile-scala
all: compile
compile: compile-java # or compile-scala
test: test-java

BUILD_SUPPORT_DIR=build/

# these files will get copied to the root of your packaged tarball
DISTFILES=README.md docs/docs/quickstart.md docs/docs/config.md LICENSE src/main/resources/log4j2.xml
PKGNAME=makefile-tools-test

# order is important.  include Makefile.pom first!
include Makefile.pom

include Makefile.java
