HEADERS = \
	include/ex/ex.h \
	include/ex/foo.h

all: Ex-0.1.gir Ex-0.1.typelib

target/debug/libgobject_example.so: src/lib.rs
	cargo build

Ex-0.1.gir: target/debug/libgobject_example.so
	g-ir-scanner -v --warn-all \
		--namespace Ex --nsversion=0.1 \
		-Iinclude --c-include "ex/ex.h" \
		--library=gobject_example --library-path=target/debug \
		--include=GObject-2.0 -pkg gobject-2.0 \
		--output $@ \
		$(HEADERS)

Ex-0.1.typelib: Ex-0.1.gir
	g-ir-compiler \
		--includedir=include \
		$< -o $@

clean:
	rm -f Ex-0.1.typelib
	rm -f Ex-0.1.gir
	cargo clean
