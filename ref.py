def main():
    # constants A & b
    a11 = 0x40
    a12 = 0x90
    a21 = 0x90
    a22 = 0x60

    b1 = 0x05
    b2 = 0x0C

    # inputs
    x1 = 0xCE
    y1 = 0x8B

    # perform transformation
    x2 = (trunc_mult(a11, x1) + trunc_mult(a12, y1)) + b1 
    y2 = (trunc_mult(a21, x1) + trunc_mult(a22, y1)) + b2

    # truncate results
    x2 &= 0xFF
    y2 &= 0xFF

    print(hex(x2))
    print(hex(y2))

def trunc_mult(a, b):
    if (a > 127): a -= 256
    if (b > 127): b -= 256
    
    return ((a * b) >> 7) & 0x0FF

if __name__ == "__main__":
    main()