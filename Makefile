asmcat: asmcat.nasm
	nasm -a -f elf64 asmcat.nasm
	ld -m elf_x86_64 -s -o asmcat.out asmcat.o

debug:
	nasm -g -a -f elf64 asmcat.nasm
	ld -m elf_x86_64 -o asmcat.out asmcat.o

clean:
	rm -f asmcat.out asmcat.o
