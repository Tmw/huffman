# Huffman

This is a basic Elixir implementation of the [Huffman coding algorithm](https://en.wikipedia.org/wiki/Huffman_coding) written as a toy project. Its featureset is fairly simple; it `encode`s data (ingest data and compresses it) and `decode`s data (take its compressed form and return the original form).

## Usage
The Huffman module only exposes two public functions:

### `encode/1`

Takes (binary) data and returns a compressed version using the Huffman coding. The returned binary consists of three parts:

1. A header to indicate the size of the serialized binary tree used for encoding and decoding the compressed data
2. The compressed data itself
3. Padding is used to round the bitstring up to the nearest binary (multiple of 8) as this might be useful for writing to disk for example

The layout of the blob is as follows:

| header  | tree     | data     | padding  |
|---------|----------|----------|----------|
| 35 bits | variable | variable | < 8 bits |


### `decode/1`

Takes the encoded binary blob and returns the original uncompressed data based on the embedded tree.

## Example
```elixir
data = """
In computer science and information theory, a Huffman code is a particular type of optimal prefix code that is commonly used for lossless data compression. The process of finding or using such a code proceeds by means of Huffman coding, an algorithm developed by David A. Huffman while he was a Sc.D. student at MIT, and published in the 1952 paper \"A Method for the Construction of Minimum-Redundancy Codes\"
"""

{:ok, encoded} = Huffman.encode(data)
# returns {:ok, << encoded binary blob >>}

Huffman.encode(encoded)
# returns {:ok, "In computer science and information theory, a Huffman code..."}

# size comparison
bit_size(data) # original is: 3272 bits
bit_size(encoded) # encoded is: 2296 bits
```

## License
[MIT](./LICENSE)
