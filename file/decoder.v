module file

import math

pub struct OpusDecoder {
mut:
	file &C.OggOpusFile = &C.OggOpusFile(0)
	head &C.OpusHead    = &C.OpusHead(0)
	link int
}

// create_decoder creates an instance of OpusDecoder
fn create_decoder() &OpusDecoder {
	return &OpusDecoder{}
}

// open will open a opusfile
pub fn (mut od OpusDecoder) open(path string) ! {
	//
	if od.is_opened() {
		println('OpusDecoder already opened')
		return
	}
	//
	error := int(0)
	od.file = C.op_open_file(&char(path.str), &error)
	od.check_error(error) !
	//
	od.head = C.op_head(od.file, -1)
}

// close clears the opusfile. Must be called to clean up resources!
pub fn (mut od OpusDecoder) close() ! {
	//
	if od.is_opened() == false {
		return
	}
	//
	C.op_free(od.file)
	od.file = &C.OggOpusFile(0)
	od.head = &C.OpusHead(0)
}

// is_opened returns true if the opusfile is open for reading
pub fn (od OpusDecoder) is_opened() bool {
	return isnil(od.file) == false
}

// is_stereo returns true if the opusfile is stereo (a.k.a multichannel)
pub fn (od OpusDecoder) is_stereo() bool {
	return od.channels() == 2
}

// sample_rate returns the sample rate of the opusfile
pub fn (od OpusDecoder) sample_rate() i64 {
	return od.head.input_sample_rate
}

// bitrate returns the bitrate of the opusfile
pub fn (od OpusDecoder) bitrate()! i64 {
	rate := C.op_bitrate(od.file, -1)
	od.check_error(rate)!
	return i64(rate)
}

// channels returns the number of channels of the opusfile
pub fn (od OpusDecoder) channels() int {
	return od.head.channel_count
}

// duration returns the total time in seconds of the opusfile
pub fn (od OpusDecoder) duration() !f64 {
	val := C.op_pcm_total(od.file, -1)
	od.check_error(val) !
	return val / od.sample_rate()
}

// size returns the total size of the opusfile
pub fn (od OpusDecoder) size() i64 {
	return C.op_pcm_total(od.file, -1) * od.channels() * 2
}

// seek changes the internal position of the stream, in seconds
pub fn (od OpusDecoder) seek(pos f64) ! {
	mut n := math.min(pos, od.duration()!)
	//
	offset := i64(n / od.sample_rate())
	err := C.op_pcm_seek(od.file, offset)
	od.check_error(err) !
}

// read reads a part of the opusfile up to the lenght of the provided buffer
pub fn (od OpusDecoder) read(mut buffer []i16) !i64 {
	//
	assert buffer.len > 0 && buffer.len <= chunk
	//
	bytes_read := if od.is_stereo() {
		C.op_read_stereo(od.file, buffer.data, buffer.len) * od.channels()
	} else {
		C.op_read(od.file, buffer.data, buffer.len, &od.link)
	}
	//
	if bytes_read == 0 {
		return 0
	}
	//
	od.check_error(bytes_read) !
	return bytes_read
}

// read_all reads the entire data of the opusfile
pub fn (od OpusDecoder) read_all(mut buffer []i16) ! {
	//
	assert buffer.len == od.size()
	//
	mut index := i64(0)
	mut tmp := []i16{len: chunk}
	mut bytes_read := i64(0)
	for {
		bytes_read = od.read(mut tmp) !
		if bytes_read == 0 {
			break
		}
		//
		real_read := bytes_read / 2
		for i in 0 .. real_read {
			buffer[index + i] = tmp[i]
		}
		//
		index += real_read
	}
}

// check_error checks for any opusfile error
fn (od OpusDecoder) check_error<T>(code T) ! {
	match i64(code) {
		file.op_hole {
			return error('There was a hole in the page sequence numbers (e.g., a page was corrupt or
    missing)')
		}
		file.op_eread {
			return error('An underlying read, seek, or tell operation failed when it should have
    succeeded')
		}
		file.op_efault {
			return error('A NULL pointer was passed where one was unexpected, or an
    internal memory allocation failed, or an internal library error was
    encountered')
		}
		file.op_eimpl {
			return error('The stream used a feature that is not implemented, such as an unsupported
    channel family')
		}
		file.op_einval {
			return error('One or more parameters to a function were invalid')
		}
		file.op_enotformat {
			return error('A purported Ogg Opus stream did not begin with an Ogg page, a purported
    header packet did not start with one of the required strings, "OpusHead" or
    "OpusTags", or a link in a chained file was encountered that did not
    contain any logical Opus streams')
		}
		file.op_ebadheader {
			return error('A required header packet was not properly formatted, contained illegal
    values, or was missing altogether')
		}
		file.op_eversion {
			return error('The ID header contained an unrecognized version number')
		}
		file.op_enotaudio {
			return error('')
		}
		file.op_ebadpacket {
			return error('An audio packet failed to decode properly.
   This is usually caused by a multistream Ogg packet where the durations of
    the individual Opus packets contained in it are not all the same')
		}
		file.op_ebadlink {
			return error('We failed to find data we had seen before, or the bitstream structure was
    sufficiently malformed that seeking to the target destination was
    impossible')
		}
		file.op_enoseek {
			return error('An operation that requires seeking was requested on an unseekable stream')
		}
		file.op_ebadtimestamp {
			return error('The first or last granule position of a link failed basic validity checks')
		}
		else {
			return
		}
	}
}
