# module file




## Contents
- [Constants](#Constants)
- [create_decoder](#create_decoder)
- [OpusDecoder](#OpusDecoder)
  - [open](#open)
  - [close](#close)
  - [is_opened](#is_opened)
  - [is_stereo](#is_stereo)
  - [sample_rate](#sample_rate)
  - [bitrate](#bitrate)
  - [channels](#channels)
  - [duration](#duration)
  - [size](#size)
  - [seek](#seek)
  - [read](#read)
  - [read_all](#read_all)

## Constants
```v
const (
	op_false               = -1
	op_eof                 = -2
	op_hole                = -3
	op_eread               = -128
	op_efault              = -129
	op_eimpl               = -130
	op_einval              = -131
	op_enotformat          = -132
	op_ebadheader          = -133
	op_eversion            = -134
	op_enotaudio           = -135
	op_ebadpacket          = -136
	op_ebadlink            = -137
	op_enoseek             = -138
	op_ebadtimestamp       = -139
	opus_channel_count_max = 255
)
```


[[Return to contents]](#Contents)

```v
const (
	chunk = 4096
)
```


[[Return to contents]](#Contents)

## create_decoder
```v
fn create_decoder() &OpusDecoder
```

create_decoder creates an instance of OpusDecoder

[[Return to contents]](#Contents)

## OpusDecoder
```v
struct OpusDecoder {
mut:
	file &C.OggOpusFile = &C.OggOpusFile(0)
	head &C.OpusHead    = &C.OpusHead(0)
	link int
}
```


[[Return to contents]](#Contents)

## open
```v
fn (mut od OpusDecoder) open(path string) !
```

open will open a opusfile

[[Return to contents]](#Contents)

## close
```v
fn (mut od OpusDecoder) close() !
```

close clears the opusfile. Must be called to clean up resources!

[[Return to contents]](#Contents)

## is_opened
```v
fn (od OpusDecoder) is_opened() bool
```

is_opened returns true if the opusfile is open for reading

[[Return to contents]](#Contents)

## is_stereo
```v
fn (od OpusDecoder) is_stereo() bool
```

is_stereo returns true if the opusfile is stereo (a.k.a multichannel)

[[Return to contents]](#Contents)

## sample_rate
```v
fn (od OpusDecoder) sample_rate() i64
```

sample_rate returns the sample rate of the opusfile

[[Return to contents]](#Contents)

## bitrate
```v
fn (od OpusDecoder) bitrate() !i64
```

bitrate returns the bitrate of the opusfile

[[Return to contents]](#Contents)

## channels
```v
fn (od OpusDecoder) channels() int
```

channels returns the number of channels of the opusfile

[[Return to contents]](#Contents)

## duration
```v
fn (od OpusDecoder) duration() !f64
```

duration returns the total time in seconds of the opusfile

[[Return to contents]](#Contents)

## size
```v
fn (od OpusDecoder) size() i64
```

size returns the total size of the opusfile

[[Return to contents]](#Contents)

## seek
```v
fn (od OpusDecoder) seek(pos f64) !
```

seek changes the internal position of the stream, in seconds

[[Return to contents]](#Contents)

## read
```v
fn (od OpusDecoder) read(mut buffer []i16) !i64
```

read reads a part of the opusfile up to the lenght of the provided buffer

[[Return to contents]](#Contents)

## read_all
```v
fn (od OpusDecoder) read_all(mut buffer []i16) !i64
```

read_all reads the entire data of the opusfile

[[Return to contents]](#Contents)

#### Powered by vdoc. Generated on: 5 Nov 2022 15:04:12
