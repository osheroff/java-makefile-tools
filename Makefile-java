JAVAC = javac
JAVAC_FLAGS += -d target/classes
JAVAC_FLAGS += -sourcepath src/main/java:src/test/java:src/main/scala:src/test/scala
JAVAC_FLAGS += -g -target 1.7 -source 1.7 -encoding UTF-8 -Xlint:-options -Xlint:unchecked
JAVA_SOURCE = $(shell find src/main/java -name '*.java')

ifdef POM_DEPENDS
JAVA_CLASSPATH := -classpath $(POM_DEPENDS)
endif

JAVA_TEST_CLASSPATH := -classpath target/classes
ifdef POM_TEST_DEPENDS
JAVA_TEST_CLASSPATH := $(JAVA_TEST_CLASSPATH):$(POM_TEST_DEPENDS)
endif

target/.java: $(JAVA_SOURCE)
	@mkdir -p target/classes
	$(JAVAC) $(JAVA_CLASSPATH) $(JAVAC_FLAGS) $?
	if test -d src/main/resources; then cp -a src/main/resources/* target/classes ; fi
	@touch target/.java

compile-java: target/.java

JAVA_TEST_SOURCE=$(shell test -d src/test/java && find src/test/java -name '*.java')

target/.java-test: $(JAVA_TEST_SOURCE)
	@mkdir -p target/test-classes
	if test -d src/test/resources ; then cp -a src/test/resources/* target/test-classes ; fi
	javac -d target/test-classes -sourcepath src/main/java:src/test/java:target/generated-sources $(JAVA_TEST_CLASSPATH) \
		-g -target 1.7 -source 1.7 -encoding UTF-8 $?
	@touch target/.java-test
compile-test-java: compile-java target/.java-test

TEST_CLASSES=$(shell $(BUILD_SUPPORT_DIR)/get-test-classes)

test-java: compile-test-java
	java -Xmx128m $(JAVA_TEST_CLASSPATH):target/test-classes org.junit.runner.JUnitCore $(TEST_CLASSES)

clean:
	rm -f  target/.java target/.java-test
	rm -rf target/classes
	rm -rf target/generated-sources
	rm -f  target/*.jar

depclean: clean
	rm -f $(CLASSPATH)

# TODO: make more generic

MAVEN_DIR=target/classes/META-INF/maven/com.zendesk/maxwell
JARFILE=target/$(PKGNAME).jar

package-jar: all
	rm -f ${JARFILE}
	mkdir -p ${MAVEN_DIR}
	if test -f pom.xml ; then cp pom.xml ${MAVEN_DIR} ; fi
	jar cvf ${JARFILE} -C target/classes .

TARDIR=target/$(PKGNAME)
TARFILE=target/$(PKGNAME).tar.gz

package-tar:
	rm -Rf target/dependency-build
	$(BUILD_SUPPORT_DIR)/maven_fetcher -p -o target/dependency-build >/dev/null
	rm -Rf $(TARDIR) $(TARFILE)
	mkdir $(TARDIR)
	cp $(DISTFILES) $(TARDIR)
	cp -a bin $(TARDIR)
	mkdir $(TARDIR)/lib
	cp -a $(JARFILE) target/dependency-build/* $(TARDIR)/lib
	tar czvf $(TARFILE) -C target $(PKGNAME)

package: depclean package-jar package-tar



