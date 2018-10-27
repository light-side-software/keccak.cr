# keccak.cr

Crystal implementation of Keccak (SHA-3).

Based on [PHP](https://github.com/kornrunner/php-keccak) implementation by [kornrunner](https://github.com/kornrunner).

## Installation

Add this to your application's `shard.yml`:

```yaml
dependencies:
  keccak:
    github: light-side-software/keccak.cr
```

## Usage

```crystal
require "keccak"

Keccak.hash("", 224);
# f71837502ba8e10837bdd8d365adb85591895602fc552b48b7390abd

Keccak.hash("", 256);
# c5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470

Keccak.hash("", 384);
# 2c23146a63a29acf99e73b88f8c24eaa7dc60aa771780ccc006afbfa8fe2479b2dd2b21362337441ac12b515911957ff

Keccak.hash("", 512);
# 0eab42de4c3ceb9235fc91acffe746b29c29a8c366b7c60e4e67c466f36a4304c00fa9caf9d87976ba469bcbe06713b435f091ef27
```

## Contributing

1. Fork it (<https://github.com/light-side-software/keccak.cr/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Tamás Szekeres](https://github.com/TamasSzekeres) - creator, maintainer
