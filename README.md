translate2Ascii

### Description

This program takes a hardcoded buffer of hexadecimal byte values and converts each byte into two printable ASCII characters. Each output character is derived by taking the original hex byte, wrapping it into the printable ASCII range (32–126), and pairing it with a second character offset by 17 positions within that range. The result is printed to standard output as a sequence of ASCII character pairs separated by spaces.


### Build and Run

```bash
nasm -f elf translate2Ascii.asm
ld -m elf_i386 translate2Ascii.o -o translate2Ascii
./translate2Ascii
```

You should see an output of pairs of printable ASCII characters based on the hardcoded input buffer.

**What the Program Does**

    Reads a fixed-length buffer of 8 hex values.

    For each byte:

        Translates it to a printable ASCII character using (value % 95) + 32.

        Computes a second character using (first_char + 17) % 95 + 32.

    Stores the resulting two characters in an output buffer, separated by spaces.

    Prints the final ASCII output followed by a newline.
