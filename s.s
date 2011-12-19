	.file	"s.c"
	.def	___main;	.scl	2;	.type	32;	.endef
	.text
	.globl	_main
	.def	_main;	.scl	2;	.type	32;	.endef
_main:
LFB6:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	andl	$-16, %esp
	subl	$32, %esp
	call	___main
	movl	$65, (%esp)
	call	_push
	movl	$10, (%esp)
	call	_push
	call	_sadd
	movl	$1, 4(%esp)
	movl	$_putchar, (%esp)
	call	_funcCall
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
LFE6:
	.def	_putchar;	.scl	2;	.type	32;	.endef
