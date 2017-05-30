# encoding: ascii-8bit

require 'seccomp-tools/disasm'

describe SeccompTools::Disasm do
  it 'normal' do
    bpf = IO.binread(File.join(__dir__, 'data', 'twctf-2016-diary.bpf'))
    expect(described_class.disasm(bpf)).to eq <<EOS
 line  CODE  JT   JF      K
=================================
 0000: 0x20 0x00 0x00 0x00000000  A = sys_number
 0001: 0x15 0x00 0x01 0x00000002  if (A != 2) goto 0003
 0002: 0x06 0x00 0x00 0x00000000  return KILL
 0003: 0x15 0x00 0x01 0x00000101  if (A != 257) goto 0005
 0004: 0x06 0x00 0x00 0x00000000  return KILL
 0005: 0x15 0x00 0x01 0x0000003b  if (A != 59) goto 0007
 0006: 0x06 0x00 0x00 0x00000000  return KILL
 0007: 0x15 0x00 0x01 0x00000038  if (A != 56) goto 0009
 0008: 0x06 0x00 0x00 0x00000000  return KILL
 0009: 0x15 0x00 0x01 0x00000039  if (A != 57) goto 0011
 0010: 0x06 0x00 0x00 0x00000000  return KILL
 0011: 0x15 0x00 0x01 0x0000003a  if (A != 58) goto 0013
 0012: 0x06 0x00 0x00 0x00000000  return KILL
 0013: 0x15 0x00 0x01 0x00000055  if (A != 85) goto 0015
 0014: 0x06 0x00 0x00 0x00000000  return KILL
 0015: 0x15 0x00 0x01 0x00000142  if (A != 322) goto 0017
 0016: 0x06 0x00 0x00 0x00000000  return KILL
 0017: 0x06 0x00 0x00 0x7fff0000  return ALLOW
EOS
  end

  it 'all instructions' do
    bpf = IO.binread(File.join(__dir__, 'data', 'all_inst.bpf'))
    expect(described_class.disasm(bpf)).to eq <<EOS
 line  CODE  JT   JF      K
=================================
 0000: 0x20 0x00 0x00 0x00000000  A = sys_number
 0001: 0x20 0x00 0x00 0x00000004  A = arch
 0002: 0x20 0x00 0x00 0x00000008  A = instruction_pointer
 0003: 0x20 0x00 0x00 0x00000010  A = args[0]
 0004: 0x20 0x00 0x00 0x00000018  A = args[1]
 0005: 0x20 0x00 0x00 0x00000020  A = args[2]
 0006: 0x20 0x00 0x00 0x00000028  A = args[3]
 0007: 0x20 0x00 0x00 0x00000030  A = args[4]
 0008: 0x20 0x00 0x00 0x00000038  A = args[5]
 0009: 0x80 0xb7 0x1f 0x00000016  A = 64
 0010: 0x81 0xfd 0xbd 0x00000067  X = 64
 0011: 0x06 0xb9 0xcf 0x0000008c  return KILL
 0012: 0x16 0x4f 0x67 0x000000cc  return A
 0013: 0x04 0x1a 0xc5 0x00000028  A += 40
 0014: 0x0c 0xd4 0x2f 0x000000a8  A += X
 0015: 0x14 0xa8 0xe7 0x000000db  A -= 219
 0016: 0x1c 0x5d 0xd6 0x000000e0  A -= X
 0017: 0x24 0x3d 0x0e 0x00000052  A *= 82
 0018: 0x2c 0x57 0xaf 0x000000f2  A *= X
 0019: 0x34 0x9f 0x5a 0x000000ee  A /= 238
 0020: 0x3c 0x48 0x2c 0x00000042  A /= X
 0021: 0x54 0xf6 0x8f 0x000000ac  A &= 172
 0022: 0x5c 0x61 0xc8 0x00000017  A &= X
 0023: 0x44 0x81 0x0a 0x000000ef  A |= 239
 0024: 0x4c 0x45 0xc9 0x000000b3  A |= X
 0025: 0xa4 0x1c 0x40 0x0000009e  A ^= 158
 0026: 0xac 0x61 0xc1 0x0000008f  A ^= X
 0027: 0x64 0xde 0x38 0x000000bb  A <<= 187
 0028: 0x6c 0x05 0x07 0x000000f1  A <<= X
 0029: 0x74 0x34 0xde 0x0000003b  A >>= 59
 0030: 0x7c 0xe2 0xc7 0x000000cb  A >>= X
 0031: 0x84 0xce 0x78 0x00000034  A = -A
 0032: 0x00 0x46 0x02 0x000000c2  A = 194
 0033: 0x01 0xe3 0xd4 0x000000a6  X = 166
 0034: 0x07 0x80 0x93 0x0000003d  X = A
 0035: 0x87 0x17 0x1a 0x0000007c  A = X
 0036: 0x60 0x10 0xa1 0x0000000d  A = mem[13]
 0037: 0x61 0x89 0xed 0x00000050  X = mem[80]
 0038: 0x02 0x18 0x9f 0x00000022  mem[34] = A
 0039: 0x03 0xe9 0xf5 0x0000008a  mem[138] = X
 0040: 0x05 0x08 0xb2 0x00000031  goto 0090
 0041: 0x15 0x06 0xc6 0x000000f7  if (A == 247) goto 0048 else goto 0240
 0042: 0x1d 0x9e 0x89 0x00000091  if (A == X) goto 0201 else goto 0180
 0043: 0x35 0x9a 0xa8 0x0000009e  if (A >= 158) goto 0198 else goto 0212
 0044: 0x3d 0x03 0x29 0x0000009a  if (A >= X) goto 0048 else goto 0086
 0045: 0x25 0x02 0x13 0x000000ce  if (A > 206) goto 0048 else goto 0065
 0046: 0x2d 0x06 0x68 0x00000005  if (A > X) goto 0053 else goto 0151
 0047: 0x45 0x08 0x9b 0x0000004d  if (A & 77) goto 0056 else goto 0203
 0048: 0x4d 0x1a 0x61 0x000000bf  if (A & X) goto 0075 else goto 0146
EOS
  end

  it 'else jmp' do
    bpf = [0x15, 0x25, 0x35, 0x45].map { |c| c.chr + "\x00\x00\x01\x00\x00\x00\x00" }.join
    expect(described_class.disasm(bpf)).to eq(<<EOS)
 line  CODE  JT   JF      K
=================================
 0000: 0x15 0x00 0x01 0x00000000  if (A != 0) goto 0002
 0001: 0x25 0x00 0x01 0x00000000  if (A <= 0) goto 0003
 0002: 0x35 0x00 0x01 0x00000000  if (A < 0) goto 0004
 0003: 0x45 0x00 0x01 0x00000000  if (!(A & 0)) goto 0005
EOS
  end

  it 'invalid jmp' do
    expect { described_class.disasm(0x55.chr + "\x00" * 7) }.to raise_error(ArgumentError,
                                                                            'Line 0 is invalid: unknown jmp type')
  end
end
