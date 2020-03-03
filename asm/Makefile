cat: cat.nasm
	nasm -g -a -f elf64 cat.nasm
	ld -m elf_x86_64 -o cat.out cat.o

clean:
	rm -f cat.out cat.o
