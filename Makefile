objects = build/main.o build/brainfuck.o build/read_file.o
.PHONY: clean


# as object are declared as prerequisites they will call build/%.0 as they match
brainfuck: $(objects)
	$(CC) -no-pie -o "$@" $^
# gcc -no-pie -o brainfuck  build/main.o build/brainfuck.o build/read_file.o

build:
	mkdir build

#calls the prerequisites build and the procentage is used as follows, for each of the above build/%.o will be called the procentage being replaced by the specific name, ex: main
build/%.o: src/%.s | build
	$(CC) -no-pie -c -o "$@" "$<"
# gcc -no-pie -c -o build/main.o main.s

clean:
	rm -rf brainfuck build
