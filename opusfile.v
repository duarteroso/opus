module opusfile

#flag linux -lopusfile
#flag linux -I/usr/include/opus

#include "opusfile.h"

pub const (
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

[typedef]
struct C.OpusHead {
	version           int
	channel_count     int
	input_sample_rate u32
}

[typedef]
struct C.OggOpusFile {
}

fn C.op_open_file(path &char, error &int) &C.OggOpusFile
fn C.op_free(of &C.OggOpusFile)

fn C.op_seekable(of &C.OggOpusFile) int
fn C.op_channel_count(of &C.OggOpusFile, li int) int

fn C.op_raw_total(of &C.OggOpusFile, li int) i64
fn C.op_pcm_total(of &C.OggOpusFile, li int) i64

fn C.op_head(of &C.OggOpusFile, li int) &C.OpusHead
fn C.op_current_link(of &C.OggOpusFile) int

fn C.op_bitrate(of &C.OggOpusFile, li int) int
fn C.op_bitrate_instant(of &C.OggOpusFile) int

fn C.op_raw_tell(of &C.OggOpusFile) i64
fn C.op_pcm_tell(of &C.OggOpusFile) i64

fn C.op_raw_seek(of &C.OggOpusFile, byte_offset i64) int
fn C.op_pcm_seek(of &C.OggOpusFile, pcm_offset i64) int

fn C.op_set_dither_enabled(of &C.OggOpusFile, enabled int)

fn C.op_read(of &C.OggOpusFile, pcm &i16, size int, li &int) int
fn C.op_read_float(of &C.OggOpusFile, pcm &f32, size int, li &int) int

fn C.op_read_stereo(of &C.OggOpusFile, pcm &i16, size int) int
fn C.op_read_float_stereo(of &C.OggOpusFile, pcm &f32, size int) int
