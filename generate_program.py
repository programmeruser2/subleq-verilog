import sys
import struct
import test_program

if len(sys.argv) < 2:
    print('usage: generate_program.py <output file')
    exit(1)

output_file = sys.argv[1]
binary = b''
for line in test_program.program:
    for part in line:
        binary += struct.pack('>Q', part)
with open(output_file, 'wb') as f:
    f.write(binary)
