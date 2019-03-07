;
; Assembly implementation of cat.
; Copyright (C) 2019  Esote
;
; This program is free software: you can redistribute it and/or modify
; it under the terms of the GNU Affero General Public License as published
; by the Free Software Foundation, either version 3 of the License, or
; (at your option) any later version.
;
; This program is distributed in the hope that it will be useful,
; but WITHOUT ANY WARRANTY; without even the implied warranty of
; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;  GNU Affero General Public License for more details.
;
; You should have received a copy of the GNU Affero General Public License
; along with this program.  If not, see <https://www.gnu.org/licenses/>.
;
STDIN		equ 0
STDOUT		equ 1
BUFSIZE		equ 1024
O_RDONLY	equ 0

[section .text]
[global _start]

_start:
	mov rax, [rsp + 16]	; argv[1] (TODO multiple args)

	test rax, rax		; argv[1] == NULL
	je stdin

	cmp byte [rax], 45	; argv[1][0] == '-'
	jne open

	cmp byte [rax + 1], 0	; argv[1][1] == '\0'
	je stdin

open:
	mov rdi, rax
	mov rax, 2		; sys_open
	mov rdx, O_RDONLY
	syscall

	test rax, rax		; open failed
	mov rdi, 1
	js exit

	mov rbx, rax		; rbx stores fd
read:
	xor rax, rax		; sys_read
	mov rdi, rbx
	mov rsi, buffer
	mov rdx, BUFSIZE
	syscall

	test rax, rax
	js close		; read failed (TODO ret 1)
	je close		; read complete

	mov rdx, rax		; read amount
	mov rdi, STDOUT
write:
	mov rax, 1		; sys_write
	syscall

	cmp rax, rax
	js close		; write failed (TODO ret 1)

	sub rdx, rax

	test rdx, rdx
	jne write		; more to write

	jmp read		; write complete

close:
	mov rax, 3		; sys_close
	mov rdi, rbx
	syscall

	test rax, rax
	mov rdi, 1
	js exit			; close failed

	xor rdi, rdi
exit:
	mov rax, 60		; sys_exit
	syscall

stdin:
	mov rbx, STDIN
	jmp read

[section .bss]
	buffer: resb BUFSIZE	; 1024-byte buffer
