module Keccak
  VERSION = "0.1.0"

  extend self

  KECCAK_ROUNDS = 24
  LFSR = 0x01
  KECCAK_ROTC = [1, 3, 6, 10, 15, 21, 28, 36, 45, 55, 2, 14, 27, 41, 56, 8, 25, 43, 62, 18, 39, 61, 20, 44]
  KECCAKF_PILN = [10, 7, 11, 17, 18, 3, 5, 16, 8, 21, 24, 4, 15, 23, 19, 13, 12,2, 20, 14, 22, 9, 6, 1]
  OUTPUT_SIZES = [224, 256, 384, 512]

  private def keccakf64(st, rounds)
    keccakf_rndc = StaticArray[
      StaticArray[0x00000000, 0x00000001], StaticArray[0x00000000, 0x00008082], StaticArray[0x80000000, 0x0000808a], StaticArray[0x80000000, 0x80008000],
      StaticArray[0x00000000, 0x0000808b], StaticArray[0x00000000, 0x80000001], StaticArray[0x80000000, 0x80008081], StaticArray[0x80000000, 0x00008009],
      StaticArray[0x00000000, 0x0000008a], StaticArray[0x00000000, 0x00000088], StaticArray[0x00000000, 0x80008009], StaticArray[0x00000000, 0x8000000a],
      StaticArray[0x00000000, 0x8000808b], StaticArray[0x80000000, 0x0000008b], StaticArray[0x80000000, 0x00008089], StaticArray[0x80000000, 0x00008003],
      StaticArray[0x80000000, 0x00008002], StaticArray[0x80000000, 0x00000080], StaticArray[0x00000000, 0x0000800a], StaticArray[0x80000000, 0x8000000a],
      StaticArray[0x80000000, 0x80008081], StaticArray[0x80000000, 0x00008080], StaticArray[0x00000000, 0x80000001], StaticArray[0x80000000, 0x80008008]
    ]

    bc = StaticArray(StaticArray(Int64, 2), 5).new { StaticArray[0_i64, 0_i64] }

    (0...rounds).each do |round|

      # Theta
      (0...5).each do |i|
        bc[i] = StaticArray[
          st[i][0] ^ st[i + 5][0] ^ st[i + 10][0] ^ st[i + 15][0] ^ st[i + 20][0],
          st[i][1] ^ st[i + 5][1] ^ st[i + 10][1] ^ st[i + 15][1] ^ st[i + 20][1]
        ]
      end

      (0...5).each do |i|
        t = StaticArray[
          bc[(i + 4) % 5][0] ^ ((bc[(i + 1) % 5][0] << 1) | (bc[(i + 1) % 5][1] >> 31)) & (0xFFFFFFFF),
          bc[(i + 4) % 5][1] ^ ((bc[(i + 1) % 5][1] << 1) | (bc[(i + 1) % 5][0] >> 31)) & (0xFFFFFFFF)
        ]

        (0...25).step(5).each do |j|
          st[j + i] = StaticArray[
            st[j + i][0] ^ t[0],
            st[j + i][1] ^ t[1]
          ]
        end
      end

      # Rho Pi
      t = st[1];
      (0...24).each do |i|
        j = KECCAKF_PILN[i]

        bc[0] = st[j]

        n = KECCAK_ROTC[i]
        hi = t[0]
        lo = t[1]
        if n >= 32
          n -= 32
          hi = t[1]
          lo = t[0]
        end

        st[j] = StaticArray[
          ((hi << n) | (lo >> (32 - n))) & (0xFFFFFFFF),
          ((lo << n) | (hi >> (32 - n))) & (0xFFFFFFFF)
        ]

        t = bc[0]
      end

      #  Chi
      (0...25).step(5).each do |j|
        (0...5).each do |i|
          bc[i] = st[j + i]
        end
        (0...5).each do |i|
          st[j + i] = StaticArray[
            st[j + i][0] ^ ~bc[(i + 1) % 5][0] & bc[(i + 2) % 5][0],
            st[j + i][1] ^ ~bc[(i + 1) % 5][1] & bc[(i + 2) % 5][1]
          ]
        end
      end

      # Iota
      st[0] = StaticArray[
        st[0][0] ^ keccakf_rndc[round][0],
        st[0][1] ^ keccakf_rndc[round][1]
      ]
    end

    st
  end

  private def keccak64(in_raw : String, capacity : Int32, output_length : Int32, suffix, raw_output : Bool) : String
    capacity /= 8

    in_len = in_raw.size

    rsiz = 200 - 2 * capacity
    rsizw = rsiz / 8

    st = StaticArray(StaticArray(Int64, 2), 25).new { StaticArray[0_i64, 0_i64] }

    in_t = 0
    while in_len >= rsiz
      (0...rsizw).each do |i|
        s = i * 8 + in_t
        t = [
          in_raw[s + 0].ord.to_i64 | in_raw[s + 1].ord.to_i64 << 8 | in_raw[s + 2].ord.to_i64 << 16 | in_raw[s + 3].ord.to_i64 << 24,
          in_raw[s + 4].ord.to_i64 | in_raw[s + 5].ord.to_i64 << 8 | in_raw[s + 6].ord.to_i64 << 16 | in_raw[s + 7].ord.to_i64 << 24,
        ]

        st[i] = StaticArray[
          st[i][0] ^ t[1].to_i64,
          st[i][1] ^ t[0].to_i64
        ]
      end

      st = keccakf64(st, KECCAK_ROUNDS)

      in_len -= rsiz
      in_t += rsiz
    end

    temp = in_raw[in_t, in_len]
      .ljust(in_len + 1, suffix.unsafe_chr)
      .ljust(rsiz, Char::ZERO)

    temp = temp.sub(rsiz - 1, (temp[rsiz - 1].ord | 0x80).unsafe_chr)

    (0...rsizw).each do |i|
      s = i * 8

      t = [
        temp[s].ord.to_i64 | temp[s + 1].ord.to_i64 << 8 | temp[s + 2].ord.to_i64 << 16 | temp[s + 3].ord.to_i64 << 24,
        temp[s + 4].ord.to_i64 | temp[s + 5].ord.to_i64 << 8 | temp[s + 6].ord.to_i64 << 16 | temp[s + 7].ord.to_i64 << 24,
      ]

      st[i] = StaticArray[
        st[i][0] ^ t[1].to_i64,
        st[i][1] ^ t[0].to_i64
      ]
    end

    st = keccakf64(st, KECCAK_ROUNDS)

    output_chars = output_length / (raw_output ? 8 : 4)
    String::Builder.build(output_chars) do |builder|
      (0...25).each do |i|
        if builder.bytesize < output_chars
          w = st[i][0] << 32 | st[i][1]
          if raw_output
            builder.write_bytes w
          else
            builder << Bytes.new(8) { |i| (w >> (i * 8) & 0xff).to_u8 }.hexstring
          end
        else
          break
        end
      end
    end
    .to_s[0, output_chars]
  end

  private def keccak(in_raw : String, capacity : Int32, output_length : Int32, suffix, raw_output : Bool) : String
    keccak64(in_raw, capacity, output_length, suffix, raw_output)
  end

  # Returns [Keccak](https://en.wikipedia.org/wiki/SHA-3) (not the standardized SHA3) of the given string.
  #
  # **Parameters**
  # - *input* - Input string.
  # - *output_size* - Size of returning hash in bits.
  # - *raw_output* - if **false** returns hex-encoded string, raw bytes otherwise.
  #
  # **Returns**
  #    `String` - The SHA3 result of the given string.
  def hash(input : String, output_size : Int32, raw_output : Bool = false) : String
    raise "Unsupported Keccak Hash output size." unless OUTPUT_SIZES.includes? output_size

    keccak(input, mdlen, output_size, LFSR, raw_output)
  end
end
