# A terminal calculator
#
# Reads a line of input, interprets it as a simple arithmetic expression,
# and prints the result. The input format is
# <long_integer> <operation> <long_integer>

# Make `main` accessible outside of this module
.global main

# Start of the code section
.text

main:
  # Function prologue
  enter $0, $0

  # Use scanf to retrieve and process a line of input
  # This block implements the following line of C code: 
  #   scanf("%ld %c %ld", &a, &op, &b);
  # Take a look at the man page for scanf and ask questions. You can also look 
  # at scanf_example.c
  movq $scanf_fmt, %rdi
  movq $a, %rsi
  movq $op, %rdx
  movq $b, %rcx
  xorb %al, %al
  call scanf

  movb op, %bl # TODO: load the operation for comparisons            
  movq a, %rax  # TODO: and the LHS
  movq b, %rcx # and the RHS

  # TODO: Analyze operation and execute

  # TODO: Print result

  # TODO: Print error if operation cannot be (safely) performed

  # if (op_char == '+') {
  #   compare operation to + and jump to add
  cmp $'+', %bl
  je add

  # }
  # else if (op_char == '-') {
  #  compare operation to - and jump to sub
  cmp $'-', %bl
  je sub
  # }

  # else if (op_char == '*') {
  #  compare operation to * and jump to multi
  cmp $'*', %bl
  je multi
  # }

  # else if (op_char == '/') {
  #  compare operation to / and jump to divi
  cmp $'/', %bl
  je divi
  # }

  # else {
  #   // print error
  #   // return 1 from main
  cmp $0, %rcx
  movq $unknown, %rdi
  call printf
  movq $1, %rax
  leave
  ret
  # }

  # Add LHS and RHS and store result in %rax
  add:
    addq %rcx, %rax
    jmp print_result

  # Subtract LHS and RHS and store result in %rax
  sub:
    subq %rcx, %rax
    jmp print_result

  # Multiply LHS and RHS and store result in %rax
  multi:
    imulq %rcx, %rax
    jmp print_result

  # Check if RHS is zero then divide LHS and RHS and store result in %rax
  divi:
    cmp $0, %rcx
    je div_error

    cqto              
    idivq %rcx          
    jmp print_result

  # Print error message and return 1
  div_error:
    movq $divi_zero, %rdi
    call printf
    movq $1, %rax

  #Print the result stored in %rax
  print_result:
    movq $output_fmt, %rdi
    movq %rax, %rsi
    xorb %al, %al
    call printf

  # Function epilogue
  movq $0, %rax
  leave
  ret


# Start of the data section
.data

unknown:
  .asciz "Unknown operation\n"
divi_zero:
  .asciz "Error: Division by zero\n"
output_fmt: 
  .asciz "%ld\n"
scanf_fmt: 
  .asciz "%ld %c %ld"  # TODO: modify as needed

# "Slots" for scanf
a:  .quad 0
b:  .quad 0
op: .byte 0

