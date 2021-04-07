require "./spec_helper"

describe Keccak do
  describe "#hash" do
    it "should calc hash (224)" do
      Keccak.hash("Keccak", 224, false).should eq("1df5b57d79d512c3cc6ba5aa038f376f51d0621196c2017c37891f3e")
      Keccak.hash("Crystal Language", 224, false).should eq("3bebb4355947c76f7042b2e9e5f81f1c6d71cea67df93861721b759a")
    end

    it "should calc hash (256)" do
      Keccak.hash("Keccak", 256, false).should eq("868c016b666c7d3698636ee1bd023f3f065621514ab61bf26f062c175fdbe7f2")
      Keccak.hash("Crystal Language", 256, false).should eq("3a3d0a5971128057a66bdd28aad84d4908d4c1482ad714c49beb83a367d6d299")
      Keccak.hash(Bytes[65], 256).should eq(Bytes[0x03, 0x78, 0x3f, 0xac, 0x2e, 0xfe, 0xd8, 0xfb, 0xc9, 0xad, 0x44, 0x3e, 0x59, 0x2e, 0xe3, 0x0e, 0x61, 0xd6, 0x5f, 0x47, 0x11, 0x40, 0xc1, 0x0c, 0xa1, 0x55, 0xe9, 0x37, 0xb4, 0x35, 0xb7, 0x60])
    end

    it "should calc hash (384)" do
      Keccak.hash("Keccak", 384, false).should eq("4f0f6edc8ae0d3f634b8bac984a17463747bdf5c206569127061dcff6dd8eed1837d819057769de88180c9cb511572ba")
      Keccak.hash("Crystal Language", 384, false).should eq("3203cff6f468fa7bed4cd96c0df3c0b2107da04bf706a99230e01ff8af36af4d71d1d66af35e8f2e97777a38ca0ebb60")
    end

    it "should calc hash (512)" do
      Keccak.hash("Keccak", 512, false).should eq("b1e0beb9088d35ad433146364430f30eb3336efe8bd7ae31baa88de1987b6400fbcfddaa3de1cc4ebf2a7d79f9dd7b5b115a5c95d24e5c33c63da6a021d67c1d")
      Keccak.hash("Crystal Language", 512, false).should eq("bf0cc68c19684e72a485a4972503be88cd07170cd0b3a5fe27738fd8e40d9942e5f75094278eb64a1776e0a27b4e0a78789dfd181041b062cbaf32da14d94e02")
    end

    it "should calc raw hash (224)" do
      Keccak.hash("Keccak", 224, true).should eq("\u001D\xF5\xB5}y\xD5\u0012\xC3\xCCk\xA5\xAA\u0003\x8F7oQ\xD0b\u0011\x96\xC2\u0001|7\x89\u001F>")
      Keccak.hash("Crystal Language", 224, true).should eq(";\xEB\xB45YG\xC7opB\xB2\xE9\xE5\xF8\u001F\u001CmqΦ}\xF98ar\eu\x9At")
    end

    it "should calc raw hash (256)" do
      Keccak.hash("Keccak", 256, true).should eq("\x86\x8C\u0001kfl}6\x98cn\xE1\xBD\u0002??\u0006V!QJ\xB6\e\xF2o\u0006,\u0017_\xDB\xE7\xF2")
      Keccak.hash("Crystal Language", 256, true).should eq(":=\nYq\u0012\x80W\xA6k\xDD(\xAA\xD8MI\b\xD4\xC1H*\xD7\u0014ě냣g\xD6ҙ")
    end

    it "should calc raw hash (384)" do
      Keccak.hash("Keccak", 384, true).should eq("O\u000Fn܊\xE0\xD3\xF64\xB8\xBAɄ\xA1tct{\xDF\\ ei\u0012pa\xDC\xFFm\xD8\xEEу}\x81\x90Wv\x9D聀\xC9\xCBQ\u0015r\xBA")
      Keccak.hash("Crystal Language", 384, true).should eq("2\u0003\xCF\xF6\xF4h\xFA{\xEDL\xD9l\r\xF3\xC0\xB2\u0010}\xA0K\xF7\u0006\xA9\x920\xE0\u001F\xF8\xAF6\xAFMq\xD1\xD6j\xF3^\x8F.\x97wz8\xCA\u000E\xBB`")
    end

    it "should calc raw hash (512)" do
      Keccak.hash("Keccak", 512, true).should eq("\xB1ྐྵ\b\x8D5\xADC1F6D0\xF3\u000E\xB33n\xFE\x8B׮1\xBA\xA8\x8D\xE1\x98{d\u0000\xFB\xCFݪ=\xE1\xCCN\xBF*}y\xF9\xDD{[\u0011Z\\\x95\xD2N\\3\xC6=\xA6\xA0!\xD6|\u001D")
      Keccak.hash("Crystal Language", 512, true).should eq("\xBF\fƌ\u0019hNr\xA4\x85\xA4\x97%\u0003\xBE\x88\xCD\a\u0017\fг\xA5\xFE's\x8F\xD8\xE4\r\x99B\xE5\xF7P\x94'\x8E\xB6J\u0017v\xE0\xA2{N\nxx\x9D\xFD\u0018\u0010A\xB0b˯2\xDA\u0014\xD9N\u0002")
    end

    it "should calc hash of long input (224)" do
      Keccak.hash("0123456789" * 20, 224, false).should eq("04d4bbb8963d669e8e3c9e40db00123431ab7dba43022ebc77760ac8")
    end

    it "should calc hash of long input (256)" do
      Keccak.hash("0123456789" * 20, 256, false).should eq("bebf7feb66ec4249f26ba898cab15d2eaf14ba4623b962a61eec09afde36ed67")
    end

    it "should calc hash of long input (384)" do
      Keccak.hash("0123456789" * 20, 384, false).should eq("3a8cd95483b337243c9e969df96407ec04a2ebdbda91ccd2e08c657ed63ef85a9d221c39d29c7dc577efe16be48a1a7f")
    end

    it "should calc hash of long input (512)" do
      Keccak.hash("0123456789" * 20, 512, false).should eq("5e92e6ac6e14d131efa82846d41f4f21565ab0f408a8737ce241a69c666cf0080af00f7045c7fce8e26037137e56e72f812da8db692685a4d0e46fdc56953f4b")
    end
  end

  describe "#shake" do
    it "should calc shake (128, 256)" do
      Keccak.shake("", 128, 256).should eq("7f9c2ba4e88f827d616045507605853ed73b8093f6efbc88eb1a6eacfa66ef26")
      Keccak.shake("The quick brown fox jumps over the lazy dog", 128, 256).should eq("f4202e3c5852f9182a0430fd8144f0a74b95e7417ecae17db0f8cfeed0e3e66e")
    end

    it "should calc shake (256, 512)" do
      Keccak.shake("", 256, 512).should eq("46b9dd2b0ba88d13233b3feb743eeb243fcd52ea62b81b82b50c27646ed5762fd75dc4ddd8c0f200cb05019d67b592f6fc821c49479ab48640292eacb3b7c4be")
      Keccak.shake("The quick brown fox jumps over the lazy dog", 256, 512).should eq("2f671343d9b2e1604dc9dcf0753e5fe15c7c64a0d283cbbf722d411a0e36f6ca1d01d1369a23539cd80f7c054b6e5daf9c962cad5b8ed5bd11998b40d5734442")
    end
  end
end
